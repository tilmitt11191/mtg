
#ruby
require "logger"
require '../../lib/util/deck.rb'

begin
	puts File.basename(__FILE__).to_s + " start."
	@log = Logger.new("../../log", 5, 10 * 1024 * 1024)
	@log.info ""
	@log.info File.basename(__FILE__).to_s + " start."
	@log.info ""

	deckname = "BG_Con_kD08241S"

	deck = Deck.new(deckname, "hareruya", "http://www.hareruyamtg.com/jp/k/kD08241S/", @log)




#deck.create_cardlist("except_price")
#deck.view_deck_list

=begin
land,《進化する未開地/Evolving Wilds》,3,nil,http://www.hareruyamtg.com/jp/g/gBFZ000236JN/,
land,《森/Forest》,5,nil,http://www.hareruyamtg.com/jp/g/gSOI000297JN/,
land,《風切る泥沼/Hissing Quagmire》,4,nil,http://www.hareruyamtg.com/jp/g/gOGW000171JN/,
land,《ラノワールの荒原/Llanowar Wastes》,2,nil,http://www.hareruyamtg.com/jp/g/gORI000248JN/,
land,《沼/Swamp》,12,nil,http://www.hareruyamtg.com/jp/g/gSOI000291JN/,
creature,《ゲトの裏切り者、カリタス/Kalitas, Traitor of Ghet》,2,nil,http://www.hareruyamtg.com/jp/g/gOGW000086JN/,
creature,《巨森の予見者、ニッサ/Nissa, Vastwood Seer》,2,nil,http://www.hareruyamtg.com/jp/g/gORI000189JN/,
spell,《闇の掌握/Grasp of Darkness》,4,nil,http://www.hareruyamtg.com/jp/g/gOGW000085JN/,
spell,《究極の価格/Ultimate Price》,2,nil,http://www.hareruyamtg.com/jp/g/gDTK000144JN/,
spell,《闇の誓願/Dark Petition》,4,nil,http://www.hareruyamtg.com/jp/g/gORI000090JN/,
spell,《強迫/Duress》,2,nil,http://www.hareruyamtg.com/jp/g/gDTK000173JN/,
spell,《無限の抹消/Infinite Obliteration》,1,nil,http://www.hareruyamtg.com/jp/g/gORI000103JN/,
spell,《衰滅/Languish》,4,nil,http://www.hareruyamtg.com/jp/g/gORI000105JN/,
spell,《ニッサの復興/Nissa's Renewal》,1,nil,http://www.hareruyamtg.com/jp/g/gBFZ000180JN/,
spell,《骨読み/Read the Bones》,4,nil,http://www.hareruyamtg.com/jp/g/gORI000114JN/,
spell,《破滅の道/Ruinous Path》,3,nil,http://www.hareruyamtg.com/jp/g/gBFZ000123JN/,
spell,《過ぎ去った季節/Seasons Past》,2,nil,http://www.hareruyamtg.com/jp/g/gSOI000226JN/,
spell,《精神背信/Transgress the Mind》,2,nil,http://www.hareruyamtg.com/jp/g/gBFZ000101JN/,
spell,《死の重み/Dead Weight》,1,nil,http://www.hareruyamtg.com/jp/g/gSOI000106JN/,
sideboardCards,《ゲトの裏切り者、カリタス/Kalitas, Traitor of Ghet》,1,nil,http://www.hareruyamtg.com/jp/g/gOGW000086JN/,
sideboardCards,《翼切り/Clip Wings》,1,nil,http://www.hareruyamtg.com/jp/g/gSOI000197JN/,
sideboardCards,《帰化/Naturalize》,3,nil,http://www.hareruyamtg.com/jp/g/gDTK000205JN/,
sideboardCards,《究極の価格/Ultimate Price》,1,nil,http://www.hareruyamtg.com/jp/g/gDTK000144JN/,
sideboardCards,《強迫/Duress》,2,nil,http://www.hareruyamtg.com/jp/g/gDTK000173JN/,
sideboardCards,《無限の抹消/Infinite Obliteration》,1,nil,http://www.hareruyamtg.com/jp/g/gORI000103JN/,
sideboardCards,《死の重み/Dead Weight》,3,nil,http://www.hareruyamtg.com/jp/g/gSOI000106JN/,
sideboardCards,《悪性の疫病/Virulent Plague》,2,nil,http://www.hareruyamtg.com/jp/g/gDTK000145JN/,
sideboardCards,《護法の宝珠/Orbs of Warding》,1,nil,http://www.hareruyamtg.com/jp/g/gORI000234JN/,
=end


#deck.create_cardlist("full")
#deck.view_deck_list

=begin
land,《進化する未開地/Evolving Wilds》,3,20,http://www.hareruyamtg.com/jp/g/gBFZ000236JN/,2016-05-16T21:00:37+09:00
land,《森/Forest》,5,20,http://www.hareruyamtg.com/jp/g/gSOI000297JN/,2016-05-16T21:00:38+09:00
land,《風切る泥沼/Hissing Quagmire》,4,750,http://www.hareruyamtg.com/jp/g/gOGW000171JN/,2016-05-16T21:00:40+09:00
land,《ラノワールの荒原/Llanowar Wastes》,2,500,http://www.hareruyamtg.com/jp/g/gORI000248JN/,2016-05-16T21:00:41+09:00
land,《沼/Swamp》,12,20,http://www.hareruyamtg.com/jp/g/gSOI000291JN/,2016-05-16T21:00:42+09:00
creature,《ゲトの裏切り者、カリタス/Kalitas, Traitor of Ghet》,2,4500,http://www.hareruyamtg.com/jp/g/gOGW000086JN/,2016-05-16T21:00:44+09:00
creature,《巨森の予見者、ニッサ/Nissa, Vastwood Seer》,2,2100,http://www.hareruyamtg.com/jp/g/gORI000189JN/,2016-05-16T21:00:46+09:00
spell,《闇の掌握/Grasp of Darkness》,4,150,http://www.hareruyamtg.com/jp/g/gOGW000085JN/,2016-05-16T21:00:48+09:00
spell,《究極の価格/Ultimate Price》,2,80,http://www.hareruyamtg.com/jp/g/gDTK000144JN/,2016-05-16T21:00:50+09:00
spell,《闇の誓願/Dark Petition》,4,800,http://www.hareruyamtg.com/jp/g/gORI000090JN/,2016-05-16T21:00:51+09:00
spell,《強迫/Duress》,2,50,http://www.hareruyamtg.com/jp/g/gDTK000173JN/,2016-05-16T21:00:52+09:00
spell,《無限の抹消/Infinite Obliteration》,1,500,http://www.hareruyamtg.com/jp/g/gORI000103JN/,2016-05-16T21:00:54+09:00
spell,《衰滅/Languish》,4,1300,http://www.hareruyamtg.com/jp/g/gORI000105JN/,2016-05-16T21:00:56+09:00
spell,《ニッサの復興/Nissa's Renewal》,1,180,http://www.hareruyamtg.com/jp/g/gBFZ000180JN/,2016-05-16T21:00:58+09:00
spell,《骨読み/Read the Bones》,4,50,http://www.hareruyamtg.com/jp/g/gORI000114JN/,2016-05-16T21:01:00+09:00
spell,《破滅の道/Ruinous Path》,3,450,http://www.hareruyamtg.com/jp/g/gBFZ000123JN/,2016-05-16T21:01:03+09:00
spell,《過ぎ去った季節/Seasons Past》,2,800,http://www.hareruyamtg.com/jp/g/gSOI000226JN/,2016-05-16T21:01:05+09:00
spell,《精神背信/Transgress the Mind》,2,300,http://www.hareruyamtg.com/jp/g/gBFZ000101JN/,2016-05-16T21:01:07+09:00
spell,《死の重み/Dead Weight》,1,30,http://www.hareruyamtg.com/jp/g/gSOI000106JN/,2016-05-16T21:01:09+09:00
sideboardCards,《ゲトの裏切り者、カリタス/Kalitas, Traitor of Ghet》,1,4500,http://www.hareruyamtg.com/jp/g/gOGW000086JN/,2016-05-16T21:01:11+09:00
sideboardCards,《翼切り/Clip Wings》,1,50,http://www.hareruyamtg.com/jp/g/gSOI000197JN/,2016-05-16T21:01:13+09:00
sideboardCards,《帰化/Naturalize》,3,10,http://www.hareruyamtg.com/jp/g/gDTK000205JN/,2016-05-16T21:01:16+09:00
sideboardCards,《究極の価格/Ultimate Price》,1,80,http://www.hareruyamtg.com/jp/g/gDTK000144JN/,2016-05-16T21:01:18+09:00
sideboardCards,《強迫/Duress》,2,50,http://www.hareruyamtg.com/jp/g/gDTK000173JN/,2016-05-16T21:01:20+09:00
sideboardCards,《無限の抹消/Infinite Obliteration》,1,500,http://www.hareruyamtg.com/jp/g/gORI000103JN/,2016-05-16T21:01:22+09:00
sideboardCards,《死の重み/Dead Weight》,3,30,http://www.hareruyamtg.com/jp/g/gSOI000106JN/,2016-05-16T21:01:24+09:00
sideboardCards,《悪性の疫病/Virulent Plague》,2,60,http://www.hareruyamtg.com/jp/g/gDTK000145JN/,2016-05-16T21:01:28+09:00
sideboardCards,《護法の宝珠/Orbs of Warding》,1,60,http://www.hareruyamtg.com/jp/g/gORI000234JN/,2016-05-16T21:01:30+09:00

=end


rescue => e
	puts_write(e,@log)
end


@log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."


