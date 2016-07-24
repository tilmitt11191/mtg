
#ruby
require "logger"
require 'diff/lcs'

def convert_period(str)
	if str.nil? then return nil end
	return str.gsub(",", "PERIOD")
end

def reconvert_period(str)
	if str.nil? then return nil end
	return str.gsub("PERIOD",",").to_s
end

def diff(file1, file2) #TODO
	a = File.open(file1, 'r:sjis').readlines
	b = File.open(file2, 'r:sjis').readlines
	diffs = Diff::LCS.diff(a,b)
	p diffs
end

def puts_write(error, logger)
	puts error.backtrace
	puts error.message
	logger.fatal( "#{error.backtrace}" )
	logger.fatal( "#{error.message}" )
end

def puts_create_write(error)
	puts error.backtrace
	puts error.message
	logger = Logger.new("../../log", 5, 10 * 1024 * 1024)
	logger.fatal( "#{error.backtrace}" )
	logger.fatal( "#{error.message}" )
end


require '../../lib/util/web.rb'
def url_exists?(url, logger, limit = 10)
	logger.warn 'this method(utils.url_exists?) will be moved to web.rb'
	web = Web.new
	web.url_exists?(url, logger, limit = 10)
end

def convert_number_to_triple_digits(num)
	puts sprintf("%03d",num)
end

