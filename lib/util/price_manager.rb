

require	"logger"
require 'date'
require '../../lib/util/card.rb'
require '../../lib/util/price.rb'

class Price_manager
	@log

	@card
	
	@relevant_price #Class Price
	@highest_price #Class Price
	@lowest_price #Class Price
	attr_accessor :card, :relevant_price, :highest_price, :lowest_price

	def initialize(card, logger)
		@log = logger
		if card.nil? then
			@log.warn "price_manager.initialize(nil)"
			@card = card
			@relevant_price = nil
			@highest_price = nil
			@lowest_price = nil
		else
			@log.info "price_manager of " + card.name + " initialize"
			@card = card
			@relevant_price = Price.new(card, @log)
			@highest_price = Price.new(card, @log)
			@lowest_price = Price.new(card, @log)
		end
	end
	
end

