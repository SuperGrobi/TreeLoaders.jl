

function load_nottingham_trees(path; bbox=nothing)
    df = CSV.read(path, DataFrame)

    name_map = Dict(
        :OBJECTID => :id,
        :LONG => :lon,
        :LAT => :lat
    )
    rename!(df, name_map)
    filter!(:FELLED=>==("No"), df)
    filter!([:CROWN_SPREAD_RADIUS, :HEIGHT_N]=>(csr, h)->!ismissing(csr) && !ismissing(h), df)

    relevant_names = [:id, :TREETYPE, :SPECIES, :COMMONNAME, :HEIGHT, :SPREAD, :CROWN_SPREAD, :CROWN_SPREAD_RADIUS, :HEIGHT_N, :lon, :lat]
    
    # trim dataframe to needed size and set metadata
    if bbox === nothing
        bbox = BoundingBox(df.lon, df.lat)
        metadata!(df, "center_lon", (bbox.minlon + bbox.maxlon)/2; style=:note)
        metadata!(df, "center_lat", (bbox.minlat + bbox.maxlat)/2; style=:note)
        df = df[:, relevant_names]
    else
        metadata!(df, "center_lon", (bbox.minlon + bbox.maxlon)/2; style=:note)
        metadata!(df, "center_lat", (bbox.minlat + bbox.maxlat)/2; style=:note)
        df = filter([:lon, :lat]=>(lon, lat)->in_BoundingBox(lon, lat, bbox), df[:, relevant_names])
    end
    
    # add ArchGDAL points
    df.pointgeom = ArchGDAL.createpoint.(df.lon, df.lat)
    apply_wsg_84!.(df.pointgeom)

    # project points to local
    project_local!(df.pointgeom, metadata(df, "center_lon"), metadata(df, "center_lat"))

    # build r-tree with points
    rt = RTree{Float64, 2}(Int, Int)
    for row in eachrow(df)
        x = ArchGDAL.getx(row.pointgeom, 0)
        y = ArchGDAL.gety(row.pointgeom, 0)
        insert!(rt, SpatialIndexing.Rect((x,y), (x,y)), row.id, row.id)
    end
    
    # find all the points very close to one another, throw all but one of them out...
    seen_ids = Int64[]
    reduced_df = empty(df)
    for row in eachrow(df)#[1:5]
        point = row.pointgeom
        x = ArchGDAL.getx(point, 0)
        y = ArchGDAL.gety(point, 0)
        BUFFER = 1e-5
        intersection = intersects_with(rt, SpatialIndexing.Rect((x-BUFFER, y-BUFFER), (x+BUFFER, y+BUFFER)))

        # use only ids which have not yet been looked at
        ids = [i.id for i in intersection if !(i.id in seen_ids)]
        length(ids) == 0 && continue
        # add all ids to seen_ids
        for id in ids
            push!(seen_ids, id)
        end
        
        if length(ids) > 1
            subframe = df[findall(in(ids), df.id),:]
            if allequal(subframe.lon) && allequal(subframe.lat)
                row_to_add = subframe[1,:]
                row_to_add.CROWN_SPREAD = mean(subframe.CROWN_SPREAD)
                row_to_add.CROWN_SPREAD_RADIUS = mean(subframe.CROWN_SPREAD_RADIUS)
                row_to_add.HEIGHT_N = mean(subframe.HEIGHT_N)
                push!(reduced_df, row_to_add)
            else
                @warn "the locations in the subframe are not the same"
            end
        elseif length(ids) == 1
            push!(reduced_df, row)
        end
    end

    # project back
    project_back!(reduced_df.pointgeom)
    return reduced_df
end

function tree_param_getter_nottingham(row)
    x = ArchGDAL.getx(row.pointgeom, 0)
    y = ArchGDAL.gety(row.pointgeom, 0)
    r = row.CROWN_SPREAD_RADIUS
    height = row.HEIGHT_N - r
    return (x, y, height, r)
end