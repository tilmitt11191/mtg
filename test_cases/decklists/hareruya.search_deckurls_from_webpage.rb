
#ruby
require "logger"

require '../../lib/util/deck.rb'
require '../../lib/util/store.rb'

puts File.basename(__FILE__).to_s + " start."
log = Logger.new("../../log", 5, 10 * 1024 * 1024)
log.info ""
log.info File.basename(__FILE__).to_s + " start."
log.info ""


hareruya = Hareruya.new()
num = 60
deck_urls = hareruya.search_deckurls_from_webpage(num)
i = 1
deck_urls.each do |url|
	log.debug "[" + i.to_s + "]" + url.to_s
	i+=1
end

if deck_urls.size() == num then
	puts "[ok]hareruya.search_deckurls_from_webpage.size()"
else
	puts "[ng]"


log.info File.basename(__FILE__).to_s + " finished."
