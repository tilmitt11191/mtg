

require	"logger"
require 'date'
require '../../lib/util/card.rb'
require "../../lib/util/store.rb"

class Price
	include Comparable
	@log
	@value
	@date
	@store
	@card
	attr_accessor :value, :date

	def initialize(card, logger)
		@log = logger
		if card.nil? then
			@log.warn "price.initialize(nil)"
			@value = 0
			@date = nil
		else
			@log = Logger.new("../../log")
			@log.info "price of " + card.name + " initialize"
			@card = card
			@value = 0
			@date = nil
		end
	end
	
	def renew_at(storename)
		@log.debug "card.price.renew_at("+storename+")"
		case storename
		when "hareruya" then
			@log.debug "renew at hareruya start"
			@store = Hareruya.new()
			@value = @store.how_match?(@card)
			@log.debug "[" + @card.name.to_s + "] is [" + @value.to_s + "]"
			@date = DateTime.now
			@log.debug "date is " + @date.to_s
		else
			@log.error "Price.renew_at(invalid store)"
			@log.error "store name is " + storename
			@value = nil
		end
	end
	
	def to_s
		if @value.nil? then
			@log.warn @card.name.to_s + ".price.to_i = nil. return nil."
			"nil"
		else
			@value.to_s
		end
	end

	def to_i
		if @value.nil? then
			@log.error @card.name.to_s + ".price.to_i = nil. return 0."
			0
		else
			@value.to_i
		end
	end

	def +(price)
		@value += price.to_i
	end

	def <=>(other)
		@value.to_f - other.to_f
	end
	

end

