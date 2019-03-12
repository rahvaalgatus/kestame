require "csv"
require "json"

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

	def has_organizer?
		!self.organizer_name.nil?
	end
end

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
