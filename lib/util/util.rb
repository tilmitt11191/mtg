
#ruby

def convert_period(str)
	return str.gsub(",", "PERIOD")
end

def reconvert_period(str)
	return str.gsub("PERIOD",",").to_s
end