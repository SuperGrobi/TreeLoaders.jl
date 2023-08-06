# Loading Spanish Trees
## Barcelona
We load the tree data from the open data server of barcelona. This Dataset comes in three different subfiles:
- [Street Trees](https://opendata-ajuntament.barcelona.cat/data/en/dataset/arbrat-viari/resource/7613c24b-33ab-4671-8f01-c509c653c645)
- [Park Trees](https://opendata-ajuntament.barcelona.cat/data/en/dataset/arbrat-parcs/resource/c569ee47-f734-4659-aebc-3a7b9f453807)
- [Zone Trees](https://opendata-ajuntament.barcelona.cat/data/en/dataset/arbrat-zona/resource/2ab05031-0efa-4f60-836f-a125c6be0061)

Since there are no height and radius data available, we set them constant to `height=6m` and `radius=3.5m`.
These values are the mean values found in the Nottingham dataset.

## Valencia
We load the tree data from the open data server of valencia, available here:
[valencia tree data](https://valencia.opendatasoft.com/explore/dataset/arbratge-arbolado/export/).

Since there are no height and radius data available, we set them constant to `height=6m` and `radius=3.5m`.
These values are the mean values found in the Nottingham dataset.

## API

```@index
Pages = ["Spain.md"]
```

```@autodocs
Modules = [TreeLoaders]
Pages = ["Spain.jl"]
```