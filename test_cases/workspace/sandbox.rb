	#### create weka attributes
	filename = "../../data_for_analysis/hareruya1_archetypes.arff"

	str = ""
	for i in 1..75 do
		str = str.to_s + "@attribute card" + i.to_s + " string\n"
	end
		File.open(filename, "w:sjis") do |file|
		file.puts "@archetype_prediction
@archetype
#{str}
@data
"
		file.close
	end