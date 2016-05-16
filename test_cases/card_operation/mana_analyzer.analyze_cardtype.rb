
#ruby
require '../../lib/util/card.rb'
require '../../lib/card_operation/mana_analyzer.rb'

mana_analyzer = Mana_analyzer.new()

card = Card.new("Plains")
card.read_contents()
result = mana_analyzer.analyze_cardtype(card)
if result == "basicLand" then
	puts "ok"
else
	puts "analyze result = " + result.to_s
end

=begin
card = Card.new("Caves of Koilos")
card.read_contents()
result = mana_analyzer.analyze_cardtype(card)
if result == "damageLand" then
	puts "ok"
else
	puts "analyze result = " + result.to_s
end

#Highland Lake
card = Card.new("Highland Lake")
card.read_contents()
result = mana_analyzer.analyze_cardtype(card)
if result == "SOItapinLand" then
	puts "ok"
else
	puts "analyze result = " + result.to_s
end

#Shambling Vent
card = Card.new("Shambling Vent")
card.read_contents()
result = mana_analyzer.analyze_cardtype(card)
if result == "SOItapinLand" then
	puts "ok"
else
	puts "analyze result = " + result.to_s
end

card = Card.new("Westvale Abbey")
card.read_contents()
result = mana_analyzer.analyze_cardtype(card)
if result == "SOItapinLand" then
	puts "ok"
else
	puts "analyze result = " + result.to_s
end

card = Card.new("Corrupted Crossroads")
card.read_contents()
result = mana_analyzer.analyze_cardtype(card)
if result == "SOItapinLand" then
	puts "ok"
else
	puts "analyze result = " + result.to_s
end
=end