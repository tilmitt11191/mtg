
#ruby
require "logger"
require '../util/card.rb'

log = Logger.new("../../log", 5, 10 * 1024 * 1024)
log.info "get_contents_of_card.rb start"

cardname = ARGV[0]

card = Card.new(cardname)
card.read_contents()
card.set_generating_mana_type()
card.print_contents()
if !File.exist?("../../cards/" + card.name.to_s) then
	card.write_contents()
end

