

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

	def select_archetype(deck)
		if deck.nil?
			@log.error "select_archetype(nil)."
			exit 1
		end
		@log.info "select_archetype(#{deck.deckname}) start."
		@log.info "select_archetype(#{deck.deckname}) finished. deck.archetype = #{deck.archetype}"
	end
	
end

