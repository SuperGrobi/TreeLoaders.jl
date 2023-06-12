function load_barcelona_trees(path; bbox=nothing)
    df = CSV.read(path, DataFrame; select=["codi", "latitud", "longitud"])
    rename!(df, :codi => :id, :latitud => :lat, :longitud => :lon)
    transform!(df, [:lon, :lat] => ByRow((lon, lat) -> apply_wsg_84!(ArchGDAL.createpoint(lon, lat))) => :pointgeom)
    apply_bbox!(df, bbox)
    return df
end

tree_param_getter_barcelona(row) = (ArchGDAL.getx(row.pointgeom, 0), ArchGDAL.gety(row.pointgeom, 0), 6, 3.5)

function load_valencia_trees(path; bbox=nothing)
    df = GeoDataFrames.read(path)
    select!(df, :objectid => :id, :geometry => :pointgeom)
    transform!(df, :pointgeom => ByRow(p -> [ArchGDAL.getx(p, 0), ArchGDAL.gety(p, 0)]) => [:lon, :lat])
    apply_bbox!(df, bbox)
    return df
end

tree_param_getter_valencia(row) = tree_param_getter_barcelona(row)