function load_new_york_trees(path; bbox=nothing, borough=nothing)
    df = CSV.read(path, DataFrame, select=["tree_id", "longitude", "latitude", "borough", "status"])
    if !(borough === nothing)
        filter!(:borough => ==(borough), df)
    end
    filter!(:status => ==("Alive"), df)
    select!(df, Not(:status))
    rename!(df, :tree_id => :id, :latitude => :lat, :longitude => :lon)
    apply_bbox!(df, bbox)
    transform!(df, [:lon, :lat] => ByRow((lon, lat) -> apply_wsg_84!(ArchGDAL.createpoint(lon, lat))) => :pointgeom)
    return df
end

tree_param_getter_new_york(row) = (ArchGDAL.getx(row.pointgeom, 0), ArchGDAL.gety(row.pointgeom, 0), 6, 3.5)