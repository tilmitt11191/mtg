
#ruby
require '../../lib/util/deck.rb'
require '../../lib/util/store.rb'
require '../../lib/decklists/deck_prices.rb'

##from text file exported by magic online application.
#4 Evolving Wilds <-mainboardCards
#4 Caves of Koilos
#1 Plains
#4 Shambling Vent
#
#
#1 Kalitas, Traitor of Ghet <-sideboardCards
#3 Hallowed Moonlight
#1 Radiant Flames

##to
#info,WB_Con_tR_v1.4 0
#mainboardCards,Evolving Wilds,4,,nil,,,A,
#mainboardCards,Caves of Koilos,4,,nil,,,C-W-B,
#mainboardCards,Plains,1,,nil,,,W,
#mainboardCards,Shambling Vent,4,,nil,,,W-B,
#info,0 Spells 0
#info,60 MainboardCards 0 W15U4B21R11G4C6A4
#sideboardCards,KalitasPERIOD Traitor of Ghet,1,2BB,nil,,,nil,
#sideboardCards,Hallowed Moonlight,3,1W,nil,,,nil,
#sideboardCards,Radiant Flames,1,2R,nil,,,nil,
#info,15 SideboardCards 0 W0U0B0R0G0C0A0
#info,../../decks/magiconline/WB_Con_tR_v1.4.txt

decknames = ["WB_Con_tR_v1.4"]

decknames.each do |deckname|
	mo = MagicOnline.new
	deck = mo.read_deckfile(deckname, "../../decks/magiconline/" + deckname.to_s + ".txt")
	deck.get_contents
	deck.get_sum_of_generationg_manas
	deck.set_information

deck.create_deckfile("../../decks/" + deckname.to_s + ".csv", "card_type,name,quantity,manacost,generating_mana_type,price,store_url,price.date", "with_info")
end
