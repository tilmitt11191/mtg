# encoding: UTF-8

require "logger"
require '../../lib/util/site.rb'
require '../../lib/util/card.rb'
require '../../lib/util/price_manager.rb'
require '../../lib/site/wisdomGuild.rb'

begin
	puts File.basename(__FILE__).to_s + " start."
	@log = Logger.new("../../log")
	@log.info ""
	@log.info File.basename(__FILE__).to_s + " start."
	@log.info ""
	
	packname='EldritchMoom'
	short='EMN'
	url = "http://syunakira.com/smd/pointranking/index.php?packname=#{packname}&language=Japanese"
	
	html_row_data = open(url)
	html_nokogiri = Nokogiri::HTML.parse(html_row_data, nil, @charset)
	if html_nokogiri.css('td/center').nil? then
		puts "nil"
	else
		html_nokogiri.css('td/center').each do |element|
			if /[0-9]/ =~ element.inner_text
				score = element.inner_text.gsub(/\s|\n/,"")
				number = sprintf("%03d", element.css('img').attribute('id').to_s)
				puts "#{score}, #{number}"
				#puts "site.get_card_from_url(http://whisper.wisdom-guild.net/card/#{short}#{(number)}/)"
				@log.debug "site.get_card_from_url(http://whisper.wisdom-guild.net/card/#{short}#{(number)}/)"
			end
		end
	end
	
	
	#get cardname by id from wisdomguild.
	site = WisdomGuild.new(@log)
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

	File.open("test_pointranking_list_of_#{packname}.csv", "w:Shift_JIS:UTF-8", undef: :replace, replace: '*') do |file|
		file.puts "#{score},#{price_manager.relevant_price},\"#{cardname_eng}\",\"#{cardname_jp}\",#{card.rarity},#{card.manacost},#{card.manacost_point},#{card.type},=\"#{card.powertoughness}\",#{card.illustrator},#{card.cardset},#{card.generating_mana_type},\"#{oracle}\""
	end

	#####
		
	
	
	
rescue => e
		puts_write(e,@log)
end


@log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."
