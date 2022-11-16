function cast_shadow(tree_df, param_getter::Function, sun_direction::AbstractArray)
    @assert sun_direction[3] > 0 "the sun is below or on the horizon. Everything is in shadow."
    project_local!(tree_df.pointgeom, metadata(tree_df, "center_lon"), metadata(tree_df, "center_lat"))

    # construct right hand system with sun direction:
    v1 = unit(cross(sun_direction, [1,0,0]))
    v2 = unit(cross(v1, sun_direction))

    # create projection of silhouette centered on (0,0) at height 0
    n = 8
    angles = LinRange(0, 2π, n+1)
    x_plane = cos.(angles)'
    y_plane = sin.(angles)'

    points = x_plane .* v1 + y_plane .* v2

    projected_points = [x[1:2] - sun_direction[1:2] * x[3]/sun_direction[3] for x in eachcol(points)]
    
    # find offset vector
    offset_vector = - sun_direction[1:2] ./ sun_direction[3]

    shadow_df = DataFrame(geometry=ArchGDAL.IGeometry{ArchGDAL.wkbPolygon}[], id=typeof(tree_df.id)())
    for key in metadatakeys(tree_df)
        metadata!(shadow_df, key, metadata(tree_df, key); style=:note)
    end
    
    @showprogress 1 for row in eachrow(tree_df)
        # discover tree parameters
        x, y, h, r = param_getter(row)

        # create shadow
        shadow = ArchGDAL.createpolygon([(x + h*offset_vector[1] + r*p[1], y + h*offset_vector[2] + r*p[2]) for p in projected_points])
        reinterp_crs!(shadow, ArchGDAL.getspatialref(row.pointgeom))
        push!(shadow_df, [shadow, row.id])
    end

    project_back!(tree_df.pointgeom)
    project_back!(shadow_df.geometry)
    return shadow_df
end