
#ruby
#TODO: create test using diff?

require "logger"
require '../../lib/util/card.rb'

puts File.basename(__FILE__).to_s + " start."
log = Logger.new("../../log", 5, 10 * 1024 * 1024)
log.info ""
log.info File.basename(__FILE__).to_s + " start."
log.info ""

begin

#execptions
cardnames = []
#cardnames.push("Plains")
#cardnames.push("Island")
#cardnames.push("Swamp")
#cardnames.push("Mountain")
#cardnames.push("Forest")
#cardnames.push("Wastes")

#cardnames.push("Exquisite Firecraft")
#cardnames.push("Hedron Crawler")
#cardnames.push("Make a Stand")
#cardnames.push("Void Shatter")
#cardnames.push("Spawning Bed")
#cardnames.push("Insolent Neonate")
#cardnames.push("Eldrazi Displacer")
cardnames.push("Twin Bolt")

cardnames.each do |cardname|
	card = Card.new(cardname,log)
	if File.exist?("../../cards/" + cardname.to_s) then
		#read local file
		log.debug cardname.to_s + ".read_from_dom()"
		card.read_from_dom()
	else
		#get contents of card from "http://whisper.wisdom-guild.net/"
		log.debug cardname.to_s + ".read_from_url"
		card.read_from_url("http://whisper.wisdom-guild.net/card/" + cardname.to_s + "/")
	end
	card.print_contents()
	card.write_contents() #default dir
end
log.info "read_from_url exceptions finished."


rescue => e
	puts_write(e,log)
end


log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."
