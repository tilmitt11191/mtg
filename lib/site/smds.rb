

require	"logger"
require 'open-uri'
require 'nokogiri'
require '../../lib/util/site.rb'
require '../../lib/util/store.rb'
require '../../lib/util/card.rb'

class SMDS < Site
	
	def initialize(logger)
		super("SMDS", logger)
		@url = "http://syunakira.com/smd/"
	end
	
	def create_pointranking_list_of(packname)
		@log.info "SMDS.create_pointranking_list_of(#{packname}) start."
		url = "http://syunakira.com/smd/pointranking/index.php?packname=#{packname}&language=Japanese"

		html_row_data = open(url)
		#File.open("url.html", "w") do |file|
		#	file.write html_row_data.read
		#end
		
		#get cardname by id from wisdomguild.
		store = WisdomGuild.new(@log)
		
		html_nokogiri = Nokogiri::HTML.parse(html_row_data, nil, @charset)
		File.open("pointranking_list_of_#{packname}.csv", "w:Shift_JIS:UTF-8", undef: :replace, replace: '*') do |file|
			html_nokogiri.css('td/center').each do |element|
				if /[0-9]/ =~ element.inner_text
					score = element.inner_text
					number = sprintf("%03d", element.css('img').attribute('id').to_s)
					card = store.get_card_from_url("http://whisper.wisdom-guild.net/card/EMA#{(number)}/")
					oracle = card.oracle.gsub(/\n/,"")
					
					puts score
					puts card.name
					puts card.rarity
					puts card.manacost
					puts card.manacost_point
					puts card.type
					puts card.powertoughness
					puts card.illustrator
					puts card.cardset
					puts card.generating_mana_type

					file.puts "#{score},\"#{card.name}\",#{card.rarity},#{card.manacost},#{card.manacost_point},#{card.type},#{card.powertoughness},#{card.illustrator},#{card.cardset},#{card.generating_mana_type},#{oracle}"
				end
			end
		end

		@log.info "SMDS.create_pointranking_list_of(#{packname}) finished."
	end

end