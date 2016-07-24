# encoding: UTF-8
#ruby

require 'logger'
require 'net/http'
require 'open-uri'
require 'nokogiri'


class Web
	@html_row_data
	@dom
	
	def url_exists?(url, logger, limit = 3)
		logger.info "#{__method__}(#{url}, limit = #{limit}) start."
		if limit == 0
			logger.info "#{__method__} finished. url[#{url}] does not exist."
			return false
		end
		begin
			response = Net::HTTP.get_response(URI.parse(url))
		rescue
			logger.info "#{__method__} finished. url[#{url}] does not exist."
			return false
		else
			case response
			when Net::HTTPSuccess
				logger.info "#{__method__} finished. url[#{url}] exists."
				return true
			when Net::HTTPRedirection
				url_exists?(response['location'], logger, limit - 1)
			else
				logger.info "#{__method__} finished. url[#{url}] does not exist."
				return false
			end
		end
	end
	
	
	def get_dom_of(url, logger)
		logger.info "#{__method__}(#{url}) start."
		if url_exists?(url, logger) then
			@html_row_data =URI.parse(url).read
			charset = @html_row_data.charset
			if charset == "iso-8859-1"
				charset = page.scan(/charset="?([^\s"]*)/i).first.join
			end
			@dom = Nokogiri::HTML.parse(@html_row_data, nil, charset)
			logger.info "return dom. the title of url[#{url}] is [#{@dom.title}]."
			return @dom
		else
			logger.info "url[#{url}] not exist. return nil."
			return nil
		end
	end
	
	def print_html_src(logger)
		logger.info "#{__method__} start."
		puts @html_row_data.to_s.encoding
		puts @html_row_data.to_s
		logger.info "#{__method__} finished."
	end
	
	
end




