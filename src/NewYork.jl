"""
    load_new_york_trees(path; extent=nothing, borough=nothing)

Loads tree data from New York. Downloaded from `https://data.cityofnewyork.us/Environment/2015-Street-Tree-Census-Tree-Data/uvpi-gqnh`.

# arguments
- `path`: Path to the file with the dataset
- `extent`: `Extents.Extent`, specifying a clipping range for the Dataset. Use `X` for `lon` and `Y` for `lat`.
- `borough`: filter trees by borough. Select from: `["Manhattan", "Brooklyn", "Queens", "Staten Island", "Bronx"]`

# returns
DataFrame conforming to the requirements needed to be considered a source of tree data.
"""
function load_new_york_trees(path; extent=nothing, borough=nothing)
    df = CSV.read(path, DataFrame, select=["tree_id", "longitude", "latitude", "borough", "status"])
    if !(borough === nothing)
        filter!(:borough => ==(borough), df)
    end
    filter!(:status => ==("Alive"), df)
    select!(df, Not(:status))
    rename!(df, :tree_id => :id, :latitude => :lat, :longitude => :lon)
    apply_extent!(df, extent)
    observatoryname = isnothing(borough) ? "NewYork" : borough
    set_observatory!(df, "$(observatoryname)TreesObservatory", tz"America/New_York")
    transform!(df, [:lon, :lat] => ByRow((lon, lat) -> apply_wsg_84!(ArchGDAL.createpoint(lon, lat))) => :geometry)

    df.height .= 6.0
    df.radius .= 3.5

    check_tree_dataframe_integrity(df)
    return df
end