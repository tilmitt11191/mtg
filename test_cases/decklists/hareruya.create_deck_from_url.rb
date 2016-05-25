
#ruby
require "logger"

require '../../lib/util/deck.rb'
require '../../lib/util/store.rb'

begin
	puts File.basename(__FILE__).to_s + " start."
	@log = Logger.new("../../log", 5, 10 * 1024 * 1024)
	@log.info ""
	@log.info File.basename(__FILE__).to_s + " start."
	@log.info ""
	


hareruya = Hareruya.new(@log)
url = "http://www.hareruyamtg.com/jp/k/kD08241S/"
mode = "price:off,file:on"
deck = hareruya.create_deck_from_url(url,priceflag:false,fileflag:true)

num = 0
deck.cards.each do |card|
	num += card.quantity.to_i
end

if num == 75 then
	puts "[ok]hareruya.create_deck_from_url"
else
	puts "[error]hareruya.create_deck_from_url deck.cards num = " + num.to_s
end


rescue => e
	puts_write(e,@log)
end


@log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."

