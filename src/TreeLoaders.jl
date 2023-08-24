module TreeLoaders
using CoolWalksUtils
using DataFrames
using GeoDataFrames
using ArchGDAL
using CSV
using SpatialIndexing

using ProgressMeter
using ProgressBars

using Statistics
using TimeZones
using Extents
using Graphs
using SparseArrays
using Dates
using LinearAlgebra
using GeoInterface

"""
    check_tree_dataframe_integrity(df)

Checks if `df` conforms to the technical requirements needed to be considered as a source for tree data.
"""
function check_tree_dataframe_integrity(df)
    colnames = Symbol.(names(df))
    needed_names = [:id, :lon, :lat, :height, :radius, :geometry]
    for i in needed_names
        @assert i in colnames "no column of df is named \"$i\"."
    end
    for g in df.geometry
        @assert g isa ArchGDAL.IGeometry{ArchGDAL.wkbPoint} "not all entries in the :geometry column are ArchGDAL points."
    end

    @assert "observatory" in keys(metadata(df)) "the dataframe has no \"observatory\" metadata."
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
