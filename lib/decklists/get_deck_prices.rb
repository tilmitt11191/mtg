
require '../../lib/util/deck.rb'
require '../../lib/decklists/deck_prices.rb'

deckname = "WBConhareruya"
deck = Deck.new(deckname, "hareruya", "http://www.hareruyamtg.com/jp/k/kD02923W/")
deck.create_cardlist
deck.calc_price_of_each_card_type
deck.calculate_price
deck.create_deckfile("../../decks/" + deckname.to_s + ".csv")


deck_prices = Deck_prices.new()
deck_prices.read("../../decks/decklist.csv")
deck_prices.add(deck)
deck_prices.write("../../decks/decklist.csv")



