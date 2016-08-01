# encoding: UTF-8

require 'logger'
require '../../lib/site/Channelfireball.rb'

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
	
	outputfilename = "../../decks/channelfireball_reviews_#{short}.csv"
	
	urls=[]
	['white', 'blue', 'black', 'red', 'green', 'colorless-lands-and-gold'].each do |color|
	#['white'].each do |color|
		case packname
		when 'Shadows over Innistrad' then
			urls.push "http://www.channelfireball.com/articles/shadows-over-innistrad-limited-set-review-#{color}/"
		when 'Eldritch Moom' then
			urls.push "http://www.channelfireball.com/articles/eldritch-moon-limited-set-review-#{color}/"
		end
	end


	site = Channelfireball.new(@log)
	site.get_limited_set_reviews(outputfilename, urls)
	
rescue => e
		puts_write(e,@log)
end


@log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."
