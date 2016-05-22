
#ruby
require "logger"
require '../../lib/util/utils.rb'
require '../../lib/util/deck.rb'
	#create filename.csv.
		#info,BG Con JF 41930 W3U3B21R3G14C2A3
		#land,Evolving Wilds,3,20,http://www.hareruyamtg.com/jp/g/gBFZ000236JN/,2016-05-08T13:07:46+09:00,
		#land,Forest,5,20,http://www.hareruyamtg.com/jp/g/gSOI000297JN/,2016-05-08T13:07:47+09:00,
		#land,Hissing Quagmire,4,850,http://www.hareruyamtg.com/jp/g/gOGW000171JN/,2016-05-08T13:07:59+09:00,
		#:
		#spell,Transgress the Mind,2,300,http://www.hareruyamtg.com/jp/g/gBFZ000101JN/,2016-05-08T13:09:49+09:00,
		#spell,Dead Weight,1,30,http://www.hareruyamtg.com/jp/g/gSOI000106JN/,2016-05-08T13:09:51+09:00,
		#info,30 Spells 16470
		#info,60 MainboardCards 35970 111 W0U0B47R0G7C0
		#sideboardCards,Kalitas Traitor of Ghet,1,5000,http://www.hareruyamtg.com/jp/g/gOGW000086JN/,2016-05-08T13:09:52+09:00,
		#sideboardCards,Clip Wings,1,50,http://www.hareruyamtg.com/jp/g/gSOI000197JN/,2016-05-08T13:09:54+09:00,
		#sideboardCards,Naturalize,3,10,http://www.hareruyamtg.com/jp/g/gDTK000205JN/,2016-05-08T13:09:56+09:00,
		#:
		#	sideboardCards,Orbs of Warding,1,60,http://www.hareruyamtg.com/jp/g/gORI000234JN/,2016-05-08T13:10:19+09:00,
		#info,15 SideboardCards 5960 33 W0U0B12R0G4C0
		#info,http://www.hareruyamtg.com/jp/k/kD08246S/


	#selective format:
	#card_type,name,quantity,price,store_url,price.date,generating_mana_type
	#selective mode:
	#"with_info", "card_only"

	#the format for get_generating_mana_of_decks.rb
	#"card_type,name,quantity,generating_mana_type"
	#mode:with_info

	#the format for get_deck_prices.rb
	#"card_type,name,quantity,price,store_url,price.date,generating_mana_type"
	#mode:with_info


begin
	puts File.basename(__FILE__).to_s + " start."
	log = Logger.new("../../log", 5, 10 * 1024 * 1024)
	log.info ""
	log.info File.basename(__FILE__).to_s + " start."
	log.info ""


	deckname = "BG Con JF"
	deck = Deck.new(deckname, "hareruya", "http://www.hareruyamtg.com/jp/k/kD08246S/", log)
	deck.read_deckfile("../../decks/BGConJF.csv", "card_type,name,quantity,price,store_url,price.date,generating_mana_type", "with_price")

	## set info
	hareruya = Hareruya.new(log)
	hareruya.convert_all_cardname_from_jp_to_eng(deck)

	#with_info
	deck.create_deckfile("../../test_cases/decklists/output/test_BGConJF.csv", "card_type,name,quantity,price,store_url,price.date", "with_info")
	#diff("../../decks/BGConJF.csv", "../../test_cases/decklists/test_BGConJF.csv") #TODO


rescue => e
	puts_write(e,log)
end


log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."

