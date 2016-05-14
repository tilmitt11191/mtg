
#ruby

require "logger"
require '../util/card.rb'

log = Logger.new("../log", 5, 10 * 1024 * 1024)
log.info "get_contents_of_unsearchable_cards.rb start"

list = ["Mountain","Forest"]
list.each do |name|
	card = Card.new(name)
	card.read_from_url("http://whisper.wisdom-guild.net/card/" + name)
	card.print_contents()
	card.write_contents()
end


