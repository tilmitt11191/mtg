
#ruby

require "logger"
require '../../lib/util/utils.rb'
require '../../lib/util/store.rb'
require '../../lib/util/card.rb'
require '../../lib/util/price_manager.rb'


puts File.basename(__FILE__).to_s + " start."
log = Logger.new("../../log", 5, 10 * 1024 * 1024)
log.info ""
log.info File.basename(__FILE__).to_s + " start."
log.info ""


begin
	store = Mtgotraders.new(log)
	card = Card.new("Jace, Unraveler of Secrets", log)
	price_manager = Price_manager.new(card, log)
	
	store.get_prices(price_manager, relevant:false, highest:false, lowest:false)
	if (price_manager.relevant_price == 0) && \
		(price_manager.highest_price == 0) && \
			(price_manager.lowest_price == 0) then
		puts "[ok]all false check."
	else
		puts "[ng]all false check.relevant[" + price_manager.relevant_price.to_s + \
			"], highest[" + price_manager.highest_price.to_s + \
				"], lowest[" + price_manager.lowest_price.to_s + "]"
	end
	
	store.get_prices(price_manager, relevant:true, highest:true, lowest:true)
	if (price_manager.relevant_price.to_i > 0) && \
		(price_manager.highest_price.to_i > 0) then
			(price_manager.lowest_price.to_i > 0)
		puts "[ok]all true check."
	else
		puts "[ng]all false check.relevant[" + price_manager.relevant_price.to_s + \
			"], highest[" + price_manager.highest_price.to_s + \
				"], lowest[" + price_manager.lowest_price.to_s + "]"
	end

rescue => e
	puts_write(e,log)
end


log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."
