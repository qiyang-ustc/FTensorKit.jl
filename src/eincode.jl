# Generate EinCode From a lattice.
using OMEinsum, LightGraphs
export eincode
function eincode(graph::Graph)
    tensor_dim = [length(neighbors(graph, i)) for i in LightGraphs.vertices(graph)]
    code = [zeros(Int, tensor_dim[i]) for i = 1:length(tensor_dim)]
    t = ones(Int, length(tensor_dim))
    edges = [i for i in LightGraphs.edges(graph)]

    for i = 1:ne(graph)
        s, d = src(edges[i]), dst(edges[i])
        code[s][t[s]] = i
        code[d][t[d]] = i
        t[src(edges[i])] += 1
        t[dst(edges[i])] += 1
    end
    return EinCode(([Tuple(i) for i in code]...,), ())
end
