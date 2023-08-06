@testitem "Nottingham Loaders" begin
    using Extents, CoolWalksUtils, ArchGDAL, DataFrames
    cd(@__DIR__)
    # dataset with originally 3063 trees, cropped to Extent(X=(-1.19,-1.18), Y=(52.9, 52.91))
    trees = load_nottingham_trees("./data/nottingham_treesample.csv")
    @test true  # running the function is some kind of test.
    trees_croped = load_nottingham_trees("./data/nottingham_treesample.csv"; extent=Extent(X=(-1.19, -1.18), Y=(52.9, 52.91)))
    @test true

    @test nrow(trees) <= 3063
    @test nrow(trees_croped) <= 3063
    @test nrow(trees) <= nrow(trees)

    @test ncol(trees) == ncol(trees_croped) == 9

    @test length(Set(trees.lon)) == length(trees.lon)
    @test length(Set(trees.lat)) == length(trees.lat)
    @test length(Set(trees_croped.lon)) == length(trees_croped.lon)
    @test length(Set(trees_croped.lat)) == length(trees_croped.lat)

    TreeLoaders.check_tree_dataframe_integrity(trees)
    @test true
    TreeLoaders.check_tree_dataframe_integrity(trees_croped)
    @test true

    project_local!(trees.geometry, -1.185, 52.905)
    project_local!(trees_croped)

    small_dists = sum(trees.geometry) do p
        distances = [ArchGDAL.distance(p, p2) for p2 in trees.geometry]
        smaller = sum(distances .< 1e-5) - 1
    end
    @test small_dists == 0

    small_dists = sum(trees_croped.geometry) do p
        distances = [ArchGDAL.distance(p, p2) for p2 in trees_croped.geometry]
        smaller = sum(distances .< 1e-5) - 1
    end
    @test small_dists == 0

    project_back!(trees)
    project_back!(trees_croped)
end