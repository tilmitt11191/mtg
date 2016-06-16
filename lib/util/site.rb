

require	"logger"
require 'open-uri'
require 'nokogiri'
require '../../lib/util/utils.rb'

class Site
	@log
	@store_name
	@card_name
	@url
	@charset="UTF-8"
	@card_row_data
	@card_nokogiri
	@deck_row_data
	@deck_nokogiri
	

	attr_accessor :store_name
	
	def initialize(store_name, logger)
		@log = logger
		@log.info "Store.initialize(" + store_name + ")"
		@store_name = store_name
	end
	
end

