
#ruby
require '../../lib/util/deck.rb'
require '../../lib/util/store.rb'
require '../../lib/decklists/deck_prices.rb'


deckname = "RGRampkD09290S"
get_from = "web" #web or file

deck = Deck.new(deckname, "hareruya", "http://www.hareruyamtg.com/jp/k/kD09290S/")
#deck.read_deckfile("../../decks/" + deckname.to_s + ".csv" , "card_type,name,quantity,price,store_url,price.date,generating_mana_type", "with_info")

case get_from
when "web"
	deck.create_cardlist
	deck.calc_price_of_each_card_type
	deck.calculate_price	
	deck.create_deckfile("../../decks/" + deckname.to_s + ".csv", "card_type,name,quantity,price,store_url,price.date,generating_mana_type", "with_info")

	deck_prices = Deck_prices.new()
	deck_prices.read("../../decks/decklist.csv")
	deck_prices.add(deck)
	deck_prices.write("../../decks/decklist.csv")
#when "file"
end


hareruya = Hareruya.new()
hareruya.convert_all_cardname_from_jp_to_eng(deck)
mo = MagicOnline.new
mo.create_card_list(deck, "../../decks/magiconline/" + deckname + ".txt")
