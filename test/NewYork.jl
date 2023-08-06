@testitem "New York Loaders" begin
    using Extents, CoolWalksUtils, ArchGDAL, DataFrames
    cd(@__DIR__)
    # dataset with originally 3063 trees, cropped to Extent(X=(-73.99339543820753, -73.95967802174474), Y=(40.69935632811247, 40.727061432104165))
    trees = load_new_york_trees("./data/new_york_treesample.csv")
    @test true  # running the function is some kind of test.
    trees_croped = load_new_york_trees("./data/new_york_treesample.csv"; extent=Extent(X=(-73.99, -73.96), Y=(40.67, 40.72)))
    @test true
    trees_manhattan = load_new_york_trees("./data/new_york_treesample.csv"; borough="Manhattan")
    @test true

    @test nrow(trees) == 5647
    @test nrow(trees_croped) == 2956
    @test nrow(trees_manhattan) == 3320


    @test ncol(trees) == ncol(trees_croped) == ncol(trees_manhattan) == 7

    TreeLoaders.check_tree_dataframe_integrity(trees)
    @test true
    TreeLoaders.check_tree_dataframe_integrity(trees_croped)
    @test true
    TreeLoaders.check_tree_dataframe_integrity(trees_manhattan)
    @test true

    project_local!(trees)
    project_local!(trees_croped)
    project_local!(trees_manhattan)

    project_back!(trees)
    project_back!(trees_croped)
    project_back!(trees_manhattan)
end