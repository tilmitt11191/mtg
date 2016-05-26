
#ruby
require "logger"
require '../../lib/util/card.rb'
require '../../lib/util/mana_analyzer.rb'

begin
	puts File.basename(__FILE__).to_s + " start."
	@log = Logger.new("../../log", 5, 10 * 1024 * 1024)
	@log.info ""
	@log.info File.basename(__FILE__).to_s + " start."
	@log.info ""

#set manually
cardnames = ["Evolving Wilds"]
cardnames.each do |cardname|
	card = Card.new(cardname, @log)
	card.read_contents()
	if card.generating_mana_type == "A" then
		puts "[ok]" + cardname.to_s
	else
		puts "[error]" + card.name.to_s + ".generating_mana_type = " + card.generating_mana_type.to_s
		card.print_contents()
	end
	if !File.exist?("../../cards/" + card.name.to_s) then
		card.write_contents()
	end
end


#exeption
#Drownyard Temple
#Loam Dryad <-not land
#Cryptolith Rite <-not land



#colorless land
cardnames = ["Drownyard Temple"]
cardnames.each do |cardname|
	card = Card.new(cardname, @log)
	card.read_contents()
	if card.generating_mana_type == "C" then
		puts cardname.to_s + "[ok]"
	else
		puts card.name.to_s + ".generating_mana_type = " + card.generating_mana_type.to_s
		card.print_contents()
	end
	if !File.exist?("../../cards/" + card.name.to_s) then
		card.write_contents()
	end
end


cardname = "Plains"
card = Card.new(cardname, @log)
card.read_contents()
card.set_generating_mana_type()
if card.generating_mana_type == "W" then
	puts "[ok]" + cardname.to_s
else
	puts "[error]" + card.name.to_s + ".generating_mana_type = " + card.generating_mana_type.to_s
	card.print_contents()
end
if !File.exist?("../../cards/" + card.name.to_s) then
	card.write_contents()
end

cardname = "Island"
card = Card.new(cardname, @log)
card.read_contents()
card.set_generating_mana_type()
if card.generating_mana_type == "U" then
	puts "[ok]" + cardname.to_s
else
	puts "[error]" + card.name.to_s + ".generating_mana_type = " + card.generating_mana_type.to_s
	card.print_contents()
end
if !File.exist?("../../cards/" + card.name.to_s) then
	card.write_contents()
end

cardname = "Swamp"
card = Card.new(cardname, @log)
card.read_contents()
card.set_generating_mana_type()
if card.generating_mana_type == "B" then
	puts "[ok]" + cardname.to_s
else
	puts "[error]" + card.name.to_s + ".generating_mana_type = " + card.generating_mana_type.to_s
	card.print_contents()
end
if !File.exist?("../../cards/" + card.name.to_s) then
	card.write_contents()
end

cardname = "Mountain"
card = Card.new(cardname, @log)
card.read_contents()
card.set_generating_mana_type()
if card.generating_mana_type == "R" then
	puts "[ok]" + cardname.to_s
else
	puts "[error]" + card.name.to_s + ".generating_mana_type = " + card.generating_mana_type.to_s
	card.print_contents()
end
if !File.exist?("../../cards/" + card.name.to_s) then
	card.write_contents()
end

cardname = "Forest"
card = Card.new(cardname, @log)
card.read_contents()
card.set_generating_mana_type()
if card.generating_mana_type == "G" then
	puts "[ok]" + cardname.to_s
else
	puts "[error]" + card.name.to_s + ".generating_mana_type = " + card.generating_mana_type.to_s
	card.print_contents()
end
if !File.exist?("../../cards/" + card.name.to_s) then
	card.write_contents()
end

rescue => e
	puts_write(e,@log)
end


@log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."



