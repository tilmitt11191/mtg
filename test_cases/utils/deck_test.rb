# encoding: UTF-8
#ruby

require 'logger'
require 'test/unit'
require '../../lib/util/tests.rb' #for must
require '../../lib/util/utils.rb'
require '../../lib/util/deck.rb'

class Test_card < Test::Unit::TestCase
	@site
	class << self
		def startup
			puts File.basename(__FILE__).to_s + " start."
			@log = Logger.new("../../log")
			@log.info ""
			@log.info File.basename(__FILE__).to_s + " start."
			@log.info ""
		
		end
		def shutdown
			@log.info File.basename(__FILE__).to_s + " finished."
			puts File.basename(__FILE__).to_s + " finished."
		end
	end
	
	def setup
		@log = Logger.new("../../log")
	end

#methods
#initialize
#view_deck_list
#create_cardlist(create_mode)
#create_deckfile(filename, format, mode)
#read_deckfile(filename, format, mode)
#get_contents_of_all_cards
#get_sum_of_generating_manas
#set_information
#calc_price_of_whole_deck
#calc_num_of_all_cards_in_deck
#calc_num_of_lands_in_deck
#calc_num_of_mainboard_cards_in_deck
#merge_duplicated_cards!

	must "view_deck_list"
		deck = Deck.new()
	end

	must "initialize" do
		deck = Deck.new('initialize', 'test', '', @log)
		
		assert_equal 'initialize' ,deck.deckname
		assert_equal 0 ,deck.cards.size
		assert_equal nil ,deck.price
		assert_equal '' ,deck.sum_of_mainboard_generating_manas
		assert_equal '' ,deck.sum_of_sideboard_generating_manas
		assert_equal 'test' ,deck.list_type
		assert_equal '' ,deck.path
		#assert_equal '' ,deck.date
		#assert_equal '' ,deck.mana_analyzer

		assert_equal 0 ,deck.quantity_of_lands
		assert_equal 0 ,deck.quantity_of_creatures
		assert_equal 0 ,deck.quantity_of_spells
		assert_equal 0 ,deck.quantity_of_mainboard_cards
		assert_equal 0 ,deck.quantity_of_sideboard_cards
		assert_equal 0 ,deck.price_of_all
		assert_equal 0 ,deck.price_of_lands
		assert_equal 0 ,deck.price_of_creatures
		assert_equal 0 ,deck.price_of_spells
		assert_equal 0 ,deck.price_of_mainboard_cards
		assert_equal 0 ,deck.price_of_sideboard_cards
	end

end