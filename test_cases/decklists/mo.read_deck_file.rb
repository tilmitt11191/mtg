
#ruby
require "logger"
require '../../lib/util/utils.rb'
require '../../lib/util/deck.rb'
require '../../lib/util/store.rb'

begin
	puts File.basename(__FILE__).to_s + " start."
	log = Logger.new("../../log", 5, 10 * 1024 * 1024)
	log.info ""
	log.info File.basename(__FILE__).to_s + " start."
	log.info ""


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

	decknames = ["WB_Con_tR_v1.4.mo"]

	decknames.each do |deckname|
		mo = MagicOnline.new(log)
		
	deck = mo.read_deckfile("deckname", "../../test_cases/decklists/output/" + deckname.to_s + ".txt",filetype:"text")
		sum = 0
		deck.cards.each do |card|
			sum += card.quantity
		end
		if sum == 75 then
			puts "[ok]mo.read_deck_file[" + deckname.to_s + ".txt].number of deck cards is 75."
		else
			puts "[ng]mo.read_deck_file[" + deckname.to_s + ".txt].number of deck cards is " + sum.to_s + "."
		end	
	end



##from csv file exported by magic online application.
#Card Name	Quantity	ID #	Rarity	Set	Collector #	Premium	Sideboarded
#Evolving Wilds	4	58527	Common	BFZ	236/274	No	No
#Caves of Koilos	4	57668	Rare	ORI	245/272	No	No
#Plains	1	60070	Basic Land	SOI	283/297	No	No
#Shambling Vent	4	58531	Rare	BFZ	244/274	No	No
#
#Kalitas, Traitor of Ghet	1	59417	Mythic Rare	OGW	86/184	No	Yes
#Hallowed Moonlight	3	57856	Rare	ORI	16/272	No	Yes
#Radiant Flames	1	58741	Rare	BFZ	151/274	No	Yes

	decknames = ["WB_Con_tR_v1.4.mo"]

	decknames.each do |deckname|
		mo = MagicOnline.new(log)
		
		deck = mo.read_deckfile("deckname", "../../test_cases/decklists/output/" + deckname.to_s + ".csv",filetype:"csv")
		sum = 0
		deck.cards.each do |card|
			sum += card.quantity
		end
		if sum == 75 then
			puts "[ok]mo.read_deck_file[" + deckname.to_s + ".csv].number of deck cards is 75."
		else
			puts "[ng]mo.read_deck_file[" + deckname.to_s + ".csv].number of deck cards is " + sum.to_s + "."
		end
		#deck.view_deck_list
		mo.create_card_list(deck, "../../test_cases/decklists/output/test.txt")
	end



rescue => e
	puts_write(e,log)
end


log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."
