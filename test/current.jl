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

trees = load_nottingham_trees(joinpath(homedir(), "Desktop/Masterarbeit/packages/TreeLoaders.jl/test/data/nottingham_treesample.csv"))


plot(trees.geometry)


trees.id |> eltype

using ArchGDAL
DataFrame(geometry=ArchGDAL.IGeometry{ArchGDAL.wkbPolygon}[], id=typeof(trees.id)())

using Dates







using Plots

DataFrame(geometry=ArchGDAL.IGeometry{ArchGDAL.wkbPolygon}[], id=typeof(tree_df.id)())

using LinearAlgebra

normalize([1, 1, 0])

names(trees)

TreeLoaders.check_tree_dataframe_integrity(trees)
trees = load_nottingham_trees(joinpath(homedir(), "Desktop/Masterarbeit/CoolWalksAnalysis/data/exp_raw/clifton/clifton_trees.csv"))
trees = load_valencia_trees(joinpath(homedir(), "Desktop/Masterarbeit/CoolWalksAnalysis/data/exp_raw/spain/valencia/arbratge-arbolado.geojson"))
trees = load_nottingham_trees(joinpath(homedir(), "Desktop/Masterarbeit/packages/TreeLoaders.jl/test/data/nottingham_treesample.csv"))

using TreeLoaders
using Dates
using DataFrames
using LinearAlgebra
using CoolWalksUtils
using ArchGDAL
using Distributed
# addprocs()

using Base.Threads

@everywhere using GeoInterface
using LinearAlgebra

using GeoInterface
using BenchmarkTools

@benchmark cast_shadows(trees, DateTime(2023, 8, 10, 13, 23))
@benchmark cast_shadows2(trees, DateTime(2023, 8, 10, 13, 23))

@profview cast_shadows(trees, local_sunpos(DateTime(2023, 8, 10, 13, 23), metadata(trees, "observatory")))
@profview cast_shadows2(trees, local_sunpos(DateTime(2023, 8, 10, 13, 23), metadata(trees, "observatory")))


cast_shadows(trees, local_sunpos(DateTime(2023, 8, 10, 13, 23), metadata(trees, "observatory")))
cast_shadows2(trees, local_sunpos(DateTime(2023, 8, 10, 13, 23), metadata(trees, "observatory")))


project_local!(s1)
project_local!(s2)
project_local!(s3)

all(s1.id .≈ s2.id)

gas = ArchGDAL.geomarea.(s1.geometry) .≈ ArchGDAL.geomarea.(s2.geometry)


extrema(gas)
findall(!, gas)
using Plots
plot(s1.geometry[1036])
plot!(s2.geometry[1036])

using ProgressMeter
using ProgressBars


cast_shadows2(tree_df, time::DateTime) = cast_shadows2(tree_df, local_sunpos(time, metadata(tree_df, "observatory")))
function cast_shadows2(tree_df, sun_direction::AbstractVector)
    @assert sun_direction[3] > 0 "the sun is below or on the horizon. Everything is in shadow."
    project_local!(tree_df)

    # construct right hand system with sun direction:
    v1 = normalize(cross(sun_direction, [1, 0, 0]))
    v2 = normalize(cross(v1, sun_direction))

    # create projection of silhouette centered on (0,0) at height 0
    n = 8
    angles = LinRange(0, 2π, n + 1)
    x_plane = cos.(angles)'
    y_plane = sin.(angles)'

    points = x_plane .* v1 + y_plane .* v2

    projected_points = [x[1:2] - sun_direction[1:2] * x[3] / sun_direction[3] for x in eachcol(points)]

    # find offset vector
    offset_vector = -sun_direction[1:2] ./ sun_direction[3]

    shadows_array = Vector{ArchGDAL.IGeometry{ArchGDAL.wkbPolygon}}(undef, nrow(tree_df))

    p = Progress(nrow(tree_df), 1.0, "calcuating shadows2")

    Threads.@threads for row in eachrow(tree_df)
        # discover tree parameters
        x, y = GeoInterface.coordinates(row.geometry)
        h, r = row.height, row.radius

        # create shadow
        shadow_outline = [(x + h * offset_vector[1] + r * p[1], y + h * offset_vector[2] + r * p[2]) for p in projected_points]
        # fix numerical problems when start and end ar not exactly the same
        shadow_outline[end] = shadow_outline[1]
        shadow = ArchGDAL.createpolygon(shadow_outline)
        reinterp_crs!(shadow, ArchGDAL.getspatialref(row.geometry))
        shadows_array[rownumber(row)] = shadow
        next!(p)
    end
    finish!(p)

    shadow_df = DataFrame(id=tree_df.id, geometry=shadows_array)
    for key in metadatakeys(tree_df)
        metadata!(shadow_df, key, metadata(tree_df, key); style=:note)
    end
    project_back!(tree_df)
    project_back!(shadow_df)
    return shadow_df
end

transform!(trees, :geometry => ByRow(g -> ArchGDAL.geomarea(ArchGDAL.buffer(g, 10))) => :ga, :geometry => ByRow(g -> (ArchGDAL.geomarea(ArchGDAL.buffer(g, 10)) * threadid())) => :threadid)

