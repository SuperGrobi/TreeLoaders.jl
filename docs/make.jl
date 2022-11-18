using TreeLoaders
using Documenter

DocMeta.setdocmeta!(TreeLoaders, :DocTestSetup, :(using TreeLoaders); recursive=true)

makedocs(;
    modules=[TreeLoaders],
    authors="Henrik Wolf <henrik-wolf@freenet.de> and contributors",
    repo="https://github.com/SuperGrobi/TreeLoaders.jl/blob/{commit}{path}#{line}",
    sitename="TreeLoaders.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://SuperGrobi.github.io/TreeLoaders.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Shadow Casting" => "ShadowCasting.md",
        "Nottingham" => "Nottingham.md"
    ],
)

deploydocs(;
    repo="github.com/SuperGrobi/TreeLoaders.jl",
    devbranch="main",
)
