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

function project_local!(geo_column, center_lon, center_lat)
    projstring = "+proj=tmerc +lon_0=$center_lon +lat_0=$center_lat"
    #println(projstring)
    src = ArchGDAL.getspatialref(first(geo_column))
    dest = ArchGDAL.importPROJ4(projstring)
    ArchGDAL.createcoordtrans(trans->project_geo_column!(geo_column, trans), src, dest)
end

function project_back!(geo_column)
    src = ArchGDAL.getspatialref(first(geo_column))
    ArchGDAL.createcoordtrans(trans->project_geo_column!(geo_column, trans), src, OSM_ref[])
end

function project_geo_column!(geo_column, trans)
    for geom in geo_column
        ArchGDAL.transform!(geom, trans)
    end
end