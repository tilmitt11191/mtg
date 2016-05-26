
#ruby
require "logger"
require '../../lib/util/deck.rb'
require '../../lib/util/store.rb'


begin
	puts File.basename(__FILE__).to_s + " start."
	@log = Logger.new("../../log", 5, 10 * 1024 * 1024)
	@log.info ""
	@log.info File.basename(__FILE__).to_s + " start."
	@log.info ""
	

deckname = "WBConkD09283S"
deck = Deck.new(deckname, "hareruya", "http://www.hareruyamtg.com/jp/k/kD09283S/", @log)
deck.read_deckfile("../../test_cases/decklists/output/WBConkD09283S.csv", "card_type,name,quantity,price,store_url,price.date,generating_mana_type", "with_info")
hareruya = Hareruya.new(@log)
hareruya.convert_all_cardname_from_jp_to_eng(deck)

mo = MagicOnline.new(@log)
mo.create_card_list(deck, "../../test_cases/decklists/WBConkD09283S.txt")

rescue => e
	puts_write(e,@log)
end


@log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."

