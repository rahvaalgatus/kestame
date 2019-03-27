require "csv"

Solution = Struct.new(:id, :category, :solver, :text, :problem, :links)

def read_solutions(item)
	solutions = CSV.read(item.raw_filename, headers: :first_row)

	parse_link = lambda do |pair| pair.split(/:/, 2).map(&:strip) end

	solutions = solutions.map.with_index do |solution, i|
		id = i * 3
		solutions = []
		category = solution["category"]

		if solution["government"]
			solutions << Solution.new(
				id + 0,
				category,
				"government",
				solution["government"],
				solution["government_problem"],
				(solution["government_links"] || "").split("\n").map(&parse_link)
			)
		end

		if solution["municipal"]
			text = solution["municipal"]
			problem = nil
			solutions << Solution.new(id + 1, category, "municipal", text, problem)
		end

		if solution["community"]
			text = solution["community"]
			problem = nil
			solutions << Solution.new(id + 2, category, "community", text, problem)
		end

		solutions
	end.flatten

	solutions.group_by(&:category).transform_values {|s| s.group_by(&:solver) }
end
