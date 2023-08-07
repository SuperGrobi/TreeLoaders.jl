@testitem "ShadowCasting.jl" begin
    using CoolWalksUtils, ArchGDAL, DataFrames
    cd(@__DIR__)
    trees = load_nottingham_trees("./data/nottingham_treesample.csv")


    shadows = cast_shadows(trees, [1, 0, 1])

    @test nrow(trees) == nrow(shadows)

    project_local!(trees)
    project_local!(shadows)

    rows_to_check = [123, 993, 246, 23, 154, 408, 100, 1000, 543, 890, 234, 145]
    for i in rows_to_check
        shadow_row = shadows[i, :]
        tree_row = trees[i, :]
        @test shadow_row.id == tree_row.id

        h, r = tree_row.height, tree_row.radius
        # add more tests??
        @test ArchGDAL.geomarea(shadow_row.geometry) >= 2 * sqrt(2) * r
        @test ArchGDAL.distance(tree_row.geometry, shadow_row.geometry) <= abs(h - r)
    end
end