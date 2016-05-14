
#ruby

require "logger"
require '../util/card.rb'

log = Logger.new("../log", 5, 10 * 1024 * 1024)
log.info "get_contents_of_card.rb start"

#kalitas = Card.new("Kalitas, Traitor of Ghet")
#kalitas.read_from_web()
#kalitas.read_contents()
#kalitas.print_contents()
#if !File.exist?("../../cards/" + kalitas.name.to_s) then
#	kalitas.write_contents()
#end


#kozilek = Card.new("Kozilek, the Great Distortion")
#kozilek.read_contents()
#kozilek.print_contents()
#if !File.exist?("../../cards/" + kozilek.name.to_s) then
#	kozilek.write_contents()
#end

#westvale = Card.new("Westvale Abbey")
#westvale.read_contents()
#westvale.print_contents()
#if !File.exist?("../../cards/" + westvale.name.to_s) then
#	westvale.write_contents()
#end

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

