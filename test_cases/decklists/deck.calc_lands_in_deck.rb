
#ruby
#this method returns the number of lands in this deck.
require "logger"
require '../../lib/util/utils.rb'
require '../../lib/util/deck.rb'
require '../../lib/util/store.rb'


begin
	puts File.basename(__FILE__).to_s + " start."
	log = Logger.new("../../log", 5, 10 * 1024 * 1024)
	log.info ""
	log.info File.basename(__FILE__).to_s + " start."
	log.info ""
	
	
	
	decknames = ["WBConkD09283S"]

	#decknames = ["test_BGConJF"]
	hareruya = Hareruya.new(log)

	decknames.each do |deckname|
		deck = hareruya.read_deckfile("../../test_cases/decklists/output/" + deckname.to_s + ".csv", "card_type,cardname,quantity,manacost,generating_mana_type,price,store_url,price.date", "with_info")
		num_of_lands = deck.calc_lands_in_deck

		if num_of_lands == 25 then
			puts "[ok]deck.calc_lands_in_deck[" + deckname.to_s + ".csv].number of land cards are " + num_of_lands.to_s
		else
			puts "[ng]deck.calc_lands_in_deck[" + deckname.to_s + ".csv].number of land cards are " + num_of_lands.to_s
		end	
	end







	
	decknames = ["test_BGConJF"]

	#decknames = ["test_BGConJF"]
	hareruya = Hareruya.new(log)

	decknames.each do |deckname|
		deck = hareruya.read_deckfile("../../test_cases/decklists/output/" + deckname.to_s + ".csv", "card_type,cardname,quantity,manacost,generating_mana_type,price,store_url,price.date", "with_info")
		num_of_lands = deck.calc_lands_in_deck

		if num_of_lands == 26 then
			puts "[ok]deck.calc_lands_in_deck[" + deckname.to_s + ".csv].number of land cards are " + num_of_lands.to_s
		else
			puts "[ng]deck.calc_lands_in_deck[" + deckname.to_s + ".csv].number of land cards are " + num_of_lands.to_s
		end	
	end





rescue => e
	puts_write(e,log)
end


log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."

