

require	"logger"
require 'date'
require '../../lib/util/card.rb'
require "../../lib/util/store.rb"

class Price
	@log
	@value
	@date
	@store
	@card
	attr_accessor :value, :date

	def initialize(card)
		@log = Logger.new("../log")
		@log.info "price of " + card.name + " initialize"
		@card = card
		@value = nil
		@date = nil
	end
	
	def renew_at(storename)
		@log.debug "card.price.renew_at("+storename+")"
		@log.debug "date is " + @date.to_s
		case storename
		when "hareruya" then
			@log.debug "renew at hareruya start"
			@store = Hareruya.new()
			@value = @store.how_match?(@card)
			@log.debug "[" + @card.name.to_s + "] is [" + @value.to_s + "]"
			@date = DateTime.now
		else
			@log.error "Price.renew_at(invalid store)"
			@log.error "store name is " + storename
			@value = nil
		end
	end
	
	def to_s
		@log.debug "price.to_s"
		if @value.nil? then
			@log.error "price.to_i = nil. return nil."
			"nil"
		else
			@value.to_s
		end
	end

	def to_i
		@log.debug "price.to_i"
		if @value.nil? then
			@log.error "price.to_i = nil. return 0."
			0
		else
			@value.to_i
		end
	end

end

