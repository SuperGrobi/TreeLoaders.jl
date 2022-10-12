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
    # TODO: add ArchGDAL points


    if bbox === nothing
        bbox = bounding_box(df.lon, df.lat)
        metadata!(df, "center_lon", (bbox.minlon + bbox.maxlon)/2; style=:note)
        metadata!(df, "center_lat", (bbox.minlat + bbox.maxlat)/2; style=:note)
        return df[:, relevant_names]
    else
        metadata!(df, "center_lon", (bbox.minlon + bbox.maxlon)/2; style=:note)
        metadata!(df, "center_lat", (bbox.minlat + bbox.maxlat)/2; style=:note)
        return filter([:lon, :lat]=>(lon, lat)->in_bbox(lon, lat, bbox), df[:, relevant_names])
    end
end

