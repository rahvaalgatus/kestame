require "csv"

CATEGORIES = {
	"Sündimus" => "population",
	"Ränne" => "migration",
	"Tööhõive" => "work"
}

Problem = Struct.new(:id, :title, :category, :rank, :solutions)

def read_problems(item)
	problems = CSV.read(item.raw_filename, headers: :first_row)

	problems = problems.map.with_index do |problem, i|
		id = i
		title = problem["title"]
		category = CATEGORIES[problem["category"]]
		rank = problem["rank"].to_i
		solutions = (problem["solutions"] || "").split("\n")
		solutions = solutions.reject {|s| s =~ /^\s*$/ }
		Problem.new(id, title, category, rank, solutions)
	end

	problems.group_by(&:category)
end

