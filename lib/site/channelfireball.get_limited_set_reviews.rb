# encoding: UTF-8

require "logger"
require '../../lib/site/Channelfireball.rb'

begin
	puts File.basename(__FILE__).to_s + " start."
	@log = Logger.new("../../log")
	@log.info ""
	@log.info File.basename(__FILE__).to_s + " start."
	@log.info ""
	
	
	packname='EldritchMoom'
	short='EMN'
	outputfile = File.open("../../decks/channelfireball_reviews_#{short}.csv", "w:utf_8", :invalid => :replace, :undef => :replace, :replace => '?')
	
	urls=[]
	urls.push "http://www.channelfireball.com/articles/eldritch-moon-limited-set-review-colorless-lands-and-gold/"


	site = Channelfireball.new(@log)
	site.get_limited_set_reviews(outputfile, urls)
	outputfile.close
	
=begin
	store = Mtgotraders.new(@log)
	
	score = 10.0
	card = site.get_card_from_url("http://whisper.wisdom-guild.net/card/EMA057/")
	cardname_eng = card.name.split('/')[1]
	cardname_jp = card.name.split('/')[0]
	card.name = cardname_eng
	oracle = card.oracle.gsub(/\n/,"")
	
	store.set_store_page_of(card)
	price_manager = Price_manager.new(card, @log)
	store.get_prices(price_manager)
	puts "price=#{price_manager.relevant_price}"
	
	puts score
	puts cardname_eng
	puts cardname_jp	
	puts card.rarity
	puts card.manacost
	puts card.manacost_point
	puts card.type
	puts card.powertoughness
	puts card.illustrator
	puts card.cardset
	puts card.generating_mana_type

	File.open("pointranking_list_of_ETERNALMASTERS.csv", "w:Shift_JIS:UTF-8", undef: :replace, replace: '*') do |file|
		file.puts "#{score},#{price_manager.relevant_price},\"#{cardname_eng}\",\"#{cardname_jp}\",#{card.rarity},#{card.manacost},#{card.manacost_point},#{card.type},=\"#{card.powertoughness}\",#{card.illustrator},#{card.cardset},#{card.generating_mana_type},\"#{oracle}\""
	end
=end
rescue => e
		puts_write(e,@log)
end


@log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."
