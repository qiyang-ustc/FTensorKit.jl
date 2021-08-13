using DataStructures
export iter_gates, iter_origin, FTN
abstract type AbstractTensorNetwork end

struct FTN
    graph::AbstractGraph
    locations::Array
    n_origin::Int
    n_gates::Int
end

iter_origin(ftn::FTN) = 1:ftn.n_origin
iter_gates(ftn::FTN) = ftn.n_origin+1:ftn.n_origin+ftn.n_gates

function FTN(lattice2D::Lattice; eps = 1E-10)
    edge = MutableLinkedList{Edge}([i for i in edges(lattice2D.graph)]...)
    locations = lattice2D.locations

    i = 1
    while i < length(edge)
        for j = i+1:length(edge)
            line1, line2 = edgeline(locations, edge[i]), edgeline(locations, edge[j])
            isinter, point = intersects(line1, line2)
            if isinter
                tp = (line1[1], line1[2], line2[1], line2[2])
                if norm(tp[1] - point) > eps &&
                   norm(tp[2] - point) > eps &&
                   norm(tp[3] - point) > eps &&
                   norm(tp[4] - point) > eps
                    locations = [locations; point']
                    k = size(locations)[1]
                    push!(edge, Edge(src(edge[j]), k))
                    push!(edge, Edge(dst(edge[j]), k))
                    edge[j] = Edge(k, dst(edge[i]))
                    edge[i] = Edge(k, src(edge[i]))
                end
            end
        end
        i = i + 1
    end

    g = SimpleGraph(size(locations)[1])
    for i in edge
        add_edge!(g, src(i), dst(i))
    end

    return FTN(g, locations, nv(lattice2D.graph), size(locations)[1] - nv(lattice2D.graph))
end
