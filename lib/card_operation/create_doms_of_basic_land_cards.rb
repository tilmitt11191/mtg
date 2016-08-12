# encoding: UTF-8
#ruby

require '../../lib/util/utils.rb'
require '../../lib/util/deck.rb'
require '../../lib/site/wisdomGuild.rb'
require '../../lib/site/mtgotraders.rb'

begin
	puts File.basename(__FILE__).to_s + " start."
	@log = Logger.new("../../log")
	@log.info ""
	@log.info File.basename(__FILE__).to_s + " start."
	@log.info ""
	
	lands = [Plains,Island,Swamp,Mountain,Forest]
	generating_manas = {}
	generating_manas[Plains] = 'W'
	generating_manas[] = ''
	generating_manas[] = ''
	generating_manas[] = ''
	generating_manas[] = ''
	
	
rescue => e
	write_error_to_log(e,@log)
end


@log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."
