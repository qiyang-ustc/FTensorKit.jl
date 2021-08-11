### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ b58fd1ff-e776-4721-8ea4-dd0d52f7de2e
using Pkg

# ╔═╡ 36d2a4e8-f81f-11eb-3c33-bb29b29df2fb
Pkg.activate("../")# The FTensorKit.jl enviroment

# ╔═╡ ebea242e-b9c0-49b7-a3cb-452b8d515831
using FTensorKit,Viznet,Compose,LinearAlgebra,OMEinsum,LightGraphs,DataStructures

# ╔═╡ 5f9fd5d2-a0f9-4b68-9412-73a0d1e548d1
# Project preliminary
# see: https://arxiv.org/abs/2006.08289

# ╔═╡ 08bcba33-afed-43b8-a5c6-eeeb0fd0cfd5
lattice = Cubic{OBC}(2,3,4); # create a lattice (contains graph and coordinates)

# ╔═╡ 288502fa-a0b3-432a-94e3-ffa35845490a
lattice2D = PerspectiveMap3D(lattice,0.17,0.19); # map this lattice to 2D

# ╔═╡ febaf067-af8c-4628-bf31-8df9fb227b2c
begin 
	# set brush
	linebrush = bondstyle(:default, stroke("grey"))
	nodebrush = nodestyle(:default, stroke("lightblue"),fill("lightblue"),r=0.011)
	gatesbrush = nodestyle(:square, stroke("lightgreen"),fill("lightgreen");r=0.005) # gate brush
	textbrush = textstyle(:default)
end;

# ╔═╡ b696ca61-56cc-4bfd-9672-849a60b091a9
canvas() do
	# plot 2D version for the original lattice
	l2D = lattice2D.locations
	g = lattice2D.graph
    for i =1:size(l2D)[1]
        nodebrush >> Tuple(l2D[i,:])
    end
    for edge in edges(g)
        linebrush >> (Tuple(l2D[src(edge),:]),Tuple(l2D[dst(edge),:]))
    end
end |> x-> compose(context(0.0, 0.0, 1.0, 1.0), x) |> SVG("origin.svg")

# ╔═╡ 4588198b-afdd-47a3-9027-ff83f0a898fe
# Contraction EinCode from this graph
# TODO: As there is no information about input tensor, this eincode does not process legs order in each tensor.
eincode(lattice2D.graph)

# ╔═╡ e1e37180-d93c-4fa8-9998-71749d52d52f
# Now we are going to insert Swap Gates for Fermions into this Network

# ╔═╡ 0517aed7-3de5-4199-99a6-2a3febc49094
gates_locations = intersects2D(lattice2D);
# contains gates locations for plot
# A good way to check if the gates are generated correctly.

# ╔═╡ df3c1ea2-a013-4cd8-9736-15fb29c051e4
canvas() do
	# plot 2D version for the original lattice
	l2D = lattice2D.locations
	g = lattice2D.graph
    for i =1:size(l2D)[1]
        nodebrush >> Tuple(l2D[i,:])
    end
    for edge in edges(g)
        linebrush >> (Tuple(l2D[src(edge),:]),Tuple(l2D[dst(edge),:]))
    end
	for i in gates_locations
		gatesbrush >> Tuple(i)
	end
end |> x-> compose(context(0.0, 0.0, 1.0, 1.0), x) |> SVG("gates.svg")

# ╔═╡ a453055a-26a3-4a4a-827b-0426387ae7ec
# Transform a normal 2D tensor network into Fermionic Form by adding Fermionic SwapGates.
ftn = FTN(lattice2D);

# ╔═╡ 29edc4e4-bcdf-4bb0-9cb2-207b4d234b18
canvas() do
	# plot 2D version for the Fermionic Tensor Network
	l2D = ftn.locations
	g = ftn.graph
    for i =iter_origin(ftn)
        nodebrush >> Tuple(l2D[i,:])
		textbrush >> (Tuple(l2D[i,:]),"v$i")
    end
	
	edges = [edge for edge in edges(g)]
    for i = 1:ne(g)
		edge = edges[i]
        linebrush >> (Tuple(l2D[src(edge),:]),Tuple(l2D[dst(edge),:]))
		textbrush >> (Tuple((l2D[src(edge),:]+l2D[dst(edge),:])./2),"b$i")
    end
	for i in iter_gates(ftn)
		gatesbrush >> Tuple(l2D[i,:])
		textbrush >> (Tuple(l2D[i,:]),"$i")
	end
end  |> x-> compose(context(0.0, 0.0, 1.0, 1.0), x) |> SVG("labels.svg")

# ╔═╡ d077e71f-e121-45b4-aa12-d0db624816a3
# Contraction EinCode from this new graph
# TODO: As there is no information about input tensor, this eincode does not process legs order in each tensor.
typeof(eincode(ftn.graph))

# ╔═╡ f5a9c980-d67a-44ab-ba26-928e581550db
exit()

# ╔═╡ Cell order:
# ╠═5f9fd5d2-a0f9-4b68-9412-73a0d1e548d1
# ╠═b58fd1ff-e776-4721-8ea4-dd0d52f7de2e
# ╠═36d2a4e8-f81f-11eb-3c33-bb29b29df2fb
# ╠═ebea242e-b9c0-49b7-a3cb-452b8d515831
# ╠═08bcba33-afed-43b8-a5c6-eeeb0fd0cfd5
# ╠═288502fa-a0b3-432a-94e3-ffa35845490a
# ╠═febaf067-af8c-4628-bf31-8df9fb227b2c
# ╠═b696ca61-56cc-4bfd-9672-849a60b091a9
# ╠═4588198b-afdd-47a3-9027-ff83f0a898fe
# ╠═e1e37180-d93c-4fa8-9998-71749d52d52f
# ╠═0517aed7-3de5-4199-99a6-2a3febc49094
# ╠═df3c1ea2-a013-4cd8-9736-15fb29c051e4
# ╠═a453055a-26a3-4a4a-827b-0426387ae7ec
# ╠═29edc4e4-bcdf-4bb0-9cb2-207b4d234b18
# ╠═d077e71f-e121-45b4-aa12-d0db624816a3
# ╠═f5a9c980-d67a-44ab-ba26-928e581550db
