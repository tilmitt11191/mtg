

require	"logger"
require "../../lib/util/price.rb"

class Card
	@log
	@card_type #land,creature,spell,sidboardCard
	@name
	@quantity
	@price
	@value
	@store_url
	
	attr_accessor :name, :card_type, :quantity, :price, :value, :store_url

	def initialize(name)
		@log = Logger.new("../log")
		@log.info "Card.initialize"
		@name = name
		@price = Price.new(self)
		@value = "nil"
	end
	
	def set_store_page(url)
		@log.debug "Card["+@name+"].set_store_page[" + url +"]"
		@store_url = url
	end
	
end


