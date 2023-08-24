```@meta
CurrentModule = TreeLoaders
```

# TreeLoaders

Documentation for [TreeLoaders](https://github.com/SuperGrobi/TreeLoaders.jl).

This package provides functions to load various datasets containing tree data into consistent `DataFrames.DataFrame`s.

It as well provides functionality to calculate shadows from these datasets.

# Interface

To properly work within the `MinistryOfCoolWalks` ecosystem, we expect the dataframes to follow a certain set of requirements:

1. Each row in the `DataFrame` represents a single tree

1. Each `DataFrame` must have the following columns:
   - `:id` unique id of the tree
    - `:lon` longitude of tree (WSG84)
    - `:lat` latitude of tree (WSG84)
    - `:height` height of tree from floor to center of crown (m)
    - `:radius` radius of crown (m)
    - `:geometry` `ArchGDAL` point, representing center of stem (must have spatial reference applied)
1. The `DataFrame` must have `metadata` with a key of `observatory`, which contains a `CoolWalksUtils.ShadowObservatory`. This value contains the center coordinates used for projection to a local coordinate system and the timezone of the dataset, used to calculate the sunposition, for shadow projection.

The technical part of the last two of these requirements can be checked with [`TreeLoaders.check_tree_dataframe_integrity(df)`](@ref).

# API

```@index
Pages = ["index.md"]
```

```@autodocs
Modules = [TreeLoaders]
Pages = ["TreeLoaders.jl"]
```