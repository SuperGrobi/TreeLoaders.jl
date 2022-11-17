@testset "Nottingham Loaders" begin
    # dataset with originally 3063 trees, cropped to bbox -1.19 < lon < -1.18 && 52.9 < lat < 52.91
    trees = load_nottingham_trees("./data/nottingham_treesample.csv")
    trees_croped = load_nottingham_trees("./data/nottingham_treesample.csv"; bbox=(minlon=-1.19, minlat=52.9, maxlon=-1.18, maxlat=52.91))

    @test nrow(trees) <= 3063
    @test nrow(trees_croped) <= 3063
    @test nrow(trees) <= nrow(trees)

    @test ncol(trees) == ncol(trees_croped) == 12

    @test length(Set(trees.lon)) == length(trees.lon)
    @test length(Set(trees.lat)) == length(trees.lat)
    @test length(Set(trees_croped.lon)) == length(trees_croped.lon)
    @test length(Set(trees_croped.lat)) == length(trees_croped.lat)

    project_local!(trees.pointgeom, -1.185, 52.905)
    project_local!(trees_croped.pointgeom, -1.185, 52.905)

    small_dists = 0
    for p in trees.pointgeom
        distances = [ArchGDAL.distance(p, p2) for p2 in trees.pointgeom]
        smaller = sum(distances .< 1e-5) - 1
        small_dists += smaller
    end

    @test small_dists == 0

    small_dists = 0
    for p in trees_croped.pointgeom
        distances = [ArchGDAL.distance(p, p2) for p2 in trees_croped.pointgeom]
        smaller = sum(distances .< 1e-5) - 1
        small_dists += smaller
    end

    @test small_dists == 0

    rows_to_check =  [477, 551, 591, 408, 201, 264]
    
    for i in rows_to_check
        row = trees[i+111, :]
        @test tree_param_getter_nottingham(row) == (ArchGDAL.getx(row.pointgeom, 0), ArchGDAL.gety(row.pointgeom, 0), row.HEIGHT_N - row.CROWN_SPREAD_RADIUS, row.CROWN_SPREAD_RADIUS)
        row = trees_croped[i, :]
        @test tree_param_getter_nottingham(row) == (ArchGDAL.getx(row.pointgeom, 0), ArchGDAL.gety(row.pointgeom, 0), row.HEIGHT_N - row.CROWN_SPREAD_RADIUS, row.CROWN_SPREAD_RADIUS)
    end

    project_back!(trees.pointgeom)
    project_back!(trees_croped.pointgeom)
end