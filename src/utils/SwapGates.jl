export intersects2D
function intersects2D(lattice2D::Lattice;eps=1E-10)
    lines = [edgeline(lattice2D.locations,i) for i in edges(lattice2D.graph)]
	nedges = ne(lattice2D.graph)
	buffer = []
	for i = 1:nedges-1
		for j = i+1:nedges
			isinter,point = intersects(lines[i],lines[j])
			if isinter
				tp = (lines[i][1],lines[i][2],lines[j][1],lines[j][2])
				if norm(tp[1]-point)>eps && norm(tp[2]-point)>eps && norm(tp[3]-point)>eps && norm(tp[4]-point)>eps
					push!(buffer,point)
				end
			end
		end
	end
	return buffer
end