"""
    flow_diversity(N::T; dims::Integer=1) where {T <: UnipartiteQuantitativeNetwork}

TODO

#### References

Bersier, L.F., Banašek-Richter, C., Cattin, M.-F., 2002. Quantitative
descriptors of food-web matrices. Ecology 83, 2394–2407.
"""
function flow_diversity(N::T; dims::Integer=1) where {T <: UnipartiteQuantitativeNetwork}
    @assert dims ∈ [1,2]
    @warn "UNTESTED"
    b = N.A / sum(N; dims=dims)
    bsum = sum(b; dims=dims)
    return -sum(bsum .* log.(2.0, bsum))
end

"""
    equivalent_degree(N::T; dims::Integer=1) where {T <: UnipartiteQuantitativeNetwork}

TODO

#### References

Bersier, L.F., Banašek-Richter, C., Cattin, M.-F., 2002. Quantitative
descriptors of food-web matrices. Ecology 83, 2394–2407.
"""
function equivalent_degree(N::T; dims::Integer=1) where {T <: UnipartiteQuantitativeNetwork}
    @assert dims ∈ [1,2]
    @warn "UNTESTED"
    d = degree(N; dims=dims)
    f = flow_diversity(N; dims=dims)
    nxk = Dict([s => d[s] == 0 ? 0.0 : 2.0^f[s] for s in species(N)])
    return nxk
end

"""
    positional_index(N::T; weighted=false) where {T <: UnipartiteQuantitativeNetwork}

#### References

Bersier, L.F., Banašek-Richter, C., Cattin, M.-F., 2002. Quantitative
descriptors of food-web matrices. Ecology 83, 2394–2407.
"""
function positional_index(N::T; weighted=false) where {T <: UnipartiteQuantitativeNetwork}
    nnk = equivalent_degree(N; dims=2)
    npk = equivalent_degree(N; dims=1)
    if !weighted
        return Dict([s => nnk[s]/(nnk[s]+npk[s]) for s in species(N)])
    else
        s1 = sum(N; dims=1)
        s2 = sum(N; dims=2)
        return Dict([s => (s2[i]*nnk[s])/(s2[i]*nnk[s]+s1[i]*npk[s]) for (i,s) in enumerate(species(N))])
    end
end