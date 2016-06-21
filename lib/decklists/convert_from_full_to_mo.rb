
#ruby
require "logger"
require '../../lib/util/deck.rb'
require '../../lib/util/store.rb'
require '../../lib/util/deck_prices.rb'

begin
	puts File.basename(__FILE__).to_s + " start."
	@log = Logger.new("../../log", 5, 10 * 1024 * 1024)
	@log.info ""
	@log.info File.basename(__FILE__).to_s + " start."
	@log.info ""


	deckname = "WUG_Aggro_kD10803S"
	get_from = "web" #web or file
	mode_of_create_cardlist = "full"

	deck = Deck.new(deckname, "hareruya", "http://www.hareruyamtg.com/jp/k/kD10803S/",@log)
	hareruya = Hareruya.new(@log)

	case get_from
	when "web" then
		deck.create_cardlist(mode_of_create_cardlist)
		hareruya.convert_all_cardname_from_jp_to_eng(deck)

		deck.get_contents_of_all_cards
		deck.get_sum_of_generating_manas

		if mode_of_create_cardlist == "full" then
			deck.calc_price_of_whole_deck
		end

		deck.create_deckfile("../../decks/" + deckname.to_s + ".csv", "card_type,name,quantity,manacost,generating_mana_type,price,store_url,price.date", "with_info")

		if mode_of_create_cardlist == "full" then
			deck_prices = Deck_prices.new(@log)
			deck_prices.read("../../decks/decklist.csv")
			deck_prices.add(deck)
			deck_prices.write("../../decks/decklist.csv")
		end
	when "file" then
		deck.read_deckfile("../../decks/" + deckname.to_s + ".csv", "card_type,name,quantity,manacost,generating_mana_type,price,price.date,store_url", "with_info")
		hareruya.convert_all_cardname_from_jp_to_eng(deck)
	end

	mo = MagicOnline.new(@log)
	mo.create_card_list(deck, "../../decks/magiconline/" + deckname + ".txt")
	deck.create_deckfile("../../decks/magiconline/" + deckname + ".csv","card_type,name,quantity,manacost,generating_mana_type,price,store_url,price.date", 'with_info')
	
	
rescue => e
	puts_write(e,@log)
end


@log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."

