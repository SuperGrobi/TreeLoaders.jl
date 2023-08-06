# Loading Nottingham Trees
## Introduction
We load the tree data from the open data server of the city concil of nottingham, available here:
[nottingham tree data](https://maps164.nottinghamcity.gov.uk/server/rest/services/OpenData/OpenData/MapServer/91).

As there are a lot of duplicates in this dataset, we do some preliminary cleanup in `load_nottingham_trees`. During this process, we also drop a lot of irrelevant columns and create a few new ones.
All trees which are (transitively) within a square of 2e-5 meter edge length around a tree are considered the same tree. We average over all numerical data and keep the first entry for every other one.

## API

```@index
Pages = ["Nottingham.md"]
```

```@autodocs
Modules = [TreeLoaders]
Pages = ["Nottingham.jl"]
```