

require	"logger"
require 'date'
require '../../lib/util/card.rb'
require "../../lib/util/store.rb"

class Price
	include Comparable
	@log
	@card
	#@name
	@value
	@date
	@store
	attr_accessor :value, :date

	def initialize(card, logger)
		@log = logger
		if card.nil? then
			@log.debug "price.initialize(nil)"
			@card = nil
			#@name = nil
			@value = nil
			@date = nil
		else
			@log = logger
			@log.info "price of " + card.name + " initialize"
			@card = card
			#@name = card.name
			@value = nil
			@date = nil
		end
	end

	def to_s
		if @value.nil? then
			@log.warn @name.to_s + ".price.to_i = nil. return nil."
			"nil"
		else
			@value.to_s
		end
	end

	def to_i
		if @value.nil? then
			@log.error @name.to_s + ".price.to_i = nil. return 0."
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

=begin
	def renew_at(card, storename)
		@log.debug "card.price.renew_at("+storename+")"
		case storename
		when "hareruya" then
			@log.debug "renew at hareruya start"
			@store = Hareruya.new(@log)
			@log.debug "#{@name}.price call hareruya.how_match?(card)"
			@store.how_match?(card)
			#@value = @store.how_match?(card)
			@log.debug "[" + card.name.to_s + "] is [" + @value.to_s + "]"
			@date = DateTime.now
			@log.debug "date is " + @date.to_s
		else
			@log.error "Price.renew_at(invalid store)"
			@log.error "store name is " + storename
			@log.error "card name is " + card.name
			@value = nil
		end
	end
=end
	def renew_at site
		@log.info "#{__method__} start.card.name[#{@card.name}], site[#{site.site_name}]"
		if !site.respond_to?(:how_match) then
			@log.fatal "#{site} not have method(:how_match)"
			puts "#{__method__} finished."
			return 1
		end
		
		@date = DateTime.now
		@log.debug "date[#{@date.to_s}]"
		
		@value = site.how_match @card

		@log.info "#{__method__} finished.card.name[#{@card.name}], site[#{site.site_name}], value[#{@value}]"
	end
	
	

end

