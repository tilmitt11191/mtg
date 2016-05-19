
#ruby
require "logger"
require '../../lib/util/card.rb'
require '../../lib/card_operation/mana_analyzer.rb'

puts File.basename(__FILE__).to_s + " start."
log = Logger.new("../../log", 5, 10 * 1024 * 1024)
log.info ""
log.info File.basename(__FILE__).to_s + " start."
log.info ""


mana_analyzer = Mana_analyzer.new(nil)


#wastes
card = Card.new("Wastes")
card.read_contents()
result = mana_analyzer.analyze_cardtype(card)
if result == "wastes" then
	puts "wastes[ok]"
else
	puts "analyze result = " + result.to_s
end


=begin
#damageLand
card = Card.new("Caves of Koilos")
card.read_contents()
result = mana_analyzer.analyze_cardtype(card)
if result == "damageLand" then
	puts "damageLand[ok]"
else
	puts "analyze result = " + result.to_s
end

#SOItapinLand
card = Card.new("Highland Lake")
card.read_contents()
result = mana_analyzer.analyze_cardtype(card)
if result == "SOItapinLand" then
	puts "SOItapinLand[ok]"
else
	puts "analyze result = " + result.to_s
end


#KTKtapinLand
card = Card.new("Opulent Palace")
card.read_contents()
result = mana_analyzer.analyze_cardtype(card)
if result == "KTKtapinLand" then
	puts "KTKtapinLand[ok]"
else
	puts "analyze result = " + result.to_s
end


#BFZMishraLand
card = Card.new("Shambling Vent")
card.read_contents()
result = mana_analyzer.analyze_cardtype(card)
if result == "BFZMishraLand" then
	puts "BFZMishraLand[ok]"
else
	puts "analyze result = " + result.to_s
end

#battleLand
#"Sunken Hollow"
#Å{T}: Add {U} or {B} to your mana pool.Å
#Sunken Hollow enters the battlefield tapped unless you control two or more basic lands.
card = Card.new("Sunken Hollow")
card.read_contents()
result = mana_analyzer.analyze_cardtype(card)
if result == "battleLand" then
	puts "battleLand[ok]"
else
	puts "analyze result = " + result.to_s
end

#shadowLand
#"Game Trail"
#As Game Trail enters the battlefield, you may reveal a Mountain or Forest card from your hand. If you don&apos;t, Game Trail enters the battlefield tapped.
#{T}: Add {R} or {G} to your mana pool.card = Card.new("Sunken Hollow")
card = Card.new("Game Trail")
card.read_contents()
result = mana_analyzer.analyze_cardtype(card)
if result == "shadowLand" then
	puts "shadowLand[ok]"
else
	puts "analyze result = " + result.to_s
end

#abilityColorlessLandtypeA
#Drownyard Temple, Westvale Abbey
#Rogue's Passage
cardnames = ["Drownyard Temple", "Westvale Abbey", "Rogue's Passage"]
cardnames.each do |cardname|
	card = Card.new(cardname)
	card.read_contents()
	result = mana_analyzer.analyze_cardtype(card)
	if result == "abilityColorlessLandtypeA" then
		puts cardname + ".abilityColorlessLandtypeA[ok]"
	else
		puts cardname.to_s + " result = " + result.to_s
	end
end
=end


=begin
#anyColorLandtypeA
card = Card.new("Corrupted Crossroads")
card.read_contents()
result = mana_analyzer.analyze_cardtype(card)
if result == "anyColorLandtypeA" then
	puts "anyColorLandtypeA[ok]"
else
	puts "analyze result = " + result.to_s
end

=end




