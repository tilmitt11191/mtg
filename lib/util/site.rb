

require	"logger"
require 'open-uri'
require 'nokogiri'
require '../../lib/util/utils.rb'

class Site
	@log
	@site_name
	@card_name
	@url
	@charset
	@card_row_data
	@card_nokogiri
	@deck_row_data
	@deck_nokogiri
	

	attr_accessor :site_name
	
	def initialize(site_name, logger)
		@log = logger
		@log.info "Site.initialize(" + site_name + ")"
		@site_name = site_name
		@charset="UTF-8"
	end
	
end

