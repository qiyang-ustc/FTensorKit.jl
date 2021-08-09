# Just a simple lattice for examples and test.
# We note that there is package Lattices.jl but quite out-dated and poor-maintained. (does not support cubic lattices.)
export OBC,Cubic,graph,locations,Lattice,edgeline

using Reexport
@reexport using LightGraphs,GeometryBasics
abstract type Lattice end
abstract type AbstractBC end
abstract type OBC <: AbstractBC end


"""
    A Lattice has two components.
    G: a Graph including vertices and edges.
    L: Locations as Point for each vertices.
"""
struct Cubic{bc<:AbstractBC} <: Lattice
    graph :: AbstractGraph
    locations :: Array
end

graph(l::Lattice) = l.graph
locations(l::Lattice) = l.locations
	
function Cubic{OBC}(Lx::Int,Ly::Int,Lz::Int)
    dim = [Lx;Ly;Lz]
    N = prod(dim)
    D = 3
    g = SimpleGraph(N)
    locations = zeros(Float64,N,3)
    f(i,j,k) = i +(j-1)*Lx+ (k-1)*Lx*Ly

    function tadd!(g,pos,dir)
        if pos[dir] != dim[dir]
            tpos = [i==dir ? 1 : 0 for i=1:D]
            add_edge!(g,f(pos...),f((pos+tpos)...))
        end
    end

    for i=1:Lx for j=1:Ly for k = 1:Lz
        for dir = 1:D
            tadd!(g,[i;j;k],dir)
        end
        locations[f(i,j,k),:] = [i;j;k]
    end end end
    return Cubic{OBC}(g,locations)
end

"""
    Function edgeline
    create a Line from an edge
"""
edgeline(l2D::Array,edge) = Line(Point(l2D[src(edge),:]...),Point(l2D[dst(edge),:]...))

# """
#     obtain raw data
# """
# function raw(lattice::Lattice)


# end