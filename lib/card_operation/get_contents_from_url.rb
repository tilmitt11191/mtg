
#ruby

require "logger"
require '../../lib/util/card.rb'

@log = Logger.new("../../log", 5, 10 * 1024 * 1024)
@log.info "card.read_from_url.rb start"

#execptions
cardnames = ["Game Trail", "Dispel", "Wastes"]

cardnames.each do |cardname|
	card = Card.new(cardname)
	if File.exist?("../../cards/" + cardname.to_s) then
		#read local file
		@log.debug cardname.to_s + ".read_from_dom()"
		card.read_from_dom()
	else
		#get contents of card from "http://whisper.wisdom-guild.net/"
		@log.debug cardname.to_s + ".read_from_url"
		card.read_from_url("http://whisper.wisdom-guild.net/card/" + cardname.to_s + "/")
	end
	card.print_contents()
	card.write_contents()
end
@log.info "read_from_url exceptions finished."

#basic lands
cardnames = ["Plains", "Island", "Swamp", "Mountain", "Forest"]

cardnames.each do |cardname|
	card = Card.new(cardname)
	if File.exist?("../../cards/" + cardname.to_s) then
		#read local file
		@log.debug cardname.to_s + ".read_from_dom()"
		card.read_from_dom()
	else
		#get contents of card from "http://whisper.wisdom-guild.net/"
		@log.debug cardname.to_s + ".read_from_url"
		card.read_from_url("http://whisper.wisdom-guild.net/card/" + cardname.to_s + "/")
	end
	card.print_contents()
	card.write_contents()
@log.info "read_from_url basic lands finished."
end