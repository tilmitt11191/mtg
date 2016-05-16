
#output format
=begin
info	RG_RampkD09260S 55410					
land	Cinder Glade	4	600	http://www.hareruyamtg.com/jp/g/gBFZ000235JN/	2016-05-16T18:41:20+09:00	manually
land	Evolving Wilds	4	20	http://www.hareruyamtg.com/jp/g/gBFZ000236JN/	2016-05-16T18:41:23+09:00	manually
land	Forest	9	20	http://www.hareruyamtg.com/jp/g/gSOI000297JN/	2016-05-16T18:41:23+09:00	
land	Mountain	3	20	http://www.hareruyamtg.com/jp/g/gSOI000294JN/	2016-05-16T18:41:24+09:00	
land	Sanctum of Ugin	2	150	http://www.hareruyamtg.com/jp/g/gBFZ000242JN/	2016-05-16T18:41:25+09:00	manually
land	Shrine of the Forsaken Gods	1	180	http://www.hareruyamtg.com/jp/g/gBFZ000245JN/	2016-05-16T18:41:27+09:00	manually
land	Wastes	2	30	http://www.hareruyamtg.com/jp/g/gOGW000185JN/	2016-05-16T18:41:29+09:00	
info	25 Lands 3260					
creature	Dragonlord Atarka	4	1700	http://www.hareruyamtg.com/jp/g/gDTK000005JN/	2016-05-16T18:41:30+09:00	manually
creature	Hedron Crawler	4	30	http://www.hareruyamtg.com/jp/g/gOGW000164JN/	2016-05-16T18:41:33+09:00	manually
creature	Tireless Tracker	4	1500	http://www.hareruyamtg.com/jp/g/gSOI000233JN/	2016-05-16T18:41:35+09:00	manually
creature	UlamogPERIOD the Ceaseless Hunger	1	2100	http://www.hareruyamtg.com/jp/g/gBFZ000015JN/	2016-05-16T18:41:36+09:00	manually
creature	World Breaker	4	1300	http://www.hareruyamtg.com/jp/g/gOGW000126JN/	2016-05-16T18:41:39+09:00	manually
info	17 Creatures 20220					
spell	Kozilek's Return	4	1700	http://www.hareruyamtg.com/jp/g/gOGW000098JN/	2016-05-16T18:41:40+09:00	manually
spell	Nissa's Pilgrimage	2	60	http://www.hareruyamtg.com/jp/g/gORI000190JN/	2016-05-16T18:41:42+09:00	manually
spell	Ruin in Their Wake	2	30	http://www.hareruyamtg.com/jp/g/gOGW000122JN/	2016-05-16T18:41:44+09:00	manually
spell	Traverse the Ulvenwald	2	550	http://www.hareruyamtg.com/jp/g/gSOI000234JN/	2016-05-16T18:41:46+09:00	manually
spell	Oath of Nissa	4	650	http://www.hareruyamtg.com/jp/g/gOGW000140JN/	2016-05-16T18:41:59+09:00	C-A
spell	Hedron Archive	1	50	http://www.hareruyamtg.com/jp/g/gBFZ000223JN/	2016-05-16T18:42:01+09:00	manually
spell	ChandraPERIOD Flamecaller	3	3800	http://www.hareruyamtg.com/jp/g/gOGW000104JN/	2016-05-16T18:42:03+09:00	manually
info	18 Spells 22130					
info	60 MainboardCards 45610					
sideboardCards	KozilekPERIOD the Great Distortion	1	750	http://www.hareruyamtg.com/jp/g/gOGW000004JN/	2016-05-16T18:42:04+09:00	manually
sideboardCards	Oblivion Sower	4	450	http://www.hareruyamtg.com/jp/g/gBFZ000011JN/	2016-05-16T18:42:06+09:00	manually
sideboardCards	Thought-Knot Seer	4	1700	http://www.hareruyamtg.com/jp/g/gOGW000009JN/	2016-05-16T18:42:06+09:00	manually
sideboardCards	Clip Wings	4	50	http://www.hareruyamtg.com/jp/g/gSOI000197JN/	2016-05-16T18:42:08+09:00	manually
sideboardCards	Warping Wail	1	150	http://www.hareruyamtg.com/jp/g/gOGW000012JN/	2016-05-16T18:42:09+09:00	manually
sideboardCards	Roast	1	100	http://www.hareruyamtg.com/jp/g/gDTK000116JN/	2016-05-16T18:42:11+09:00	manually
info	15 SideboardCards 9800					
info	http://www.hareruyamtg.com/jp/k/kD09260S/					
=end


#command:
# cd mtg/lib/decklists # < - important!!
#	ruby get_hareruya_decks.rb
#output file:
#	mtg/decks/name+id.csv
#	mtg/decks/decklist.csv
#log:
#	tail -F ../../../mtg/log

#
#http://www.hareruyamtg.com/jp/
#http://www.hareruyamtg.com/jp/k/kD*****S/

require '../../lib/util/deck.rb'
require '../../lib/util/store.rb'
require '../../lib/decklists/deck_prices.rb'

class DeckID
	@id
	@name
	@hareruya
	
	def initialize(id,name)
		@id = id
		@name = name
		@hareruya = Hareruya.new()
	end
	
	def create_deckfile()
		deck = Deck.new(@name, "hareruya", "http://www.hareruyamtg.com/jp/k/" + @id + "/")
		deck.create_cardlist
		@hareruya.convert_all_cardname_from_jp_to_eng(deck)

		deck.get_contents
		
		#deck.calc_price_of_each_card_type
		#deck.calculate_price	

		deck.create_deckfile("../../decks/" + @name.to_s + ".csv", "card_type,name,quantity,price,store_url,price.date,generating_mana_type", "with_info")
		
		deck_prices = Deck_prices.new()
		deck_prices.read("../../decks/decklist.csv")
		deck_prices.add(deck)
		deck_prices.write("../../decks/decklist.csv")
	end
end

decks = []

##############################################

id = "kD08241S"
name = "BG_Control"+id.to_s
decks.push DeckID.new(id,name)

#id = "kD09259S"
#name = "Eldrazi_Stompy"+id.to_s
#decks.push DeckID.new(id,name)





##############################################



decks.each do |deck| deck.create_deckfile() end
	
puts "finished"

=begin
Pro Tour Shadows over Innistrad 2016
http://www.hareruyamtg.com/jp/k/kD08240S/
アーキタイプ 	白青黒コントロール/WUB Control
プレイヤー 	Yasooka Shouta

http://www.hareruyamtg.com/jp/k/kD08241S/
アーキタイプ 	黒緑コントロール/BG Control
プレイヤー 	JON FINKEL

http://www.hareruyamtg.com/jp/k/kD08242S/
アーキタイプ 	赤緑ゴーグル/RG Goggles
プレイヤー 	BRAD NELSON

http://www.hareruyamtg.com/jp/k/kD08243S/
アーキタイプ 	黒緑ハスク/BG Husk
プレイヤー 	LUIS SCOTT-VARGAS

http://www.hareruyamtg.com/jp/k/kD08244S/
アーキタイプ 	白赤コントロール/WR Control
プレイヤー 	LUIS SALVATTO





















=end