

require	"logger"
require 'open-uri'
require 'nokogiri'
require '../../lib/util/utils.rb'
require '../../lib/util/site.rb'
require '../../lib/util/deck.rb'

class Channelfireball < Site

	#for get_limited_set_reviews
	@cardnames
	@scores
	@comments
	attr_accessor :cardnames, :scores, :comments
	
	def initialize(logger)
		super("Channelfireball", logger)
		@url = "http://www.channelfireball.com/articles/"

		@cardnames = []
		@scores = {}
		@comments = {}
	end
	
	def get_limited_set_reviews(outputfile,urls)
		@log.info "#{__method__} start."
		urls.each do |url|
			html = @web.get_dom_of(url, @log)
			#@web.output_html_src_to('../../test_cases/workspace/output/src.html', @log)
			extract_cardnames_from html
			remove_invalid_cards
			extract_scores_and_comments_from html
		end
	end
	
	def extract_cardnames_from(html)
		@log.info "#{__method__} start."
		html.css('h1').each do |element|
			@log.debug "cardname[#{element.inner_text}]"
			@cardnames.push element.inner_text
		end
	end
	
	def remove_invalid_cards
		@log.info "#{__method__} start."
		if @cardnames.nil? then
			@log.warn '@cardnames is nil'
			return false
		end

		@cardnames.reject!{|cardname| /(Limited Set Review|Ratings Scale|Top 5)/=~ cardname}
	end
	
	def extract_scores_and_comments_from(html)
		@cardnames.each do |cardname|
			puts cardname
		end
		html.xpath('/').each do |line|
			##
		end
	end


	
	def get_decklist_from_article(url)
		@log.info "channelfireball.get_decklist_from_article start."
		@log.info "url[#{url}]"
		
		if !url_exists?(url, @log) then
			@log.error "url[#{url}] not exist."
			@log.error "channelfireball.get_decklist_from_article finished."
			return nil
		end
		
		html_row_data = open(url)
		html_nokogiri = Nokogiri::HTML.parse(html_row_data, nil, @charset)
		puts html_nokogiri.css('div').attribute('crystal-catalog-helper-sublist').to_s
		
=begin	
		html_row_data = open(url)
		File.open("url.html", "w") do |file|
			file.write html_row_data.read
		end
		#get cardname by id from wisdomguild.
		site = WisdomGuild.new(@log)
		store = Mtgotraders.new(@log)

		html_nokogiri = Nokogiri::HTML.parse(html_row_data, nil, @charset)
		File.open("pointranking_list_of_#{packname}.csv", "w:Shift_JIS:UTF-8", undef: :replace, replace: '*') do |file|
			html_nokogiri.css('td/center').each do |element|
				if /[0-9]/ =~ element.inner_text
					score = element.inner_text
					number = sprintf("%03d", element.css('img').attribute('id').to_s)
					card = site.get_card_from_url("http://whisper.wisdom-guild.net/card/EMA#{(number)}/")
					oracle = card.oracle.gsub(/\n/,"")
					
					cardname_eng = card.name.split('/')[1]
					cardname_jp = card.name.split('/')[0]
					card.name = cardname_eng
					oracle = card.oracle.gsub(/\n/,"")
					
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

		@log.info "SMDS.create_pointranking_list_of(#{packname}) finished."
=end
	end
end