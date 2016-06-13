

require	"logger"
require 'date'
require '../../lib/util/card.rb'
require "../../lib/util/store.rb"

class Archetype_selector
	@log
	@nominal_scale_labels #hash of cardname. key=cardname,value=label
	attr_accessor :log, :nominal_scale_labels
	
	

	def initialize(logger)
		@log = logger
		@log.info "Archetype_selector.initialize"
		@nominal_scale_labels = {}
	end

	#def select_archetype(&block)
	def select_archetype_of(deck, by:'default', &block)
		if deck.nil? then
			@log.error "Archetype_selector.select_archetype_of(nil)."
			exit 1
		end
		@log.info "Archetype_selector.select_archetype_of[(#{deck.deckname}]by[#{by}]) start."
		
		case by
		when 'store'
			@log.debug "Archetype_selector calls #{deck.deckname}.#{deck.store.store_name}.select_archetype_of(#{deck.deckname})."
			archetype = deck.store.select_archetype_of(deck)
			@log.info "archetype_selector.select_archetype_of[(#{deck.deckname}]by[#{by}]) return #{archetype}"
			return archetype

		when 'method'
			@log.debug "Archetype_selector calls method"
			if block_given?
				return yield
			else
				@log.error "no method"
				return nil
			end
		end
		
		@log.info "Archetype_selector.select_archetype(#{deck.deckname}) finished. return deck.archetype[#{deck.archetype}]."
	end
	
	
	
	def predict_archetype_of(deck)
		if deck.nil? then
			@log.error "Archetype_selector.predict_archetype_of(nil)."
			exit 1
		end
		@log.info "Archetype_selector.predict_archetype_of[(#{deck.deckname}]by[method]) start."
		return "WB"
	end
	
	
	
	def create_explanatory_variable(deck)
		if deck.nil? then
			@log.error "Archetype_selector.create_explanatory_variable(nil)."
			exit 1
		end
		@log.info "Archetype_selector.create_explanatory_variable(#{deck.deckname}]) start."

		renew_nominal_scale_labels(deck)
		
		variables = ""
		deck.cards.each do |card|
			if card.quantity.to_i <= 0 then
				@log.warn "Archetype_selector.create_explanatory_variable(#{deck.deckname}])"
				@log.warn "card.quantity is under 0."
			end
			card.quantity.to_i.times do
				variables = variables + "," + @nominal_scale_labels["#{card.name}"].to_s
			end
			variables.sub!(/^,/,'') #delete head comma
		end
		
		@log.info "Archetype_selector.create_explanatory_variable(#{deck.deckname}]) finished."
		@log.info "return variables[#{variables}]"
		return variables
	end
	
	def renew_nominal_scale_labels(deck)
		@log.info "Archetype_selector.renew_nominal_scale_labels(#{deck.deckname}]) start."
		deck.cards.each do |card|
			@nominal_scale_labels["#{card.name}"] = @nominal_scale_labels.size if @nominal_scale_labels["#{card.name}"].nil?
		end
		@log.info "Archetype_selector.renew_nominal_scale_labels(#{deck.deckname}]) finished."
	end

end


