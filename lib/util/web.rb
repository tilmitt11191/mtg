# encoding: UTF-8
#ruby

require 'logger'
require 'net/http'

class Web
	
	def url_exists?(url, logger, limit = 10)
		logger.info "url_exists?(#{url}, limit = #{limit}) start."
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
			url_exists?(response['location'], logger, limit - 1)
		else
			logger.debug "url_exists? finished. url[#{url}] does not exist."
			return false
		end
	end
	end
end




