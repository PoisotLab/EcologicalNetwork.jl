---
title : Understanding the type system
author : Timothée Poisot
date : 11th April 2018
layout: default
---




`EcologicalNetwork` uses a series of types to represent networks. Before we
dig in, it is important to get a sense of what the types can do for you. The
type of a network is used to define the types of things you can do to it. For
example, the correct way to measure nestedness changes depending on if the
network is quantitative or binary. Picking the correct network is important,
and this page will walk you through the different types available.



## Network types

There are three types of networks: binary (where interactions are either
present or absent), quantitative (interactions have a strength), and
probabilistic (interactions have a probability of happening). All of these
networks share the same underlying structure: a matrix that can store
elements of different types, and species names. This matrix is stored in the
field `A` of the network object.



Species names are stored differently depending on whether the network is
bipartite or unipartite. In unipartite networks (*e.g.* food webs), there is
a single field `S` for species. In bipartite networks, there are two fields
`T` and `B`, for the top and bottom level of the network. The names of
species are either `AbstractString` or `Symbol` values (and they cannot be
mixed with a single network).



The interactions go from the rows, to the columns, of the matrix in `A`. In
practice, there is no need to call the fields directly: we can access the
species names using the `species` functions.



Types are named using the `{Partiteness}{Type}Network`, where `{Partiteness}`
is either `Unipartite` or `Bipartite`, and  `{Type}` is either
`Probabilistic` or `Quantitative` -- the `Binary` type, being considered the
default, is omitted. The six basic types available are therefore
`BipartiteNetwork`, `UnipartiteNetwork`, `BipartiteQuantitativeNetwork`,
`UnipartiteQuantitativeNetwork`, `BipartiteProbabilisticNetwork`, and
`UnipartiteProbabilisticNetwork`.



## Network conversions



Network objects can be converted into objects of another type. For example,
the information about interaction strength can be removed by converting a
`BipartiteQuantitativeNetwork` into a `BipartiteNetwork`. Let us start by
loading a network:

````julia
N = fonseca_ganade_1996();
typeof(N)
````


````
EcologicalNetwork.BipartiteQuantitativeNetwork{Int64,String}
````






````
EcologicalNetwork.BipartiteQuantitativeNetwork{Int64,String}
````




The conversion itself is performed with:

````julia
M = convert(BipartiteNetwork, N);
typeof(M)
````


````
EcologicalNetwork.BipartiteNetwork{String}
````






````
EcologicalNetwork.BipartiteNetwork{String}
````




The conversion system also uses abstract types to make your life easier: we
can convert to an abstract type, which makes the code more general. To change
the partiteness of a network, we can use the `AbstractUnipartiteNetwork`
conversion.


````julia
julia> typeof(convert(AbstractUnipartiteNetwork, N))
````


<pre class="julia-error">
ERROR: UndefVarError: julia not defined
</pre>


````julia
EcologicalNetwork.UnipartiteQuantitativeNetwork{Int64,String}

julia> typeof(convert(BinaryNetwork, N))
````


<pre class="julia-error">
ERROR: UndefVarError: julia not defined
</pre>


````julia
EcologicalNetwork.BipartiteNetwork{String}
````


````
EcologicalNetwork.BipartiteNetwork{String}
````








These transformations can be chained together: to project the network into a
unipartite shape *and* remove quantitative information, we can use the
following:

````julia
julia> M = N |>
    x -> convert(AbstractUnipartiteNetwork, x) |>
    x -> convert(BinaryNetwork, x);
````


<pre class="julia-error">
ERROR: error in method definition: function Base.&gt; must be explicitly imported to be extended
</pre>


````julia

julia> typeof(M)
````


<pre class="julia-error">
ERROR: UndefVarError: julia not defined
</pre>


````julia
EcologicalNetwork.UnipartiteNetwork{String}
````


````
EcologicalNetwork.UnipartiteNetwork{String}
````

