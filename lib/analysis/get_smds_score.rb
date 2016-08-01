# encoding: UTF-8
#ruby

require "logger"
require '../../lib/site/smds.rb'

begin
	puts File.basename(__FILE__).to_s + " start."
	@log = Logger.new("../../log")
	@log.info ""
	@log.info File.basename(__FILE__).to_s + " start."
	@log.info ""
	
	#packname='Eldritch Moom'
	#short='EMN'
	packname='Shadows over Innistrad'
	short='SOI'
	
	outputfilename = "../../decks/smdb_pointranking_list_of_#{short}.csv"
	case packname
	when 'Shadows over Innistrad' then
		url = 'http://syunakira.com/smd/pointranking/index.php?packname=UnravelTheMadness&language=Japanese'
	when 'Eldritch Moom' then
		url = 'http://syunakira.com/smd/pointranking/index.php?packname=EldritchMoom&language=Japanese'
	end

	site = SMDS.new(@log)
	site.create_pointranking_list outputfilename, url, short

	@log.info File.basename(__FILE__).to_s + " finished."
	puts File.basename(__FILE__).to_s + " finished."
rescue => e
	puts_write(e,@log)
end




