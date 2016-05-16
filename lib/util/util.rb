
#ruby
require 'diff/lcs'

def convert_period(str)
	return str.gsub(",", "PERIOD")
end

def reconvert_period(str)
	return str.gsub("PERIOD",",").to_s
end

def diff(file1, file2) #TODO
	a = File.open(file1, 'r:sjis').readlines
	b = File.open(file2, 'r:sjis').readlines
	diffs = Diff::LCS.diff(a,b)
	p diffs
end