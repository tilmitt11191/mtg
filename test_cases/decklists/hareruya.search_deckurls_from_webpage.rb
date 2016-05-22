
#ruby
require "logger"
require '../../lib/util/utils.rb'
require '../../lib/util/deck.rb'
require '../../lib/util/store.rb'

#get url of each deck at
#http://www.hareruyamtg.com/jp/deck/search.aspx?name_je_type=1&search.x=submit&date_format=Standard+-+DTK_SOI&format=Standard&ps=50&p=2&releasedt_type=1
# and
#http://www.hareruyamtg.com/jp/deck/search.aspx?name_je_type=1&search.x=submit&date_format=Standard+-+DTK_SOI&format=Standard&ps=50&p=1&releasedt_type=1
# and so on.

begin
	puts File.basename(__FILE__).to_s + " start."
	log = Logger.new("../../log", 5, 10 * 1024 * 1024)
	log.info ""
	log.info File.basename(__FILE__).to_s + " start."
	log.info ""


	hareruya = Hareruya.new(log)
	num = 60
	deck_urls = hareruya.search_deckurls_from_webpage(num)
	i = 1
	deck_urls.each do |url|
		log.debug "[" + i.to_s + "]" + url.to_s
		i+=1
	end

	if deck_urls.size() == num then
		puts "[ok]hareruya.search_deckurls_from_webpage.size() = " + num.to_s
	else
		puts "[ng]hareruya.search_deckurls_from_webpage.size() = " + num.to_s
		log.error "[ng]hareruya.search_deckurls_from_webpage.size = " + deck_urls.size.to_s + "!=" + num.to_s
	end


rescue => e
	puts_write(e,log)
end


log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."

