
#ruby
require '../../lib/util/deck.rb'
require '../../lib/util/store.rb'
require '../../lib/decklists/deck_prices.rb'

deckname = "Monitor_Combo_kD03044W"
get_from = "file" #web or file

deck = Deck.new(deckname, "hareruya", "http://www.hareruyamtg.com/jp/k/kD09439S/")
#deck.read_deckfile("../../decks/" + deckname.to_s + ".csv" , "card_type,name,quantity,price,store_url,price.date,generating_mana_type", "with_info")
hareruya = Hareruya.new()

case get_from
when "web" then
	deck.create_cardlist("full")
	deck.calc_price_of_each_card_type
	hareruya.convert_all_cardname_from_jp_to_eng(deck)

	deck.get_contents
	deck.get_sum_of_generationg_manas

	deck.calculate_price
	deck.create_deckfile("../../decks/" + deckname.to_s + ".csv", "card_type,name,quantity,manacost,generating_mana_type,price,store_url,price.date", "with_info")

	deck_prices = Deck_prices.new()
	deck_prices.read("../../decks/decklist.csv")
	deck_prices.add(deck)
	deck_prices.write("../../decks/decklist.csv")
when "file" then
	deck.read_deckfile("../../decks/" + deckname.to_s + ".csv", "card_type,name,quantity,manacost,generating_mana_type,price,price.date,store_url", "with_info")
	hareruya.convert_all_cardname_from_jp_to_eng(deck)
end



mo = MagicOnline.new
mo.create_card_list(deck, "../../decks/magiconline/" + deckname + ".txt")
