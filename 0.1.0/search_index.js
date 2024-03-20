var documenterSearchIndex = {"docs":
[{"location":"NewYork/#Loading-New-York-Trees","page":"New York","title":"Loading New York Trees","text":"","category":"section"},{"location":"NewYork/#Introduction","page":"New York","title":"Introduction","text":"","category":"section"},{"location":"NewYork/","page":"New York","title":"New York","text":"We load the tree data from the open data server of the city of new york, available here: new york tree data.","category":"page"},{"location":"NewYork/","page":"New York","title":"New York","text":"Since there are no height and radius data available, we set them constant to height=6m and radius=3.5m. These values are the mean values found in the Nottingham dataset.","category":"page"},{"location":"NewYork/#API","page":"New York","title":"API","text":"","category":"section"},{"location":"NewYork/","page":"New York","title":"New York","text":"Pages = [\"NewYork.md\"]","category":"page"},{"location":"NewYork/","page":"New York","title":"New York","text":"Modules = [TreeLoaders]\nPages = [\"NewYork.jl\"]","category":"page"},{"location":"NewYork/#TreeLoaders.load_new_york_trees-Tuple{Any}","page":"New York","title":"TreeLoaders.load_new_york_trees","text":"load_new_york_trees(path; extent=nothing, borough=nothing)\n\nLoads tree data from New York. Downloaded from https://data.cityofnewyork.us/Environment/2015-Street-Tree-Census-Tree-Data/uvpi-gqnh.\n\nSets height=6.0m and radius=3.5m, as these values are not given in the dataset.\n\narguments\n\npath: Path to the file with the dataset\nextent: Extents.Extent, specifying a clipping range for the Dataset. Use X for lon and Y for lat.\nborough: filter trees by borough. Select from: [\"Manhattan\", \"Brooklyn\", \"Queens\", \"Staten Island\", \"Bronx\"]\n\nreturns\n\nDataFrame conforming to the requirements needed to be considered a source of tree data.\n\n\n\n\n\n","category":"method"},{"location":"ShadowCasting/#Shadow-Casting","page":"Shadow Casting","title":"Shadow Casting","text":"","category":"section"},{"location":"ShadowCasting/#Introduction","page":"Shadow Casting","title":"Introduction","text":"","category":"section"},{"location":"ShadowCasting/","page":"Shadow Casting","title":"Shadow Casting","text":"For trees, we assume their crown to be circular/spherical (approxiated by an octagon) with radius :radius, whose normal is pointed towards the sun, centered at :height above the ground. This object is projected onto the plane to give the final shadow.","category":"page"},{"location":"ShadowCasting/","page":"Shadow Casting","title":"Shadow Casting","text":"(Image: Schematic of shadowcasting for trees)","category":"page"},{"location":"ShadowCasting/#API","page":"Shadow Casting","title":"API","text":"","category":"section"},{"location":"ShadowCasting/","page":"Shadow Casting","title":"Shadow Casting","text":"Pages = [\"ShadowCasting.md\"]","category":"page"},{"location":"ShadowCasting/","page":"Shadow Casting","title":"Shadow Casting","text":"Modules = [TreeLoaders]\nPages = [\"ShadowCasting.jl\"]","category":"page"},{"location":"ShadowCasting/#TreeLoaders.cast_shadows-Tuple{Any, Dates.DateTime}","page":"Shadow Casting","title":"TreeLoaders.cast_shadows","text":"cast_shadows(tree_df, time::DateTime)\ncast_shadows(tree_df, sun_direction::AbstractVector)\n\ncreates new DataFrame with the shadows of the trees in tree_df. Shadows are approximated by an octagon with normal direction along the sun_direction. The location and height of the center of the octagon are informed by the values in the :height and :radius columns.\n\narguments\n\ntree_df: DataFrame with metadata of observatory. Is assumend to fulfill the requirements for a tree source.\ntime: Local DateTime for which the shadows shall be calculated. Or:\nsun_direction: unit vector pointing towards the sun in local coordinates (x east, y north, z up)\n\nreturns\n\nDataFrame with columns\n\nid: id of tree\ngeometry: ArchGDAL polygon representing shadow if tree with id in global coordinates\n\nand the same metadata as tree_df.\n\n\n\n\n\n","category":"method"},{"location":"Spain/#Loading-Spanish-Trees","page":"Spain","title":"Loading Spanish Trees","text":"","category":"section"},{"location":"Spain/#Barcelona","page":"Spain","title":"Barcelona","text":"","category":"section"},{"location":"Spain/","page":"Spain","title":"Spain","text":"We load the tree data from the open data server of barcelona. This Dataset comes in three different subfiles:","category":"page"},{"location":"Spain/","page":"Spain","title":"Spain","text":"Street Trees\nPark Trees\nZone Trees","category":"page"},{"location":"Spain/","page":"Spain","title":"Spain","text":"Since there are no height and radius data available, we set them constant to height=6m and radius=3.5m. These values are the mean values found in the Nottingham dataset.","category":"page"},{"location":"Spain/#Valencia","page":"Spain","title":"Valencia","text":"","category":"section"},{"location":"Spain/","page":"Spain","title":"Spain","text":"We load the tree data from the open data server of valencia, available here: valencia tree data.","category":"page"},{"location":"Spain/","page":"Spain","title":"Spain","text":"Since there are no height and radius data available, we set them constant to height=6m and radius=3.5m. These values are the mean values found in the Nottingham dataset.","category":"page"},{"location":"Spain/#API","page":"Spain","title":"API","text":"","category":"section"},{"location":"Spain/","page":"Spain","title":"Spain","text":"Pages = [\"Spain.md\"]","category":"page"},{"location":"Spain/","page":"Spain","title":"Spain","text":"Modules = [TreeLoaders]\nPages = [\"Spain.jl\"]","category":"page"},{"location":"Spain/#TreeLoaders.load_barcelona_trees-Tuple{Any}","page":"Spain","title":"TreeLoaders.load_barcelona_trees","text":"load_barcelona_trees(path; extent=nothing)\n\nLoads tree data from barcelona. Downloaded from\n\nhttps://opendata-ajuntament.barcelona.cat/data/en/dataset/arbrat-viari/resource/7613c24b-33ab-4671-8f01-c509c653c645\nhttps://opendata-ajuntament.barcelona.cat/data/en/dataset/arbrat-parcs/resource/c569ee47-f734-4659-aebc-3a7b9f453807\nhttps://opendata-ajuntament.barcelona.cat/data/en/dataset/arbrat-zona/resource/2ab05031-0efa-4f60-836f-a125c6be0061\n\nSets height=6.0m and radius=3.5m, as these values are not given in the dataset.\n\narguments\n\npath: Path to the file with the dataset\nextent: Extents.Extent, specifying a clipping range for the Dataset. Use X for lon and Y for lat.\n\nreturns\n\nDataFrame conforming to the requirements needed to be considered a source of tree data.\n\n\n\n\n\n","category":"method"},{"location":"Spain/#TreeLoaders.load_valencia_trees-Tuple{Any}","page":"Spain","title":"TreeLoaders.load_valencia_trees","text":"load_valencia_trees(path; extent=nothing)\n\nLoads tree data from valencia. Downloaded from https://valencia.opendatasoft.com/explore/dataset/arbratge-arbolado/export/ (using GeoJSON).\n\nSets height=6.0m and radius=3.5m, as these values are not given in the dataset.\n\narguments\n\npath: Path to the file with the dataset\nextent: Extents.Extent, specifying a clipping range for the Dataset. Use X for lon and Y for lat.\n\nreturns\n\nDataFrame conforming to the requirements needed to be considered a source of tree data.\n\n\n\n\n\n","category":"method"},{"location":"Nottingham/#Loading-Nottingham-Trees","page":"Nottingham","title":"Loading Nottingham Trees","text":"","category":"section"},{"location":"Nottingham/#Introduction","page":"Nottingham","title":"Introduction","text":"","category":"section"},{"location":"Nottingham/","page":"Nottingham","title":"Nottingham","text":"We load the tree data from the open data server of the city concil of nottingham, available here: nottingham tree data.","category":"page"},{"location":"Nottingham/","page":"Nottingham","title":"Nottingham","text":"As there are a lot of duplicates in this dataset, we do some preliminary cleanup in load_nottingham_trees. During this process, we also drop a lot of irrelevant columns and create a few new ones. All trees which are (transitively) within a square of 2e-5 meter edge length around a tree are considered the same tree. We average over all numerical data and keep the first entry for every other one.","category":"page"},{"location":"Nottingham/#API","page":"Nottingham","title":"API","text":"","category":"section"},{"location":"Nottingham/","page":"Nottingham","title":"Nottingham","text":"Pages = [\"Nottingham.md\"]","category":"page"},{"location":"Nottingham/","page":"Nottingham","title":"Nottingham","text":"Modules = [TreeLoaders]\nPages = [\"Nottingham.jl\"]","category":"page"},{"location":"Nottingham/#TreeLoaders.load_nottingham_trees-Tuple{Any}","page":"Nottingham","title":"TreeLoaders.load_nottingham_trees","text":"load_nottingham_trees(path; extent=nothing)\n\nLoads tree data from nottingham. Downloaded from https://maps164.nottinghamcity.gov.uk/server/rest/services/OpenData/OpenData/MapServer/91.\n\nmerges the considerable amount of duplicate trees in the original dataset by distance (trees closer than 1e-5m are considered equal)\n\narguments\n\npath: Path to the file with the dataset\nextent: Extents.Extent, specifying a clipping range for the Dataset. Use X for lon and Y for lat.\n\nreturns\n\nDataFrame conforming to the requirements needed to be considered a source of tree data.\n\n\n\n\n\n","category":"method"},{"location":"","page":"Home","title":"Home","text":"CurrentModule = TreeLoaders","category":"page"},{"location":"#TreeLoaders","page":"Home","title":"TreeLoaders","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for TreeLoaders.","category":"page"},{"location":"","page":"Home","title":"Home","text":"This package provides functions to load various datasets containing tree data into consistent DataFrames.DataFrames.","category":"page"},{"location":"","page":"Home","title":"Home","text":"It as well provides functionality to calculate shadows from these datasets.","category":"page"},{"location":"#Interface","page":"Home","title":"Interface","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"To properly work within the MinistryOfCoolWalks ecosystem, we expect the dataframes to follow a certain set of requirements:","category":"page"},{"location":"","page":"Home","title":"Home","text":"Each row in the DataFrame represents a single tree\nEach DataFrame must have the following columns:\n:id unique id of the tree\n:lon longitude of tree (WSG84)\n:lat latitude of tree (WSG84)\n:height height of tree from floor to center of crown (m)\n:radius radius of crown (m)\n:geometry ArchGDAL point, representing center of stem (must have spatial reference applied)\nThe DataFrame must have metadata with a key of observatory, which contains a CoolWalksUtils.ShadowObservatory. This value contains the center coordinates used for projection to a local coordinate system and the timezone of the dataset, used to calculate the sunposition, for shadow projection.","category":"page"},{"location":"","page":"Home","title":"Home","text":"The technical part of the last two of these requirements can be checked with TreeLoaders.check_tree_dataframe_integrity(df).","category":"page"},{"location":"#API","page":"Home","title":"API","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Pages = [\"index.md\"]","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [TreeLoaders]\nPages = [\"TreeLoaders.jl\"]","category":"page"},{"location":"#TreeLoaders.check_tree_dataframe_integrity-Tuple{Any}","page":"Home","title":"TreeLoaders.check_tree_dataframe_integrity","text":"check_tree_dataframe_integrity(df)\n\nChecks if df conforms to the technical requirements needed to be considered as a source for tree data.\n\n\n\n\n\n","category":"method"}]
}