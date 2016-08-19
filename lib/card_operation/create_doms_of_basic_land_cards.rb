# encoding: UTF-8
#ruby

require '../../lib/util/utils.rb'
require '../../lib/util/card.rb'

begin
	puts File.basename(__FILE__).to_s + " start."
	@log = Logger.new("../../log")
	@log.info ""
	@log.info File.basename(__FILE__).to_s + " start."
	@log.info ""
	
	lands = ['Plains','Island','Swamp','Mountain','Forest']
	generating_manas = {}
	generating_manas['Plains'] = 'W'
	generating_manas['Island'] = 'U'
	generating_manas['Swamp'] = 'B'
	generating_manas['Mountain'] = 'R'
	generating_manas['Forest'] = 'G'
	
	lands.each do |land|
		card = Card.new(land, @log)
		card.generating_mana_type = generating_manas[land]
		card.write_contents
	end
	
	
rescue => e
	write_error_to_log(e,@log)
end


@log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."
