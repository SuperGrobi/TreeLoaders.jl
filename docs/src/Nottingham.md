# Shadow Casting
## Introduction
We load the tree data from the open data server of the city concil of nottingham, available here:
[nottingham tree data](https://maps164.nottinghamcity.gov.uk/server/rest/services/OpenData/OpenData/MapServer/91).

As there are a lot of duplicates in this dataset, we need to clean that up, which happens while loading `load_nottingham_trees`. During this process, we also drop a lot of irrelevant columns and create a few new ones.

Due to the architecture of the shadow casting, we provide a user defined function which calculates the
relevant data for calculating each trees shadow (x, y, height, radius) from every row in the loaded dataset. This allows for custom datasets to not be massively manipulated on loading, but rather enables
the users to provide their own handlers working for their data.

## API

```@index
Pages = ["Nottingham.md"]
```

```@autodocs
Modules = [TreeLoaders]
Pages = ["Nottingham.jl"]
```