export PerspectiveMap3D

function PerspectiveMap3D(kx::Real,ky::Real;rx=0.00001,ry=0.0001)
	pmap(p) = (p[1]+kx*p[3]+rx*p[2],p[2]+ky*p[3]+ry*p[1])
	return pmap
end

# rx ry make every lines not horizontal or vertical
function PerspectiveMap3D(array::Array,kx::Real,ky::Real;rx=0.00001,ry=0.0001) 
    tmap = PerspectiveMap3D(kx,ky;rx=rx,ry=ry)
    N = size(array)[1]
    new_locations = zeros(Float64,N,2)
    for i =1:N
        new_locations[i,:] .= tmap(array[i,:])
    end
    return stretch2D!(new_locations)
end

PerspectiveMap3D(lattice::Lattice,kx::Real,ky::Real) = typeof(lattice)(lattice.graph,PerspectiveMap3D(lattice.locations,kx,ky))

function stretch2D!(array::Array;xytol=0.1)
    xmax = maximum(array[:,1])+xytol
    xmin = minimum(array[:,1])-xytol
    ymax = maximum(array[:,2])+xytol
    ymin = minimum(array[:,2])-xytol
    xspan,yspan = xmax-xmin,ymax-ymin
    array[:,1] .= (array[:,1].-xmin)/xspan
    array[:,2] .= (array[:,2].-ymin)/yspan
    return array
end