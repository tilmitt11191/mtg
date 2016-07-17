

require	"logger"
require 'open-uri'
require 'nokogiri'
require '../../lib/util/site.rb'
require '../../lib/util/store.rb'
require '../../lib/util/card.rb'
require '../../lib/util/price_manager.rb'

class SMDS < Site
	
	def initialize(logger)
		super("SMDS", logger)
		@url = "http://syunakira.com/smd/"
	end
	
	def create_pointranking_list_of(packname, short)
		@log.info "SMDS.create_pointranking_list_of(#{packname}) start."
		url = "http://syunakira.com/smd/pointranking/index.php?packname=#{packname}&language=Japanese"

		html_row_data = open(url)
		#File.open("url.html", "w") do |file|
		#	file.write html_row_data.read
		#end
		
		#get cardname by id from wisdomguild.
		site = WisdomGuild.new(@log)
		store = Mtgotraders.new(@log)

		html_nokogiri = Nokogiri::HTML.parse(html_row_data, nil, @charset)
		File.open("../../data_for_analysis/pointranking_list_of_#{packname}.csv", "w:Shift_JIS:UTF-8", undef: :replace, replace: '*') do |file|
			if html_nokogiri.css('td/center').nil? then
				puts "nil"
			else
			html_nokogiri.css('td/center').each do |element|
				if /[0-9]/ =~ element.inner_text
					score = element.inner_text
					number = sprintf("%03d", element.css('img').attribute('id').to_s)
					@log.debug "site.get_card_from_url(http://whisper.wisdom-guild.net/card/#{short}#{(number)}/)"
					card = site.get_card_from_url("http://whisper.wisdom-guild.net/card/#{short}#{(number)}/")
					if !card.nil? then
						cardname_eng = card.name.split('/')[1]
						cardname_jp = card.name.split('/')[0]
						
						card.name = cardname_eng
						oracle = card.oracle.gsub(/\n/,"") if !card.oracle.nil?
						
						store.set_store_page_of(card)
						price_manager = Price_manager.new(card, @log)
						store.get_prices(price_manager)
	
					
						puts score
						puts price_manager.relevant_price
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

						file.puts "#{score},#{price_manager.relevant_price},\"#{cardname_eng}\",\"#{cardname_jp}\",#{card.rarity},#{card.manacost},#{card.manacost_point},#{card.type},=\"#{card.powertoughness}\",#{card.illustrator},#{card.cardset},#{card.generating_mana_type},\"#{oracle}\""
					end
				end
			end
			end
		end

		@log.info "SMDS.create_pointranking_list_of(#{packname}) finished."
	end

end