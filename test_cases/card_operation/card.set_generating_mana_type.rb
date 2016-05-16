
#ruby
require '../../lib/util/deck.rb'

=begin
card = Card.new("Plains")
card.read_contents()
card.set_generating_mana_type()
card.print_contents()
if !File.exist?("../../cards/" + card.name.to_s) then
	card.write_contents()
end
=end

card = Card.new("Caves of Koilos")
card.read_contents()
card.set_generating_mana_type()
#card.print_contents()
#if !File.exist?("../../cards/" + card.name.to_s) then
#	card.write_contents()
#end

=begin
card = Card.new("Westvale Abbey")
card.read_contents()
card.set_generating_mana_type()
card.print_contents()
if !File.exist?("../../cards/" + card.name.to_s) then
	card.write_contents()
end
=end
