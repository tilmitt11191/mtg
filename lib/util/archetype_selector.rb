

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
		if deck.nil?
			@log.error "Archetype_selector.select_archetype_of(nil)."
			exit 1
		end
		@log.info "Archetype_selector.select_archetype_of[(#{deck.deckname}]by[#{by}]) start."

		if by=='store' then
			@log.debug "Archetype_selector calls #{deck.deckname}.#{deck.store.store_name}.select_archetype_of(#{deck.deckname})."
			return deck.store.select_archetype_of(deck)
		end

		if by=='method' then
			@log.debug "Archetype_selector calls method"
			yield
		end
		
		@log.info "Archetype_selector.select_archetype(#{deck.deckname}) finished. return deck.archetype[#{deck.archetype}]."
	end

end


