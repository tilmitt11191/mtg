
#ruby

require "logger"
require '../../lib/util/card.rb'

log = Logger.new("../../log", 5, 10 * 1024 * 1024)
log.info "card.read_from_url.rb start"

card = Card.new("Game Trail")
card.read_from_url("http://whisper.wisdom-guild.net/card/Game%20Trail/")
card.set_generating_mana_type()
card.print_contents()
card.write_contents()


=begin
##basic lands
card = Card.new("Plains")
card.read_from_url("http://whisper.wisdom-guild.net/card/Plains/")
card.set_generating_mana_type()
card.print_contents()
card.write_contents()

card = Card.new("Island")
card.read_from_url("http://whisper.wisdom-guild.net/card/Island/")
card.set_generating_mana_type()
card.print_contents()
card.write_contents()

card = Card.new("Swamp")
card.read_from_url("http://whisper.wisdom-guild.net/card/Swamp/")
card.set_generating_mana_type()
card.print_contents()
card.write_contents()

card = Card.new("Mountain")
card.read_from_url("http://whisper.wisdom-guild.net/card/Mountain/")
card.set_generating_mana_type()
card.print_contents()
card.write_contents()

card = Card.new("Forest")
card.read_from_url("http://whisper.wisdom-guild.net/card/Forest/")
card.set_generating_mana_type()
card.print_contents()
card.write_contents()
=end