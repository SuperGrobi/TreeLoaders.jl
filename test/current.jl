using TreeLoaders

path = "Desktop/Masterarbeit/data/Nottingham/trees/trees_full_rest.csv"

trees = load_nottingham_trees(joinpath(homedir(), path); bbox=(minlat=52.89, minlon=-1.2, maxlat=52.92, maxlon=-1.165))