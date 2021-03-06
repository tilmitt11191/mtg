
#ruby
require "logger"

require '../../lib/util/deck.rb'
require '../../lib/util/store.rb'

puts File.basename(__FILE__).to_s + " start."
@log = Logger.new("../../log_create_num_of_latest_decks", 5, 10 * 1024 * 1024)
@log.info ""
@log.info File.basename(__FILE__).to_s + " start."
@log.info ""

@log.level = Logger::DEBUG

hareruya = Hareruya.new(@log)
#deck(737)[GW_Aggro_kD08824S] had been created.

from = 1
to = 10
deck_urls = hareruya.search_deckurls_from_webpage(to)
i = 1
deck_urls.each do |url|
	if(i >= from) then
		@log.debug "[" + i.to_s + "]" + url.to_s
		deck = hareruya.create_deck_from_url(url,priceflag:"on",fileflag:"on")
		
		@log.debug "deck(" + i.to_s + ")[" + deck.deckname.to_s + "] had been created."
		puts "deck(" + i.to_s + ")[" + deck.deckname.to_s + "] had been created."
	end
	i+=1
end

@log.info File.basename(__FILE__).to_s + " finished."
