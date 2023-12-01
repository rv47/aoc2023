function readinputfile(path::String)
	s = open(path, "r") do file
		read(file, String)
	end
	return s
end

function extractdigits(calibration_lines; numbers_only = true)
	if numbers_only
		digits = join([m.captures[1] for m in eachmatch(r"(\d)", calibration_lines)])
	else
		rxpattern = r"(\d|one|two|three|four|five|six|seven|eight|nine)"
		digits = join([m.captures[1] for m in eachmatch(rxpattern, calibration_lines, overlap = true)])
		digits = replace(
			digits,
			"one" => "1",
			"two" => "2",
			"three" => "3",
			"four" => "4",
			"five" => "5",
			"six" => "6",
			"seven" => "7",
			"eight" => "8",
			"nine" => "9",
		)
	end

	return parse(Int64, digits[1] * digits[end])
end

function main()
	calibration_values = split(readinputfile(joinpath(@__DIR__, "input.txt")))
	println("Digit Only : ", sum(extractdigits.(calibration_values)))
	println("Digit Words: ", sum(extractdigits.(calibration_values, numbers_only = false)))
end

main()