function in_bbox(lon, lat, bbox)
    lon_in = bbox.minlon <= lon <= bbox.maxlon
    lat_in = bbox.minlat <= lat <= bbox.maxlat
    return lon_in && lat_in
end


function load_nottingham_trees(path; bbox=nothing)
    df = CSV.read(path, DataFrame)

    name_map = Dict(
        :OBJECTID => :id,
        :LONG => :lon,
        :LAT => :lat
    )
    rename!(df, name_map)

    relevant_names = [:id, :TREETYPE, :SPECIES, :COMMONNAME, :HEIGHT, :SPREAD, :CROWN_SPREAD, :CROWN_SPREAD_RADIUS, :HEIGHT_N, :lon, :lat]

    if bbox === nothing
        return df[:, relevant_names]
    else
        return filter([:lon, :lat]=>(lon, lat)->in_bbox(lon, lat, bbox), df[:, relevant_names])
    end
end