# Loading New York Trees
## Introduction
We load the tree data from the open data server of the city of new york, available here:
[new york tree data](https://data.cityofnewyork.us/Environment/2015-Street-Tree-Census-Tree-Data/uvpi-gqnh).

Since there are no height and radius data available, we set them constant to `height=6m` and `radius=3.5m`.
These values are the mean values found in the Nottingham dataset.

## API

```@index
Pages = ["NewYork.md"]
```

```@autodocs
Modules = [TreeLoaders]
Pages = ["NewYork.jl"]
```