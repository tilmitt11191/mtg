
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


require 'net/http'
def url_exists?(url, logger, limit = 10)
	@log.info "url_exists?(#{url}, limit = #{limit}) start."
  if limit == 0
   	logger.debug "url_exists? finished. url[#{url}] does not exist."
    return false
  end
  begin
    response = Net::HTTP.get_response(URI.parse(url))
  rescue
   	logger.debug "url_exists? finished. url[#{url}] does not exist."
    return false
  else
    case response
    when Net::HTTPSuccess
    	logger.debug "url_exists? finished. url[#{url}] exists."
      return true
    when Net::HTTPRedirection
      url_request(response['location'], limit - 1)
    else
    	logger.debug "url_exists? finished. url[#{url}] does not exist."
      return false
    end
  end
end
