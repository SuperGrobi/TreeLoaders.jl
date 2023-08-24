"""
    cast_shadows(tree_df, time::DateTime)
    cast_shadows(tree_df, sun_direction::AbstractVector)
    
creates new `DataFrame` with the shadows of the trees in `tree_df`. Shadows are approximated by
an octagon with normal direction along the `sun_direction`. The location and height of the center
of the octagon are informed by the values in the `:height` and `:radius` columns.

# arguments
- `tree_df`: DataFrame with metadata of `observatory`. Is assumend to fulfill the requirements for a tree source.
- `time`: Local `DateTime` for which the shadows shall be calculated. Or:
- `sun_direction`: unit vector pointing towards the sun in local coordinates (x east, y north, z up)

# returns
`DataFrame` with columns
- `id`: id of tree
- `geometry`: `ArchGDAL` polygon representing shadow if tree with `id` in global coordinates

and the same metadata as `tree_df`.
"""
cast_shadows(tree_df, time::DateTime) = cast_shadows(tree_df, local_sunpos(time, metadata(tree_df, "observatory")))

function cast_shadows(tree_df, sun_direction::AbstractVector)
    @assert sun_direction[3] > 0 "the sun is below or on the horizon. Everything is in shadow."
    project_local!(tree_df)

    # construct right hand system with sun direction:
    v1 = normalize(cross(sun_direction, [1, 0, 0]))
    v2 = normalize(cross(v1, sun_direction))

    # create projection of silhouette centered on (0,0) at height 0
    n = 8
    angles = LinRange(0, 2π, n + 1)
    x_plane = cos.(angles)'
    y_plane = sin.(angles)'

    points = x_plane .* v1 + y_plane .* v2

    projected_points = [x[1:2] - sun_direction[1:2] * x[3] / sun_direction[3] for x in eachcol(points)]

    # find offset vector
    offset_vector = -sun_direction[1:2] ./ sun_direction[3]

    shadows_array = Vector{ArchGDAL.IGeometry{ArchGDAL.wkbPolygon}}(undef, nrow(tree_df))

    pbar = ProgressBar(eachrow(tree_df), printing_delay=1.0)
    set_description(pbar, "calucating tree shadows")

    Threads.@threads for row in pbar
        # discover tree parameters
        x, y = GeoInterface.coordinates(row.geometry)
        h, r = row.height, row.radius

        # create shadow
        shadow_outline = [(x + h * offset_vector[1] + r * p[1], y + h * offset_vector[2] + r * p[2]) for p in projected_points]
        # fix numerical problems when start and end ar not exactly the same
        shadow_outline[end] = shadow_outline[1]
        shadow = ArchGDAL.createpolygon(shadow_outline)
        shadows_array[rownumber(row)] = shadow
    end

    # do this on the whole array to avoid creating multiple transformations
    reinterp_crs!(shadows_array, ArchGDAL.getspatialref(tree_df.geometry[1]))

    shadow_df = DataFrame(id=tree_df.id, geometry=shadows_array)
    for key in metadatakeys(tree_df)
        metadata!(shadow_df, key, metadata(tree_df, key); style=:note)
    end

    project_back!(tree_df)
    project_back!(shadow_df)
    return shadow_df
end