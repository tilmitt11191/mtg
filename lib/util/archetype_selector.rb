

require	"logger"
require 'date'
require '../../lib/util/card.rb'
require "../../lib/util/store.rb"

class Archetype_selector
	@log
	attr_accessor :log

	def initialize(logger)
		@log = logger
		@log.info "Archetype_selector.initialize"
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
				yield
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
	
	end

end


