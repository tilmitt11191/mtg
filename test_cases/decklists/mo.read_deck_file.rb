
#ruby
require '../../lib/util/deck.rb'
require '../../lib/util/store.rb'

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
#mainboardCards,Evolving Wilds,4,nil,,,
#mainboardCards,Caves of Koilos,4,nil,,,
#mainboardCards,Plains,1,nil,,,
#mainboardCards,Shambling Vent,4,nil,,,
#sideboardCards,Kalitas, Traitor of Ghet,1,nil,,,
#sideboardCards,Hallowed Moonlight,3,nil,,,
#sideboardCards,Radiant Flames,1,nil,,,

decknames = ["WB_Con_tR_v1.4"]

decknames.each do |deckname|
	mo = MagicOnline.new
	deck = mo.read_deckfile("deckname", "../../test_cases/decklists/" + deckname.to_s + ".txt")

	deck.view_deck_list
end