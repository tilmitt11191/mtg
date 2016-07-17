
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
	store = WisdomGuild.new(log)


	url = 'http://whisper.wisdom-guild.net/card/EMN200/'
	card = store.get_card_from_url(url)
	if card.nil? then
		puts '[ng]card.nil'
	else
		puts "[ok]card is not nil.card.name[#{card.name}]"
	end

	url = 'http://whisper.wisdom-guild.net/card/EMN220/'
	card = store.get_card_from_url(url)
	if card.nil? then
		puts '[ok]card.nil'
	else
		puts "[ng]card is not nil.card.name[#{card.name}]"
	end

rescue => e
	puts_write(e,log)
end


log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."
