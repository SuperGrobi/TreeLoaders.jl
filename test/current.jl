using TreeLoaders
using DataFrames
using Plots
using ArchGDAL
using SpatialIndexing
using Folium
using CoolWalksUtils

path = "/Users/henrikwolf/Desktop/Masterarbeit/CoolWalksAnalysis/data/exp_raw/manhattan/"

tr = CSV.read(joinpath(path, "2015_Street_Tree_Census_-_Tree_Data.csv"), DataFrame)

names(tr)

filter(:borough => ==("Manhattan"), tr)

tr

trees = load_new_york_trees(joinpath(path, "2015_Street_Tree_Census_-_Tree_Data.csv"), borough="Manhattan")

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




trees = load_nottingham_trees(joinpath(homedir(), path); bbox=(minlon=-1.2, minlat=52.89, maxlon=-1.165, maxlat=52.92));

shadows = cast_shadow(trees, tree_param_getter_nottingham, [1, 0.4, 0.5])

TreeLoaders.project_local!(trees.pointgeom, metadata(trees, "center_lon"), metadata(trees, "center_lat"))

trees
fr = trees_full[1, :]
fr.id = 0
fr
trees_full
trees_reduced
scatter(trees.pointgeom, ms=5rand(length(trees.pointgeom))', ratio=1)


rt = RTree{Float64,2}(Int, String)
for row in eachrow(trees)
    x = ArchGDAL.getx(row.pointgeom, 0)
    y = ArchGDAL.gety(row.pointgeom, 0)
    insert!(rt, SpatialIndexing.Rect((x, y), (x, y)), row.id, string(row.id))
end

n = 1
buffer = 1e-5
x = ArchGDAL.getx(trees.pointgeom[n], 0)
y = ArchGDAL.gety(trees.pointgeom[n], 0)

intersection = intersects_with(rt, SpatialIndexing.Rect((x - buffer, y - buffer), (x + buffer, y + buffer)));
ids = [i.id for i in intersection]


rt1 = RTree{Float64,2}(Int, Int)
for i in 1:40
    x = rand()
    y = rand()
    insert!(rt1, SpatialIndexing.Rect((x, y), (x, y)), i, i)
end


nrow(trees)