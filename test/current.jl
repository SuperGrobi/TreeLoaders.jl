using TreeLoaders
using DataFrames
using CSV
using Plots
using ArchGDAL
using SpatialIndexing
using Folium
using Extents
using CoolWalksUtils

path = "/Users/henrikwolf/Desktop/Masterarbeit/CoolWalksAnalysis/data/exp_raw/spain/barcelona/trees/2023_1T_OD_Arbrat_Parcs_BCN.csv"
path = "/Users/henrikwolf/Desktop/Masterarbeit/CoolWalksAnalysis/data/exp_raw/spain/valencia/arbratge-arbolado.geojson"

load_valencia_trees(path)


tr = CSV.read(joinpath(path, "2015_Street_Tree_Census_-_Tree_Data.csv"), DataFrame)

TreeLoaders.apply_extent!(tr, Extent(X=(-73.99339543820753, -73.95967802174474), Y=(40.69935632811247, 40.727061432104165)))

CSV.write(joinpath(homedir(), "Desktop/Masterarbeit/packages/TreeLoaders.jl/test/data/new_york_treesample.csv"), tr)

tr.borough |> Set


tr.borough |> Set .|> String

metadata(tr)

names(tr)

filter(:borough => ==("Manhattan"), tr)

tr

trees = load_new_york_trees(joinpath(homedir(), "Desktop/Masterarbeit/packages/TreeLoaders.jl/test/data/new_york_treesample.csv"), borough="Brooklyn")
trees = load_new_york_trees(joinpath(homedir(), "Desktop/Masterarbeit/packages/TreeLoaders.jl/test/data/new_york_treesample.csv"))


metadata(trees)

names(trees)
vcat(trees, trees)


names(ans)

names(trees)

trees.geometry[1] |> ArchGDAL.getspatialref

draw(trees.geometry[1:10000], radius=3.5)

s = cast_shadow(trees, tree_param_getter_valencia, [1, 0, 1])

names(ans)
select(trees, [:lon, :lat])

names(trees)
begin
    draw(s.geometry, fill_opacity=0.3, color=:black)
    draw!(trees.pointgeom, radius=3.5)
end


trees = load_nottingham_trees(joinpath(homedir(), "Desktop/Masterarbeit/packages/TreeLoaders.jl/test/data/nottingham_treesample.csv"); extent=Extent(X=(-1.2, -1.165), Y=(52.89, 52.92)))

names(trees)

TreeLoaders.check_tree_dataframe_integrity(trees)