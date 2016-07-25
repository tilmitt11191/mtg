# encoding: UTF-8
#ruby

require 'logger'
require 'net/http'
require 'open-uri'
require 'nokogiri'


class Web
	@html_row_data
	@dom
	
	def url_exists?(url, log, limit = 3)
		log.info "#{__method__}(#{url}, limit = #{limit}) start."
		if limit == 0
			log.info "#{__method__} finished. url[#{url}] does not exist."
			return false
		end
		begin
			response = Net::HTTP.get_response(URI.parse(url))
		rescue
			log.info "#{__method__} finished. url[#{url}] does not exist."
			return false
		else
			case response
			when Net::HTTPSuccess
				log.info "#{__method__} finished. url[#{url}] exists."
				return true
			when Net::HTTPRedirection
				url_exists?(response['location'], log, limit - 1)
			else
				log.info "#{__method__} finished. url[#{url}] does not exist."
				return false
			end
		end
	end
	
	
	def get_dom_of(url, log)
		log.info "#{__method__}(#{url}) start."
		if url_exists?(url, log) then
			@html_row_data =URI.parse(url).read
			charset = @html_row_data.charset
			if charset == "iso-8859-1"
				charset = page.scan(/charset="?([^\s"]*)/i).first.join
			end
			@dom = Nokogiri::HTML.parse(@html_row_data, nil, charset)
			log.info "return dom. the title of url[#{url}] is [#{@dom.title}]."
			return @dom
		else
			log.info "url[#{url}] not exist. return false."
			return false
		end
	end
	
	def print_html_src(log)
		log.info "#{__method__} start."
		puts @html_row_data.to_s.encoding
		puts @html_row_data.to_s
		log.info "#{__method__} finished."
	end
	
	def output_html_src_to(filename, log)
		log.info "#{__method__} start."
		if @html_row_data.nil? then
			log.warn "@html_row_data is nil. return false."
			return false
		end
		file = File.open(filename, "w:utf-8", :invalid => :replace, :undef => :replace, :replace => '?')
		file.puts @html_row_data
		file.close
		#@html_row_data.each do |line|
		#	puts line
		#end
		log.info "#{__method__} finished."
	end
	
end




