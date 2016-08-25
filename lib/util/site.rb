

require	"logger"
require 'open-uri'
require 'nokogiri'
require '../../lib/util/utils.rb'
require '../../lib/util/web.rb'

class Site
	@log
	@web
	@html
	@name
	@search_option
	@url
	@charset
	@card_row_data
	@card_nokogiri
	@deck_row_data
	@deck_nokogiri
	

	attr_accessor :name, :web, :html, :url, :search_option
	
	def initialize(site_name, logger)
		@log = logger
		@log.info "Site.initialize(" + site_name + ")"
		@web = Web.new
		@name = site_name
		@charset="UTF-8"
	end
	
end

