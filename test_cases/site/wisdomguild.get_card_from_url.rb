

require "logger"
require '../../lib/util/store.rb'
require '../../lib/util/card.rb'

begin
	puts File.basename(__FILE__).to_s + " start."
	@log = Logger.new("../../log")
	@log.info ""
	@log.info File.basename(__FILE__).to_s + " start."
	@log.info ""
	
	@site = WisdomGuild.new(@log)
	card = @site.get_card_from_url("http://whisper.wisdom-guild.net/card/EMA057/")
	
	
rescue => e
		puts_write(e,@log)
end


@log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."
