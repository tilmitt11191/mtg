
#ruby
require '../../lib/util/card.rb'
require '../../lib/card_operation/mana_analyzer.rb'

card = Card.new("Evolving Wilds")
card.read_contents()
card.set_generating_mana_type()
if card.generating_mana_type == "A" then
	puts "Oath of Nissa[ok]"
else
	puts card.name.to_s + ".generating_mana_type = " + card.generating_mana_type.to_s
	card.print_contents()
end
if !File.exist?("../../cards/" + card.name.to_s) then
	card.write_contents()
end

#Drownyard Temple
#Game Trail