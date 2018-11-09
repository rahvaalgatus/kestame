require "csv"
require "json"

CATEGORIES = {
	"Sündimus" => "population",
	"Ränne" => "migration",
	"Tööhõive" => "work"
}

Discussion = Struct.new(
	:id,
	:at,
	:duration,
	:state,
	:address,
	:coordinates,
	:title,
	:organizer_name,
	:organizer_email,
	:organizer_phone,
	:people_count
) do
	def past?
		self.at < Time.now
	end

	def future?
		self.at >= Time.now
	end

	def until
		self.at + 3600 * self.duration
	end
end

Problem = Struct.new(:id, :title, :category, :rank, :solutions)

def read_discussions(item)
	discussions = CSV.read(item.raw_filename, headers: :first_row)

	discussions.map.with_index do |discussion, i|
		datetime = discussion["date"] + " " + discussion["time"]

		Discussion.new(
			i,
			Time.strptime(datetime, "%Y-%m-%d %r"),
			discussion["duration"].to_f,
			discussion["state"],
			discussion["address"],
			discussion["coordinates"],
			discussion["title"],
			discussion["organizer_name"],
			discussion["organizer_email"],
			discussion["organizer_phone"],
			discussion["people_count"].to_i
		)
	end
end

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

def serialize_geojson(discussions)
	JSON.dump({
		type: "FeatureCollection",

		features: discussions.map do |discussion|
			{
				"type": "Feature",

				"geometry": {
					type: "Point",
					coordinates: discussion.coordinates.split(";").map(&:to_f)
				},

				"properties": {id: discussion.id}
			}
		end
	})
end
