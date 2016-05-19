
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


deckname = "BG_Con_JF"
hareruya = Hareruya.new

#### read deck
#from file
deck = hareruya.read_deckfile("../../decks/" + deckname.to_s + ".csv", "card_type,cardname,quantity,manacost,generating_mana_type,price,store_url,price.date", "with_info")

mana_analyzer = Mana_analyzer.new(deck)

if ["U"] == mana_analyzer.decompose_needed_mana_symbol("U") then
	puts "[ok]decompose_needed_mana_symbol(U)"
else
	puts "[error]decompose_needed_mana_symbol(U)"
end
if ["W", "W"] == mana_analyzer.decompose_needed_mana_symbol("WW") then
	puts "[ok]decompose_needed_mana_symbol(WW)"
else
	puts "[error]decompose_needed_mana_symbol(WW)"
end
if ["2", "B", "B"] == mana_analyzer.decompose_needed_mana_symbol("2BB") then
	puts "[ok]decompose_needed_mana_symbol(2BB)"
else
	puts "[error]decompose_needed_mana_symbol(2BB)"
end
if ["12", "G", "G", "G"] == mana_analyzer.decompose_needed_mana_symbol("12GGG") then
	puts "[ok]decompose_needed_mana_symbol(12GGG)"
else
	puts "[error]decompose_needed_mana_symbol(12GGG)"
end


mana_analyzer.calc_sum_of_needed_mana()


sum = mana_analyzer.sum_of_manacost_point_at_mainboard()
if sum == 111 then
	puts "[ok]sum_of_manacost_point_at_mainboard"
else
	puts "[error]sum_of_manacost_point_at_mainboard = " + sum.to_s
end

sum = mana_analyzer.sum_of_manacost_point_at_sideboard()
if sum == 33 then
	puts "[ok]sum_of_manacost_point_at_sideboard"
else
	puts "[error]sum_of_manacost_point_at_sideboard = " + sum.to_s
end

sum = mana_analyzer.sum_of_needed_mana_at_mainboard
if sum == "W0U0B47R0G7C0" then
	puts "[ok]sum_of_needed_mana_at_mainboard"
else
	puts "[error]sum_of_needed_mana_at_mainboard = " + sum.to_s
end

sum = mana_analyzer.sum_of_needed_mana_at_sideboard
if sum == "W0U0B12R0G4C0" then
	puts "[ok]sum_of_needed_mana_at_sideboard"
else
	puts "[error]sum_of_needed_mana_at_sideboard = " + sum.to_s
end
