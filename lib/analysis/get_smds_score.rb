
#ruby
require "logger"

require '../../lib/site/smds.rb'

begin
	puts File.basename(__FILE__).to_s + " start."
	@log = Logger.new("../../log")
	@log.info ""
	@log.info File.basename(__FILE__).to_s + " start."
	@log.info ""
	
	packname='EldritchMoom'
	short='EMN'
	store = SMDS.new(@log)
	store.create_pointranking_list_of(packname, short)

	@log.info File.basename(__FILE__).to_s + " finished."
	puts File.basename(__FILE__).to_s + " finished."
rescue => e
	puts_write(e,@log)
end




