
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
land,�s�i�����関�J�n/Evolving Wilds�t,3,nil,http://www.hareruyamtg.com/jp/g/gBFZ000236JN/,
land,�s�X/Forest�t,5,nil,http://www.hareruyamtg.com/jp/g/gSOI000297JN/,
land,�s���؂�D��/Hissing Quagmire�t,4,nil,http://www.hareruyamtg.com/jp/g/gOGW000171JN/,
land,�s���m���[���̍r��/Llanowar Wastes�t,2,nil,http://www.hareruyamtg.com/jp/g/gORI000248JN/,
land,�s��/Swamp�t,12,nil,http://www.hareruyamtg.com/jp/g/gSOI000291JN/,
creature,�s�Q�g�̗��؂�ҁA�J���^�X/Kalitas, Traitor of Ghet�t,2,nil,http://www.hareruyamtg.com/jp/g/gOGW000086JN/,
creature,�s���X�̗\���ҁA�j�b�T/Nissa, Vastwood Seer�t,2,nil,http://www.hareruyamtg.com/jp/g/gORI000189JN/,
spell,�s�ł̏���/Grasp of Darkness�t,4,nil,http://www.hareruyamtg.com/jp/g/gOGW000085JN/,
spell,�s���ɂ̉��i/Ultimate Price�t,2,nil,http://www.hareruyamtg.com/jp/g/gDTK000144JN/,
spell,�s�ł̐���/Dark Petition�t,4,nil,http://www.hareruyamtg.com/jp/g/gORI000090JN/,
spell,�s����/Duress�t,2,nil,http://www.hareruyamtg.com/jp/g/gDTK000173JN/,
spell,�s�����̖���/Infinite Obliteration�t,1,nil,http://www.hareruyamtg.com/jp/g/gORI000103JN/,
spell,�s����/Languish�t,4,nil,http://www.hareruyamtg.com/jp/g/gORI000105JN/,
spell,�s�j�b�T�̕���/Nissa's Renewal�t,1,nil,http://www.hareruyamtg.com/jp/g/gBFZ000180JN/,
spell,�s���ǂ�/Read the Bones�t,4,nil,http://www.hareruyamtg.com/jp/g/gORI000114JN/,
spell,�s�j�ł̓�/Ruinous Path�t,3,nil,http://www.hareruyamtg.com/jp/g/gBFZ000123JN/,
spell,�s�߂��������G��/Seasons Past�t,2,nil,http://www.hareruyamtg.com/jp/g/gSOI000226JN/,
spell,�s���_�w�M/Transgress the Mind�t,2,nil,http://www.hareruyamtg.com/jp/g/gBFZ000101JN/,
spell,�s���̏d��/Dead Weight�t,1,nil,http://www.hareruyamtg.com/jp/g/gSOI000106JN/,
sideboardCards,�s�Q�g�̗��؂�ҁA�J���^�X/Kalitas, Traitor of Ghet�t,1,nil,http://www.hareruyamtg.com/jp/g/gOGW000086JN/,
sideboardCards,�s���؂�/Clip Wings�t,1,nil,http://www.hareruyamtg.com/jp/g/gSOI000197JN/,
sideboardCards,�s�A��/Naturalize�t,3,nil,http://www.hareruyamtg.com/jp/g/gDTK000205JN/,
sideboardCards,�s���ɂ̉��i/Ultimate Price�t,1,nil,http://www.hareruyamtg.com/jp/g/gDTK000144JN/,
sideboardCards,�s����/Duress�t,2,nil,http://www.hareruyamtg.com/jp/g/gDTK000173JN/,
sideboardCards,�s�����̖���/Infinite Obliteration�t,1,nil,http://www.hareruyamtg.com/jp/g/gORI000103JN/,
sideboardCards,�s���̏d��/Dead Weight�t,3,nil,http://www.hareruyamtg.com/jp/g/gSOI000106JN/,
sideboardCards,�s�����̉u�a/Virulent Plague�t,2,nil,http://www.hareruyamtg.com/jp/g/gDTK000145JN/,
sideboardCards,�s��@�̕��/Orbs of Warding�t,1,nil,http://www.hareruyamtg.com/jp/g/gORI000234JN/,
=end


#deck.create_cardlist("full")
#deck.view_deck_list

=begin
land,�s�i�����関�J�n/Evolving Wilds�t,3,20,http://www.hareruyamtg.com/jp/g/gBFZ000236JN/,2016-05-16T21:00:37+09:00
land,�s�X/Forest�t,5,20,http://www.hareruyamtg.com/jp/g/gSOI000297JN/,2016-05-16T21:00:38+09:00
land,�s���؂�D��/Hissing Quagmire�t,4,750,http://www.hareruyamtg.com/jp/g/gOGW000171JN/,2016-05-16T21:00:40+09:00
land,�s���m���[���̍r��/Llanowar Wastes�t,2,500,http://www.hareruyamtg.com/jp/g/gORI000248JN/,2016-05-16T21:00:41+09:00
land,�s��/Swamp�t,12,20,http://www.hareruyamtg.com/jp/g/gSOI000291JN/,2016-05-16T21:00:42+09:00
creature,�s�Q�g�̗��؂�ҁA�J���^�X/Kalitas, Traitor of Ghet�t,2,4500,http://www.hareruyamtg.com/jp/g/gOGW000086JN/,2016-05-16T21:00:44+09:00
creature,�s���X�̗\���ҁA�j�b�T/Nissa, Vastwood Seer�t,2,2100,http://www.hareruyamtg.com/jp/g/gORI000189JN/,2016-05-16T21:00:46+09:00
spell,�s�ł̏���/Grasp of Darkness�t,4,150,http://www.hareruyamtg.com/jp/g/gOGW000085JN/,2016-05-16T21:00:48+09:00
spell,�s���ɂ̉��i/Ultimate Price�t,2,80,http://www.hareruyamtg.com/jp/g/gDTK000144JN/,2016-05-16T21:00:50+09:00
spell,�s�ł̐���/Dark Petition�t,4,800,http://www.hareruyamtg.com/jp/g/gORI000090JN/,2016-05-16T21:00:51+09:00
spell,�s����/Duress�t,2,50,http://www.hareruyamtg.com/jp/g/gDTK000173JN/,2016-05-16T21:00:52+09:00
spell,�s�����̖���/Infinite Obliteration�t,1,500,http://www.hareruyamtg.com/jp/g/gORI000103JN/,2016-05-16T21:00:54+09:00
spell,�s����/Languish�t,4,1300,http://www.hareruyamtg.com/jp/g/gORI000105JN/,2016-05-16T21:00:56+09:00
spell,�s�j�b�T�̕���/Nissa's Renewal�t,1,180,http://www.hareruyamtg.com/jp/g/gBFZ000180JN/,2016-05-16T21:00:58+09:00
spell,�s���ǂ�/Read the Bones�t,4,50,http://www.hareruyamtg.com/jp/g/gORI000114JN/,2016-05-16T21:01:00+09:00
spell,�s�j�ł̓�/Ruinous Path�t,3,450,http://www.hareruyamtg.com/jp/g/gBFZ000123JN/,2016-05-16T21:01:03+09:00
spell,�s�߂��������G��/Seasons Past�t,2,800,http://www.hareruyamtg.com/jp/g/gSOI000226JN/,2016-05-16T21:01:05+09:00
spell,�s���_�w�M/Transgress the Mind�t,2,300,http://www.hareruyamtg.com/jp/g/gBFZ000101JN/,2016-05-16T21:01:07+09:00
spell,�s���̏d��/Dead Weight�t,1,30,http://www.hareruyamtg.com/jp/g/gSOI000106JN/,2016-05-16T21:01:09+09:00
sideboardCards,�s�Q�g�̗��؂�ҁA�J���^�X/Kalitas, Traitor of Ghet�t,1,4500,http://www.hareruyamtg.com/jp/g/gOGW000086JN/,2016-05-16T21:01:11+09:00
sideboardCards,�s���؂�/Clip Wings�t,1,50,http://www.hareruyamtg.com/jp/g/gSOI000197JN/,2016-05-16T21:01:13+09:00
sideboardCards,�s�A��/Naturalize�t,3,10,http://www.hareruyamtg.com/jp/g/gDTK000205JN/,2016-05-16T21:01:16+09:00
sideboardCards,�s���ɂ̉��i/Ultimate Price�t,1,80,http://www.hareruyamtg.com/jp/g/gDTK000144JN/,2016-05-16T21:01:18+09:00
sideboardCards,�s����/Duress�t,2,50,http://www.hareruyamtg.com/jp/g/gDTK000173JN/,2016-05-16T21:01:20+09:00
sideboardCards,�s�����̖���/Infinite Obliteration�t,1,500,http://www.hareruyamtg.com/jp/g/gORI000103JN/,2016-05-16T21:01:22+09:00
sideboardCards,�s���̏d��/Dead Weight�t,3,30,http://www.hareruyamtg.com/jp/g/gSOI000106JN/,2016-05-16T21:01:24+09:00
sideboardCards,�s�����̉u�a/Virulent Plague�t,2,60,http://www.hareruyamtg.com/jp/g/gDTK000145JN/,2016-05-16T21:01:28+09:00
sideboardCards,�s��@�̕��/Orbs of Warding�t,1,60,http://www.hareruyamtg.com/jp/g/gORI000234JN/,2016-05-16T21:01:30+09:00

=end


rescue => e
	puts_write(e,@log)
end


@log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."


