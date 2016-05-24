
#ruby
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
	
	decknames = ["test_BGConJF", "WBConkD09283S"]
	hareruya = Hareruya.new(log)

	decknames.each do |deckname|
		deck = hareruya.read_deckfile("../../test_cases/decklists/output/" + deckname.to_s + ".csv", "card_type,cardname,quantity,manacost,generating_mana_type,price,store_url,price.date", "with_info")
		sum = 0
		deck.cards.each do |card|
			sum += card.quantity.to_i
		end
		if sum == 75 then
			puts "[ok]hareruya.read_deck_file[" + deckname.to_s + ".csv].number of deck cards is 75."
		else
			puts "[ng]hareruya.read_deck_file[" + deckname.to_s + ".csv].number of deck cards is " + sum.to_s + "."
		end	
	end


rescue => e
	puts_write(e,log)
end


log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."

