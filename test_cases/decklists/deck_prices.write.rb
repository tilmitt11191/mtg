
require "logger"
require '../../lib/util/utils.rb'
require '../../lib/util/deck.rb'
require '../../lib/util/deck_prices.rb'


begin
	puts File.basename(__FILE__).to_s + " start."
	@log = Logger.new("../../log", 5, 10 * 1024 * 1024)
	@log.info ""
	@log.info File.basename(__FILE__).to_s + " start."
	@log.info ""


	deckname = "WBConkD09283S"
	deck = Deck.new(deckname, "hareruya", "http://www.hareruyamtg.com/jp/k/kD09283S/", @log)
	deck.read_deckfile("../../test_cases/decklists/output/WBConkD09283S.csv", "card_type,name,quantity,price,store_url,price.date,generating_mana_type", "with_info")
	deck.calc_price_of_whole_deck

	deck_prices = Deck_prices.new(@log)
	deck_prices.read("../../decks/decklist.csv")
	deck_prices.add(deck)
	deck_prices.write("../../decks/decklist.csv")
	
rescue => e
	puts_write(e,@log)
end


@log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."


