
#ruby
require '../../lib/util/card.rb'
require '../../lib/card_operation/mana_analyzer.rb'

=begin


#damageLand
card = Card.new("Caves of Koilos")
card.read_contents()
card.set_generating_mana_type()
if card.generating_mana_type == "C-W-B" then
	puts "damageLand[ok]"
else
	puts card.name.to_s + ".generating_mana_type = " + card.generating_mana_type.to_s
	card.print_contents()
end
if !File.exist?("../../cards/" + card.name.to_s) then
	card.write_contents()
end


#SOItapinLand
card = Card.new("Highland Lake")
card.read_contents()
card.set_generating_mana_type()
if card.generating_mana_type == "U-R" then
	puts "SOItapinLand[ok]"
else
	puts card.name.to_s + ".generating_mana_type = " + card.generating_mana_type.to_s
end
card.print_contents()
if !File.exist?("../../cards/" + card.name.to_s) then
	card.write_contents()
end


#KTKtapinLand
card = Card.new("Opulent Palace")
card.read_contents()
card.set_generating_mana_type()
if card.generating_mana_type == "B-G-U" then
	puts "KTKtapinLand[ok]"
else
	puts card.name.to_s + ".generating_mana_type = " + card.generating_mana_type.to_s
end
card.print_contents()
if !File.exist?("../../cards/" + card.name.to_s) then
	card.write_contents()
end


#BFZMishraLand
card = Card.new("Shambling Vent")
card.read_contents()
card.set_generating_mana_type()
if card.generating_mana_type == "W-B" then
	puts "BFZMishraLand[ok]"
else
	puts card.name.to_s + ".generating_mana_type = " + card.generating_mana_type.to_s
end
card.print_contents()
if !File.exist?("../../cards/" + card.name.to_s) then
	card.write_contents()
end

#anyColorLandtypeA
card = Card.new("Corrupted Crossroads")
card.read_contents()
card.set_generating_mana_type()
if card.generating_mana_type == "C-A" then
	puts "anyColorLandtypeA[ok]"
else
	puts card.name.to_s + ".generating_mana_type = " + card.generating_mana_type.to_s
end
card.print_contents()
if !File.exist?("../../cards/" + card.name.to_s) then
	card.write_contents()
end


card = Card.new("Westvale Abbey")
card.read_contents()
card.set_generating_mana_type()
if card.generating_mana_type == "C" then
	puts card.name.to_s + "[ok]"
else
	puts card.name.to_s + ".generating_mana_type = " + card.generating_mana_type.to_s
end
card.print_contents()
if !File.exist?("../../cards/" + card.name.to_s) then
	card.write_contents()
end

=end








##occured exception

#Oath of Nissa #=>C-A
card = Card.new("Oath of Nissa")
card.read_contents()
card.set_generating_mana_type()
if card.generating_mana_type == "manually" then
	puts "Oath of Nissa[ok]"
else
	puts card.name.to_s + ".generating_mana_type = " + card.generating_mana_type.to_s
	card.print_contents()
end
if !File.exist?("../../cards/" + card.name.to_s) then
	card.write_contents()
end
