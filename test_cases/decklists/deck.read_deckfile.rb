
require '../../lib/util/deck.rb'
require '../../lib/decklists/deck_prices.rb'

puts "test_cases/deck.read_deckfile.rb start"

deckname = "BGConJF"
deck = Deck.new(deckname, "hareruya", "http://www.hareruyamtg.com/jp/k/kD08246S/")
deck.read_deckfile("../../decks/BGConJF.csv", "card_type,name,quantity,price,store_url,price.date,generating_mana_type", "with_info")
#deck.view_deck_list

sum = 0
deck.cards.each do |card| sum += card.quantity.to_i end
if sum == 75 then
	puts "ok"
else
	puts "sum = " + sum.to_s
end


#quantity and price
if deck.price_of_all == 41930 then
	puts "ok"
else
	puts "deck.price_of_all = " + deck.price_of_all.to_s
end


if deck.quantity_of_lands == 26 then
	puts "ok"
else
	puts "deck.quantity_of_lands = " + deck.quantity_of_lands.to_s
end

if deck.price_of_lands == 4700 then
	puts "ok"
else
	puts "deck.price_of_lands = " + deck.price_of_lands.to_s
end


if deck.quantity_of_creatures == 4 then
	puts "ok"
else
	puts "deck.quantity_of_creatures = " + deck.quantity_of_creatures.to_s
end

if deck.price_of_creatures == 14800 then
	puts "ok"
else
	puts "deck.price_of_creatures = " + deck.price_of_creatures.to_s
end


if deck.quantity_of_spells == 30 then
	puts "ok"
else
	puts "deck.quantity_of_spells = " + deck.quantity_of_spells.to_s
end

if deck.price_of_spells == 16470 then
	puts "ok"
else
	puts "deck.price_of_spells = " + deck.price_of_spells.to_s
end


if deck.quantity_of_mainboard_cards == 60 then
	puts "ok"
else
	puts "deck.quantity_of_mainboard_cards = " + deck.quantity_of_mainboard_cards.to_s
end

if deck.price_of_mainboard_cards == 35970 then
	puts "ok"
else
	puts "deck.price_of_mainboard_cards = " + deck.price_of_mainboard_cards.to_s
end


if deck.quantity_of_sideboard_cards == 15 then
	puts "ok"
else
	puts "deck.quantity_of_sideboard_cards = " + deck.quantity_of_sideboard_cards.to_s
end

if deck.price_of_sideboard_cards == 5960 then
	puts "ok"
else
	puts "deck.price_of_sideboard_cards = " + deck.price_of_sideboard_cards.to_s
end


if deck.cards[0].name == "《進化する未開地/Evolving Wilds》" then
	puts "ok"
else
	puts "deck.cards[0].name = " + deck.cards[0].name.to_s
end

if deck.cards[27].name == "《護法の宝珠/Orbs of Warding》" then
	puts "ok"
else
	puts "deck.cards[27].name = " + deck.cards[27].name.to_s
end

deck.view_deck_list
