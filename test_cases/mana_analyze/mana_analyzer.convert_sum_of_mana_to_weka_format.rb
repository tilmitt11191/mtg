
#ruby
require "logger"

require '../../lib/util/deck.rb'
require '../../lib/util/store.rb'
require '../../lib/card_operation/mana_analyzer.rb'

puts File.basename(__FILE__).to_s + " start."
log = Logger.new("../../log", 5, 10 * 1024 * 1024)
log.info ""
log.info File.basename(__FILE__).to_s + " start."
log.info ""


deckname = "BGConJF"
deck = Deck.new(deckname, "hareruya", "http://www.hareruyamtg.com/jp/k/kD08246S/")
deck.read_deckfile("../../test_cases/decklists/test_BGConJF.csv", "card_type,name,quantity,price,store_url,price.date,generating_mana_type", "with_info")
hareruya = Hareruya.new()
hareruya.convert_all_cardname_from_jp_to_eng(deck)
deck.get_contents_of_all_cards

mana_analyzer = Mana_analyzer.new(deck)
weka_line = mana_analyzer.convert_sum_of_mana_to_weka_format
if weka_line == "111,0,0,47,0,7,0,3,3,21,3,14,2 %BGConJF" then
	puts "[ok]mana_analyzer.convert_sum_of_mana_to_weka_format"
else
	puts "[ng]weka_line = " + weka_line.to_s
end

log.info File.basename(__FILE__).to_s + " finished."