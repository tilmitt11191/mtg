
#ruby
require '../../lib/util/card.rb'
require '../../lib/card_operation/mana_analyzer.rb'

mana_analyzer = Mana_analyzer.new()


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
=end


#anyColorLandtypeA
card = Card.new("Corrupted Crossroads")
card.read_contents()
result = mana_analyzer.analyze_cardtype(card)
if result == "anyColorLandtypeA" then
	puts "anyColorLandtypeA[ok]"
else
	puts "analyze result = " + result.to_s
end

=begin
#abilityLandtypeA
card = Card.new("Westvale Abbey")
card.read_contents()
result = mana_analyzer.analyze_cardtype(card)
if result == "abilityLandtypeA" then
	puts "abilityLandtypeA[ok]"
else
	puts "analyze result = " + result.to_s
end
=end

#battleLand
#"Sunken Hollow"
#Åi{T}: Add {U} or {B} to your mana pool.Åj
#Sunken Hollow enters the battlefield tapped unless you control two or more basic lands.




