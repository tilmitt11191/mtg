
#ruby

require "logger"
require '../../lib/util/utils.rb'
require '../../lib/util/store.rb'
require '../../lib/util/card.rb'

puts File.basename(__FILE__).to_s + " start."
@log = Logger.new("../../log", 5, 10 * 1024 * 1024)
@log.info ""
@log.info File.basename(__FILE__).to_s + " start."
@log.info ""

@store = Mtgotraders.new(@log)

def url_check(name, url)
	card = Card.new(name.to_s, @log)
	@store.set_store_page_of(card)
	if card.store_url == url then
		puts "[ok]" + name.to_s
		@log.info "[ok]" + name.to_s
	else
		puts "[ng]" + name.to_s + ".store_url = " + card.store_url.to_s
		@log.error "[ng]" + name.to_s + ".store_url = " + card.store_url.to_s
	end
end



begin
	
	url_check("Kalitas, Traitor of Ghet", "http://www.mtgotraders.com/store/OGW_Kalitas_Traitor_of_Ghet.html")
	url_check("Dispel", "http://www.mtgotraders.com/store/WWK_Dispel.html")
	url_check("Forest", "http://www.mtgotraders.com/store/ICE_Forest_381.html")
	url_check("Wastes", "http://www.mtgotraders.com/store/OGW_Wastes_184.html")
	url_check("Exquisite Firecraft", "http://www.mtgotraders.com/store/ORI_Exquisite_Firecraft.html")
	url_check("Hedron Crawler", "http://www.mtgotraders.com/store/OGW_Hedron_Crawler.html")
	url_check("Make a Stand", "http://www.mtgotraders.com/store/OGW_Make_a_Stand.html")
	url_check("Void Shatter", "http://www.mtgotraders.com/store/OGW_Void_Shatter.html")
	url_check("Insolent Neonate", "http://www.mtgotraders.com/store/SOI_Insolent_Neonate.html")

rescue => e
	puts_write(e,@log)
end


@log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."
