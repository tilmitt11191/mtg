

require "logger"
require '../../lib/util/site.rb'
require '../../lib/util/card.rb'
require '../../lib/util/price_manager.rb'
require '../../lib/site/Channelfireball.rb'

begin
	puts File.basename(__FILE__).to_s + " start."
	@log = Logger.new("../../log")
	@log.info ""
	@log.info File.basename(__FILE__).to_s + " start."
	@log.info ""
	
	url = "http://www.channelfireball.com/articles/bant-humans-deck-guide-2/"

	#html_row_data = open(url)
	#File.open("url.html", "w") do |file|
	#	file.write html_row_data.read
	#end
	
	#get cardname by id from wisdomguild.
	site = Channelfireball.new(@log)
	deck = site.get_decklist_from_article(url)
	
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
