
require '../../lib/util/deck.rb'
require '../../lib/decklists/deck_prices.rb'

deckname = "WBConkD09283S"
deck = Deck.new(deckname, "hareruya", "http://www.hareruyamtg.com/jp/k/kD09283S/")
deck.create_cardlist
deck.calc_price_of_each_card_type
deck.calculate_price
deck.create_deckfile("../../decks/" + deckname.to_s + ".csv", "card_type,name,quantity,price,store_url,price.date,generating_mana_type", "with_info")


deck_prices = Deck_prices.new()
deck_prices.read("../../decks/decklist.csv")
deck_prices.add(deck)
deck_prices.write("../../decks/decklist.csv")



