function bounding_box(lon, lat)
    min_lat = Inf
    min_lon = Inf
    max_lat = -Inf
    max_lon = -Inf
    for (lon, lat) in zip(lon, lat)
        min_lat > lat && (min_lat = lat)
        max_lat < lat && (max_lat = lat)
        min_lon > lon && (min_lon = lon)
        max_lon < lon && (max_lon = lon)
    end
    return (minlat=min_lat, minlon=min_lon, maxlat=max_lat, maxlon=max_lon)
end