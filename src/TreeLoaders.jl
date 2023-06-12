module TreeLoaders
using CoolWalksUtils
using DataFrames
using GeoDataFrames
using ArchGDAL
using CSV
using SpatialIndexing
using ProgressMeter
using Statistics

function apply_bbox!(df, bbox=nothing)
    # trim dataframe to needed size and set metadata
    if bbox === nothing
        bbox = BoundingBox(df.lon, df.lat)
        metadata!(df, "center_lon", (bbox.minlon + bbox.maxlon) / 2; style=:note)
        metadata!(df, "center_lat", (bbox.minlat + bbox.maxlat) / 2; style=:note)
    else
        bbox = BoundingBox(bbox)  # sort arguments
        metadata!(df, "center_lon", (bbox.minlon + bbox.maxlon) / 2; style=:note)
        metadata!(df, "center_lat", (bbox.minlat + bbox.maxlat) / 2; style=:note)
        filter!([:lon, :lat] => (lon, lat) -> in_BoundingBox(lon, lat, bbox), df)
    end
    return df, bbox
end


export load_nottingham_trees, tree_param_getter_nottingham
include("Nottingham.jl")

export load_barcelona_trees, tree_param_getter_barcelona, load_valencia_trees, tree_param_getter_valencia
include("Spain.jl")

export load_new_york_trees, tree_param_getter_new_york
include("NewYork.jl")

export cast_shadow
include("ShadowCasting.jl")
end
