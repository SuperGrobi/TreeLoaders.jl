module TreeLoaders
using CoolWalksUtils
using DataFrames
using GeoDataFrames
using ArchGDAL
using CSV
using SpatialIndexing
using ProgressMeter
using Statistics
using TimeZones
using Extents
using Graphs
using SparseArrays

"""
    apply_extent!(df, extent)

trim `df` to only contain trees which are in `extent`. (uses the `:lon` and `:lat` columns).
"""
function apply_extent!(df, extent)
    # trim dataframe to given size
    if extent !== nothing
        filter!([:lon, :lat] => (lon, lat) -> extent_contains(extent, lon, lat), df)
    end
end

"""
    set_observatory!(df, name, timezone)

creates a `CoolWalksUtils.ShadowObservatory` and adds it to the metadata of `df`.
`lon` and `lat` are taken to be the center of the `Extent` of the dataset.
"""
function set_observatory!(df, name, timezone)
    center = extent_center(geoiter_extent(df.lon, df.lat))
    obs = ShadowObservatory(name, center.X, center.Y, timezone)
    metadata!(df, "observatory", obs; style=:note)
    return df
end

"""
    check_tree_dataframe_integrity(df)

Checks if `df` conforms to the technical requirements needed to be considered as a source for tree data.
"""
function check_tree_dataframe_integrity(df)
    colnames = Symbol.(names(df))
    needed_names = [:id, :lon, :lat, :height, :radius, :geometry]
    for i in needed_names
        @assert i in colnames "no column of df is named $i."
    end
    for g in df.geometry
        @assert g isa ArchGDAL.IGeometry{ArchGDAL.wkbPoint} "not all entries in the :geometry column are ArchGDAL points."
    end

    @assert "observatory" in keys(metadata(df)) "the dataframe has no observatory metadata."
    @assert metadata(df, "observatory") isa ShadowObservatory "the provided obervatory is not of type ShadowObservatory."
end


export load_nottingham_trees
include("Nottingham.jl")

export load_barcelona_trees, load_valencia_trees
include("Spain.jl")

export load_new_york_trees
include("NewYork.jl")

export cast_shadows
include("ShadowCasting.jl")
end
