# encoding: UTF-8
#ruby

require 'logger'
require 'test/unit'
require '../../lib/util/tests.rb' #for must
require '../../lib/site/hareruya.rb'

class Test_hareruya < Test::Unit::TestCase
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
		@site = Hareruya.new(@log)
	end
	
	must "how_match" do
		card = Card.new('Liliana, the Last Hope', @log)
	end
=begin
	must "create deck from url" do
		url = 'http://www.hareruyamtg.com/jp/k/kD13230S/'
		deck = @site.create_deck_from_url(url, priceflag:'on')
		assert_equal 75, deck.calc_num_of_all_cards_in_deck
		assert_equal 26, deck.calc_num_of_lands_in_deck
		assert_equal 60, deck.calc_num_of_mainboard_cards_in_deck
		
		deck.create_deckfile('../../test_cases/site/sample_deck_WBConkD13230S.csv', 'card_type,name,quantity,price,store_url,price.date,generating_mana_type', 'with_info')
	end
	
	must "initialize" do
		assert_equal 'Hareruya', @site.name
		assert_equal 'http://www.hareruyamtg.com/jp/', @site.url
	end
=end
end



