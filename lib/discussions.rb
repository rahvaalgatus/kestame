require "csv"
require "json"

def read_discussions(item)
	csv = CSV.read(item.raw_filename, headers: :first_row)

	csv.each_with_index do |discussion, i|
		discussion["id"] = i
		datetime = discussion["date"] + " " + discussion["time"]
		discussion["at"] = Time.strptime(datetime, "%Y-%m-%d %r")
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
					coordinates: discussion["coordinates"].split(";").map(&:to_f)
				},

				"properties": {id: discussion["id"]}
			}
		end
	})
end
