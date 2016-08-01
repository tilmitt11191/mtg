

require	"logger"
require 'open-uri'
require 'nokogiri'
require 'active_support/core_ext/object' #for blank?
require '../../lib/util/site.rb'
require '../../lib/site/wisdomGuild.rb'
require '../../lib/util/card.rb'
require '../../lib/util/price_manager.rb'

class SMDS < Site

	#for create_pointranking_list
	@database
	@cardnames
	@scores
	@cardnumbers
	attr_accessor :database, :cardnames, :scores, :cardnumbers
	#price_manager.relevant_price
	#cardname_jp
	#card.rarity
	#card.manacost
	#card.manacost_point
	#card.type
	#card.powertoughness
	#card.illustrator
	#card.cardset
	#card.generating_mana_type
	#oracle
	
	def initialize(logger)
		super("SMDS", logger)
		@url = "http://syunakira.com/smd/"
		
		@cardnames = []
		@scores = {}
		@cardnumbers = {}
	end
	
	def create_pointranking_list outputfilename, url, packname_short
		puts "#{__method__}(#{outputfilename}, #{url}) #{packname_short} start."
		@log.info "#{__method__}(#{outputfilename}, #{url}) #{packname_short} start."
		
		@database = WisdomGuild.new(@log)
		
		@html = @web.get_dom_of(url, @log)
		if @html.nil? then
			@log.fatal "url[#{url}] is incorrect."
			return false
		end
		#@web.output_html_src_to('src.html', @log)
		get_cardnames_and_scores packname_short
		output_cardnames_and_scores_to outputfilename
		@log.info "#{__method__} finished."
	end
	
	def get_cardnames_and_scores packname_short
		puts "#{__method__} start."
		@html.css('td/center').each do |element|
			if /[0-9]/ =~ element.inner_text
				score = element.inner_text.gsub(/\s|\n/,"")
				number = sprintf("%03d", element.css('img').attribute('id').to_s)
				cardname = get_cardname_by_number(number,packname_short)
				@log.debug "#{cardname}[#{number}#{packname_short}]=#{score}"
				add_to_array cardname, score, number
				puts "cardname[#{cardname}]. site.get_card_from_url(http://whisper.wisdom-guild.net/card/#{packname_short}#{(number)}/)"
			end
		end
	end
	
	def get_cardname_by_number(number, packname_short)
		@log.info "#{__method__} start."
		case packname_short
		when 'EMN' then
			url = "http://whisper.wisdom-guild.net/card/EMN#{number}"
		when 'SOI' then
			url = "http://whisper.wisdom-guild.net/card/SOI#{number}"
		end
		
		html = @web.get_dom_of(url, @log)
		if html.nil? then
			@log.fatal "url[#{url}] is incorrect."
			return false
		end
		card = @database.get_card_from_url url
		if card.nil? then
			@log.warn "the card of url[#{url}] not exist."
			return false
		end

		#card.name = card.name.split('/')[1]
		card.write_contents
		card.name
	end
	
	def output_cardnames_and_scores_to outputfilename
		@log.info "#{__method__}(#{outputfilename}) start."
		if outputfilename.blank? then
			@log.info "outputfilename is blank. not output."
			return false
		end
		outputfile = File.open(outputfilename, "w:Shift_JIS", :invalid => :replace, :undef => :replace, :replace => '?')
		@cardnames.each do |cardname|
			outputfile.puts "#{@cardnumbers[cardname]},\"#{cardname}\",#{@scores[cardname]}"
		end
		
		outputfile.close
	end
	
	def add_to_array cardname, score, number
		if cardname && !@cardnames.include?(cardname)
			@cardnames.push cardname
			@scores[cardname] = score
			@cardnumbers[cardname] = number
		end
	end
	
	def ____create_pointranking_list_of(packname, short)
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
					score = element.inner_text.gsub(/\s|\n/,"")
					number = sprintf("%03d", element.css('img').attribute('id').to_s)
					@log.debug "site.get_card_from_url(http://whisper.wisdom-guild.net/card/#{short}#{(number)}/)"
					card = site.get_card_from_url("http://whisper.wisdom-guild.net/card/#{short}#{(number)}/")
					if card.nil? then
						@log.fatal "card is nil from http://whisper.wisdom-guild.net/card/#{short}#{(number)}/"
					else
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