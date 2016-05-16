
require '../../lib/util/util.rb'
require '../../lib/util/deck.rb'
require '../../lib/decklists/deck_prices.rb'

puts "test_cases/deck_prices.write.rb start."

deckname = "WBConkD09283S"
deck = Deck.new(deckname, "hareruya", "http://www.hareruyamtg.com/jp/k/kD09283S/")
deck.read_deckfile("../../test_cases/decklists/WBConkD09283S.csv", "card_type,name,quantity,price,store_url,price.date,generating_mana_type", "with_info")
deck.calc_price_of_each_card_type
deck.calculate_price	

deck_prices = Deck_prices.new()
deck_prices.read("../../decks/decklist.csv")
deck_prices.add(deck)
deck_prices.write("../../decks/decklist.csv")
