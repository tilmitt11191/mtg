# encoding: UTF-8
#ruby

require	"logger"
require 'date'
require '../../lib/util/card.rb'
require "../../lib/util/store.rb"

class Price
	include Comparable
	@log
	@card
	@value
	@date
	@store
	attr_accessor :value, :date, :store

	def initialize(card, logger)
		@log = logger
		@card = card || nil
		@value = 0
		@date = nil
		@store = Store.new('', logger)
	end
	
	def price=(value)
		puts "price.price= #{value}"
		@value = value
	end
	
	def to_s
		if @value.nil? then
			@log.debug @card.name.to_s + ".price.to_i = nil. return nil." if !@card.nil?
			nil
		else
			@value.to_s
		end
	end
	
	def to_i
		if @value.nil? then
			@log.debug @card.name.to_s + ".price.to_i = nil. return nil."
			nil
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


	def renew_at site, option=nil
		@log.info "#{__method__} start.card.name[#{@card.name}], site[#{site.name}]"
		@store = site
		
		if !@store.respond_to?(:how_match) then
			@log.fatal "#{@store} not have method(:how_match)"
			@log.info "#{__method__} finished."
			return 1
		end
		
		@date = DateTime.now
		@log.debug "date[#{@date.to_s}]"
		
		@value = site.how_match @card

		@log.info "#{__method__} finished.card.name[#{@card.name}], site[#{@store.name}], value[#{@value}]"
		self
	end
	
	

end

