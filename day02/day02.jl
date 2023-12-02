function readinputfile(path::String)
	s = open(path, "r") do file
		read(file, String)
	end
	return split(s, "\n")
end

function processcubegames(gameresults; sumids = true)
	rxid = r"(\d+)"
	rxcube = r"(\d+) (\w+)"

	colordicts = []

	for game in gameresults
		colordict = Dict()
		colordict["idx"] = parse(Int64, match(rxid, split(game, ": ")[1])[1])

		gamesample = split(game, ": ")[2]
		for res in eachsplit(gamesample, "; ")
			for m in eachmatch(rxcube, res)
				n = parse(Int, m.captures[1])
				color = m.captures[2]
				colordict[color] = max(get(colordict, color, 0), n)
			end
		end

		push!(colordicts, colordict)
	end

	stat = 0

	for colordict in colordicts
		if sumids
			if get(colordict, "red", 0) <= 12 && get(colordict, "green", 0) <= 13 && get(colordict, "blue", 0) <= 14
				stat += colordict["idx"]
			end
		else
			stat += get(colordict, "red", 0) * get(colordict, "green", 0) * get(colordict, "blue", 0)
		end
	end

	return stat
end

function main()
	gameoutcomes = readinputfile(joinpath(@__DIR__, "input.txt"))
	println("Sum of IDs: ", processcubegames(gameoutcomes))
	println("Sum of Powers: ", processcubegames(gameoutcomes, sumids = false))
end

main()