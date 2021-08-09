module FTensorKit
    using GeometryBasics,LinearAlgebra
    
    include("FTN.jl")
    include("utils/Lattices.jl")
    include("utils/PerspectiveMap.jl")
    include("utils/SwapGates.jl")
    include("eincode.jl")

end