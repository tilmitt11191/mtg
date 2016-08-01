
#ruby
require "logger"
require 'diff/lcs'

def convert_period(str)
	return nil if str.nil?
	str.gsub(",", "PERIOD")
end

def reconvert_period(str)
	if str.nil? then return nil end
	return str.gsub("PERIOD",",").to_s
end

def escape_by_double_quote str, logger
	@log.debug "#{__method__} #{str} start."
	return "\"\"" if str.nil? 
	return str if str.match(/^".*"$/)
	"\""+str.gsub("\"", "\\\"\"")+"\""
end

def unescape_double_quote str
	str.gsub(/^\"|\"$/,'')
end

def diff(file1, file2) #TODO
	a = File.open(file1, 'r:Shift_JIS').readlines
	b = File.open(file2, 'r:Shift_JIS').readlines
	diffs = Diff::LCS.diff(a,b)
	p diffs
end

def puts_write(error, logger)
	logger.warn "this method(#{__method__}) will be moved to write_error_to_log"
	write_error_to_log(error, logger)
end

def write_error_to_log(error, logger)
	puts error.backtrace
	puts error.message
	logger.fatal( "#{error.backtrace}" )
	logger.fatal( "#{error.message}" )
end

def puts_create_write(error)
	logger.warn "this method(#{__method__}) will be removed"
	puts error.backtrace
	puts error.message
	logger = Logger.new("../../log", 5, 10 * 1024 * 1024)
	logger.fatal( "#{error.backtrace}" )
	logger.fatal( "#{error.message}" )
end


require '../../lib/util/web.rb'
def url_exists?(url, logger, limit = 10)
	logger.warn "this method(#{__method__}) will be moved to web.rb"
	web = Web.new
	web.url_exists?(url, logger, limit = 10)
end

def convert_number_to_triple_digits(num)
	sprintf("%03d",num)
end

