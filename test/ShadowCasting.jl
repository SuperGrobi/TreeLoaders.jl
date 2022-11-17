@testset "ShadowCasting.jl" begin
    trees_nottingham = load_nottingham_trees("./data/nottingham_treesample.csv")
    
    testdata = [trees_nottingham]
    data_getters = [tree_param_getter_nottingham]

    for (trees, getter) in zip(testdata, data_getters)
        shadows = cast_shadow(trees, getter, [1, 0, 1])

        @test nrow(trees) == nrow(shadows)

        project_local!(trees.pointgeom, -1.185, 52.905)
        project_local!(shadows.geometry, -1.185, 52.905)
        
        rows_to_check = [123, 993, 246, 23, 154, 408, 100, 1000, 543, 890, 234, 145]
        for i in rows_to_check
            shadow_row = shadows[i, :]
            tree_row = trees[i, :]
            @test shadow_row.id == tree_row.id

            _, _, h, r = getter(tree_row)
            # add more tests??
            @test ArchGDAL.geomarea(shadow_row.geometry) >= 2*sqrt(2) * r
            @test ArchGDAL.distance(tree_row.pointgeom, shadow_row.geometry) <= abs(h-r)
        end
    end
end