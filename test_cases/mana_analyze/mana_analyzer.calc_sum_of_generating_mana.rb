
#ruby
require "logger"
require '../../lib/util/deck.rb'
require '../../lib/card_operation/mana_analyzer.rb'

puts File.basename(__FILE__).to_s + " start."
log = Logger.new("../../log", 5, 10 * 1024 * 1024)
log.info ""
log.info File.basename(__FILE__).to_s + " start."
log.info ""



#decompose_mana_symbol test
#mana_analyzer.decompose_mana_symbol("W-U").each do |mana|
#	puts mana
#end

decknames = ["WB_Con_tR_v1.4"]

decknames.each do |deckname|
	mo = MagicOnline.new
	deck = mo.read_deckfile(deckname, "../../decks/magiconline/" + deckname.to_s + ".txt")
	deck.get_contents_of_all_cards
	deck.set_information

	mana_analyzer = Mana_analyzer.new(deck)

	sum = mana_analyzer.calc_sum_of_generating_mana()
	if sum.size == 2 &&
		sum[0] == "W15U4B21R11G4C6A4" &&
			sum[1] == "W0U0B0R0G0C0A0" then
		puts "[ok]mana_analyzer.calc_sum_of_generating_mana"
	else
		puts "not ok.sum=" + sum.to_s
	end
end

log.info File.basename(__FILE__).to_s + " finished."
