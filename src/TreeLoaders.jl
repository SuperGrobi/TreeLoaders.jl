module TreeLoaders
using CoolWalksUtils
using DataFrames
using ArchGDAL
using CSV
using SpatialIndexing
using ProgressMeter
using Statistics

export load_nottingham_trees, tree_param_getter_nottingham
include("nottingham.jl")

end
