"""
    load_barcelona_trees(path; extent=nothing)

Loads tree data from barcelona. Downloaded from
- `https://opendata-ajuntament.barcelona.cat/data/en/dataset/arbrat-viari/resource/7613c24b-33ab-4671-8f01-c509c653c645`
- `https://opendata-ajuntament.barcelona.cat/data/en/dataset/arbrat-parcs/resource/c569ee47-f734-4659-aebc-3a7b9f453807`
- `https://opendata-ajuntament.barcelona.cat/data/en/dataset/arbrat-zona/resource/2ab05031-0efa-4f60-836f-a125c6be0061`

Sets `height=6.0m` and `radius=3.5m`, as these values are not given in the dataset.

# arguments
- `path`: Path to the file with the dataset
- `extent`: `Extents.Extent`, specifying a clipping range for the Dataset. Use `X` for `lon` and `Y` for `lat`.

# returns
DataFrame conforming to the requirements needed to be considered a source of tree data.
"""
function load_barcelona_trees(path; extent=nothing)
    df = CSV.read(path, DataFrame; select=["codi", "latitud", "longitud"])
    rename!(df, :codi => :id, :latitud => :lat, :longitud => :lon)
    transform!(df, [:lon, :lat] => ByRow((lon, lat) -> apply_wsg_84!(ArchGDAL.createpoint(lon, lat))) => :geometry)
    apply_extent!(df, extent)

    df.height .= 6.0
    df.radius .= 3.5

    set_observatory!(df, "BarcelonaTreeObservatory", tz"Europe/Madrid")
    check_tree_dataframe_integrity(df)
    return df
end

"""
    load_valencia_trees(path; extent=nothing)

Loads tree data from valencia. Downloaded from `https://valencia.opendatasoft.com/explore/dataset/arbratge-arbolado/export/` (using GeoJSON).

Sets `height=6.0m` and `radius=3.5m`, as these values are not given in the dataset.

# arguments
- `path`: Path to the file with the dataset
- `extent`: `Extents.Extent`, specifying a clipping range for the Dataset. Use `X` for `lon` and `Y` for `lat`.

# returns
DataFrame conforming to the requirements needed to be considered a source of tree data.
"""
function load_valencia_trees(path; extent=nothing)
    df = GeoDataFrames.read(path)
    select!(df, :objectid => :id, :geometry)
    transform!(df, :geometry => ByRow(p -> [ArchGDAL.getx(p, 0), ArchGDAL.gety(p, 0)]) => [:lon, :lat])
    apply_extent!(df, extent)

    df.height .= 6.0
    df.radius .= 3.5

    set_observatory!(df, "ValenciaTreeObservatory", tz"Europe/Madrid")
    check_tree_dataframe_integrity(df)
    return df
end
