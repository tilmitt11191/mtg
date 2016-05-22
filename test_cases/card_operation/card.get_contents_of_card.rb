
#ruby

#TODO: create test using diff?

require "logger"
require '../../lib/util/utils.rb'
require '../../lib/util/card.rb'

begin
	puts File.basename(__FILE__).to_s + " start."
	log = Logger.new("../../log", 5, 10 * 1024 * 1024)
	log.info ""
	log.info File.basename(__FILE__).to_s + " start."
	log.info ""


	log = Logger.new("../../log", 5, 10 * 1024 * 1024)
	log.info "get_contents_of_card.rb start"


=begin
	kalitas = Card.new("Kalitas, Traitor of Ghet")
	kalitas.read_from_web()
	kalitas.read_contents()
	kalitas.print_contents()
	if !File.exist?("../../cards/" + kalitas.name.to_s) then
		kalitas.write_contents()
	end


	kozilek = Card.new("Kozilek, the Great Distortion")
	kozilek.read_contents()
	kozilek.print_contents()
	if !File.exist?("../../cards/" + kozilek.name.to_s) then
		kozilek.write_contents()
	end


	westvale = Card.new("Westvale Abbey")
	westvale.read_contents()
	westvale.print_contents()
	if !File.exist?("../../cards/" + westvale.name.to_s) then
		westvale.write_contents()
	end


	card = Card.new("Plains")
	card.read_contents()
	card.set_generating_mana_type()
	card.print_contents()
	if !File.exist?("../../cards/" + card.name.to_s) then
		card.write_contents()
	end


	card = Card.new("Caves of Koilos")
	card.read_contents()
	card.set_generating_mana_type()
	card.print_contents()
	if !File.exist?("../../cards/" + card.name.to_s) then
		card.write_contents()
	end


	card = Card.new("Westvale Abbey")
	card.read_contents()
	card.set_generating_mana_type()
	card.print_contents()
	if !File.exist?("../../cards/" + card.name.to_s) then
		card.write_contents()
	end

	card = Card.new("Opulent Palace")
	card.read_contents()
	card.set_generating_mana_type()
	card.print_contents()
	if !File.exist?("../../cards/" + card.name.to_s) then
		card.write_contents()
	end
=end


	##occured exception
=begin
	/media/sf_f/program/mtg/lib/util/card.rb:80:in `read_from_dom': undefined method `elements' for nil:NilClass #(NoMethodError)
		from /media/sf_f/program/mtg/lib/util/card.rb:50:in `read_contents'
		from /media/sf_f/program/mtg/lib/util/deck.rb:296:in `block in get_contents'
		from /media/sf_f/program/mtg/lib/util/deck.rb:295:in `each'
		from /media/sf_f/program/mtg/lib/util/deck.rb:295:in `get_contents'
		from get_hareruya_decks.rb:72:in `create_deckfile'
		from get_hareruya_decks.rb:106:in `block in <main>'
		from get_hareruya_decks.rb:106:in `each'
		from get_hareruya_decks.rb:106:in `<main>'

	I, [2016-05-16T19:34:37.227136 #12505]  INFO -- : Infinite Obliteration.read_from_dom() start
	I, [2016-05-16T19:34:37.238327 #12505]  INFO -- : @name.to_s + read_from_dom() finished
	I, [2016-05-16T19:34:37.239368 #12505]  INFO -- : Dead Weight.read_from_dom() start
=end
	card = Card.new("Dead Weight", log)
	card.read_contents()
	card.set_generating_mana_type()
	card.print_contents()
	if !File.exist?("../../cards/" + card.name.to_s) then
		card.write_contents()
	end
	
rescue => e
	puts_write(e,log)
end


log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."
