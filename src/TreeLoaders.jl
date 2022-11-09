module TreeLoaders
using DataFrames
using ArchGDAL
using CSV
using SpatialIndexing
using ProgressMeter
using Statistics


const OSM_ref = Ref{ArchGDAL.ISpatialRef}()

function __init__()
    OSM_ref[] = ArchGDAL.importEPSG(4326; order=:trad)
end
# TODO: this is a duplicate from Composite Buildings. Something like this should idealy
# be integrated into archGDAL itself...
function apply_wsg_84!(geom)
    ArchGDAL.createcoordtrans(OSM_ref[], OSM_ref[]) do trans
        ArchGDAL.transform!(geom, trans)
    end
end

export load_nottingham_trees, tree_param_getter_nottingham
include("nottingham.jl")

include("utils.jl")
end
