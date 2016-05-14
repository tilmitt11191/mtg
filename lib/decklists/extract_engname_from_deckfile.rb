
##from
##
##BG Con tW 60460					
##land	�s�R�C���X�̓��A/Caves of Koilos�t	2	250	http://www.hareruyamtg.com/jp/g/gORI000245JN/	2016-05-08T13:14:53+09:00
##land	�s�i�����関�J�n/Evolving Wilds�t	4	20	http://www.hareruyamtg.com/jp/g/gBFZ000236JN/	2016-05-08T13:14:56+09:00
##25 Lands 7240					
##creature	�s�Q�g�̗��؂�ҁA�J���^�X/Kalitas Traitor of Ghet�t	2	5000	http://www.hareruyamtg.com/jp/g/gOGW000086JN/	2016-05-08T13:15:13+09:00
##9 Creatures 20700					
##spell	�s�ł̏���/Grasp of Darkness�t	3	150	http://www.hareruyamtg.com/jp/g/gOGW000085JN/	2016-05-08T13:15:44+09:00
##26 Spells 21220					
##60 MainboardCards 49160					
##sideboardCards	�s�Q�g�̗��؂�ҁA�J���^�X/Kalitas Traitor of Ghet�t	1	5000	http://www.hareruyamtg.com/jp/g/gOGW000086JN/	2016-05-08T13:16:48+09:00
##15 SideboardCards					
##http://www.hareruyamtg.com/jp/k/kD01038K/					

##to
##Caves of Koilos
##Evolving Wilds
##Kalitas Traitor of Ghet
##Grasp of Darkness
##
##Kalitas Traitor of Ghet
require '../../lib/util/deck.rb'

deckname = "WBConhareruya"
deck = Deck.new(deckname, "hareruya", "http://www.hareruyamtg.com/jp/k/kD02923W/")
deck.read_deckfile("../../decks/" + deckname.to_s + ".csv")
store = Hareruya.new()
deck.store = store

File.open("../../decks/" + deckname.to_s + "_mo.csv", "w:sjis") do |file|
	deck.cards.each do |card|
		file.print store.extract_english_card_name(card.name).to_s + "," + card.quantity.to_s + "\n"
	end
end

#deck_at_mo = Deck.new(deckname, "mo", "")


