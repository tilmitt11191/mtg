
#ruby

require "logger"
require '../../lib/util/utils.rb'
require '../../lib/util/store.rb'
require '../../lib/util/card.rb'

begin
	puts File.basename(__FILE__).to_s + " start."
	log = Logger.new("../../log", 5, 10 * 1024 * 1024)
	log.info ""
	log.info File.basename(__FILE__).to_s + " start."
	log.info ""


	hareruya = Hareruya.new(log)
	card = Card.new("Kalitas, Traitor of Ghet", log)
	
	price = hareruya.how_match?(card)
	if price.nil? then
		puts "[ok]hareruya.how_match when url is nil"
	else
		puts "[ng]hareruya.how_match when url is nil"
		log.error "[ng]hareruya.how_match when url is nil"
	end
	
	card.set_store_page("http://www.")
	price = hareruya.how_match?(card)
	if price.nil? then
		puts "[ok]hareruya.how_match when url is invalid"
	else
		puts "[ng]hareruya.how_match when url is invalid"
		log.error "[ng]hareruya.how_match when url is invalid"
	end

	card.set_store_page("http://www.hareruyamtg.com/jp/g/gOGW000086JN/")
	price = hareruya.how_match?(card)
	if price.nil? then
		puts "[ng]hareruya.how_match. Kalitas, Traitor of Ghet.price = nil"
		log.error "[ng]hareruya.how_match. Kalitas, Traitor of Ghet.price = nil"
	elsif (price > 0) then
		puts "[ok]hareruya.how_match. Kalitas, Traitor of Ghet.price = " + card.price.to_s
	else
		puts "[ng]hareruya.how_match. Kalitas, Traitor of Ghet.price = " + card.price.to_s
		log.error "[ng]hareruya.how_match. Kalitas, Traitor of Ghet.price = " + card.price.to_s
	end

rescue => e
	puts_write(e,log)
end


log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."
