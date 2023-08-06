"""
    load_nottingham_trees(path; extent=nothing)

Loads tree data from nottingham. Downloaded from `https://maps164.nottinghamcity.gov.uk/server/rest/services/OpenData/OpenData/MapServer/91`.

merges the considerable amount of duplicate trees in the original dataset by distance (trees closer than 1e-4m are considered equal)

# arguments
- `path`: Path to the file with the dataset
- `extent`: `Extents.Extent`, specifying a clipping range for the Dataset. Use `X` for `lon` and `Y` for `lat`.

# returns
DataFrame conforming to the requirements needed to be considered a source of tree data.
"""
function load_nottingham_trees(path; extent=nothing)
    df = CSV.read(path, DataFrame)

    name_map = Dict(
        :OBJECTID => :id,
        :LONG => :lon,
        :LAT => :lat,
        :HEIGHT_N => :height,
        :CROWN_SPREAD_RADIUS => :radius
    )
    rename!(df, name_map)
    filter!(:FELLED => ==("No"), df)
    dropmissing!(df, [:radius, :height])

    relevant_names = [:id, :lon, :lat, :height, :radius, :TREETYPE, :SPECIES, :COMMONNAME]
    select!(df, relevant_names)

    apply_extent!(df, extent)
    set_observatory!(df, "NottinghamTreesObservatory", tz"Europe/London")

    # add ArchGDAL points
    df.geometry = ArchGDAL.createpoint.(df.lon, df.lat)
    apply_wsg_84!.(df.geometry)

    # project points to local
    project_local!(df)

    # build r-tree with points
    rt = build_rtree(df)
    adj = spzeros(Bool, (nrow(df), nrow(df)))

    BUFFER = 1e-5
    # build adjacency matrix
    for row in eachrow(df)
        intersections = intersects_with(rt, rect_from_geom(row.geometry, buffer=BUFFER))
        for intersection in intersections
            adj[rownumber(row), intersection.id] = true
        end
    end

    # build graph and find connected components
    comps = connected_components(SimpleGraph(adj))
    groups = zeros(Int, nrow(df))
    for (i, com) in enumerate(comps)
        groups[com] .= i
    end
    df.components = groups

    # combine clusters together
    gdf = groupby(df, :components)
    mean_cols = [:height, :radius]
    first_cols = Not([mean_cols; :geometry; :components])
    reduced_df = combine(
        gdf,
        first_cols .=> first .=> first_cols,
        mean_cols .=> mean .=> mean_cols,
        :geometry => (g -> ArchGDAL.clone(first(g))) => :geometry
    )

    #postprocess
    select!(reduced_df, Not(:components))
    transform!(reduced_df, [:height, :radius] => ByRow(-) => :height)

    # project back
    project_back!(reduced_df)
    check_tree_dataframe_integrity(reduced_df)
    return reduced_df
end