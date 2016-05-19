
#ruby
require "logger"
require '../../lib/util/card.rb'
require '../../lib/card_operation/mana_analyzer.rb'

puts File.basename(__FILE__).to_s + " start."
log = Logger.new("../../log", 5, 10 * 1024 * 1024)
log.info ""
log.info File.basename(__FILE__).to_s + " start."
log.info ""

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


#shadowLand
card = Card.new("Game Trail")
card.read_contents()
card.set_generating_mana_type()
if card.generating_mana_type == "R-G" then
	puts "shadowLand[ok]"
else
	puts card.name.to_s + ".generating_mana_type = " + card.generating_mana_type.to_s
end
card.print_contents()
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


#battleLand
#"Sunken Hollow"
#i{T}: Add {U} or {B} to your mana pool.j
#Sunken Hollow enters the battlefield tapped unless you control two or more basic lands.
card = Card.new("Sunken Hollow")
card.read_contents()
card.set_generating_mana_type()
if card.generating_mana_type == "U-B" then
	puts card.name.to_s + "[ok]"
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
=end


#abilityColorlessLandtypeA
#Drownyard Temple, Westvale Abbey
#Rogue's Passage
cardnames = ["Drownyard Temple", "Westvale Abbey", "Rogue's Passage"]
cardnames.each do |cardname|
	card = Card.new(cardname)
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
end


#Wastes
card = Card.new("Wastes")
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







##occured exception
=begin
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
=end