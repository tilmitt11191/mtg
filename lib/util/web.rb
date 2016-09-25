# encoding: UTF-8
#ruby

require 'logger'
require 'net/http'
require 'open-uri'
require 'nokogiri'


class Web
	@html_row_data
	@cache #Hash key:url value:html_row_data
	@dom

	def initialize
		@cache = {}
	end
	
	def self.url_exists?(url, log, limit = 3)
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
		log.info "web.#{__method__}(#{url}) start."
		if !@cache[url].nil? then
			log.info "url[#{url}] cached. return cached dom. the title of url[#{url}] is [#{@dom.title}]."
			@dom = @cache[url]
			return @dom
		end
		
		if !Web::url_exists?(url, log) then
			log.info "url[#{url}] not exist. return false."
			return nil
		end		

		# Request the HTML before parsing
		@html_row_data = open(url).read
		# Replace original DOCTYPE with a valid DOCTYPE
		@html_row_data = @html_row_data.sub(/^<!DOCTYPE html(.*)$/, '<!DOCTYPE html>')
		# Parse
		@dom = Nokogiri::HTML(@html_row_data)
		
		@cache[url] = @dom
		log.info "return dom. the title of url[#{url}] is [#{@dom.title}]."
		return @dom
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




