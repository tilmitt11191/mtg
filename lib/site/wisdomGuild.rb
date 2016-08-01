# encoding: UTF-8
#ruby
require '../../lib/util/utils.rb'
require '../../lib/util/site.rb'
require '../../lib/util/card.rb'


class WisdomGuild < Site
	def initialize(logger)
		super("WisdomGuild", logger)
		@url = "http://www.wisdom-guild.net/"
	end
	
	def how_match?(card)
		@log.debug "how match ["+card.name+"] at wisdomGuild"
		@card_name = card.name
		@log.debug "url is [" + card.store_url.to_s + "]"
		if card.store_url.nil? then
			@log.error "card.store_url is nil at wisdomGuild.how_match?"
			@log.error "return nil"
			return nil		
		elsif !card.store_url.include?("http://whisper.wisdom-guild.net/") then
			@log.error "invalid card.store_url[" + card.store_url.to_s + "]"
			@log.error "return nil"
			return nil
		end
		card.price.value = 0
		#read_cardpage(card.store_url)
		#price = @card_nokogiri.css('span.sell_price').text
		#price.gsub!(/\s|\n|￥|,/,"")
		#card.price.value = price
		#@log.debug "price is " + price
		return card.price
	end
	
	def extract_english_of cardname
		cardname.split('/')[1]
	end

	
	
	def get_card_from_url(url)
		@log.debug "get_cardname_from_url(#{url}) start."
		card = Card.new("",@log)
		agent = Mechanize.new
		card_page = agent.get(url)
		
		#check card.exist?
		if card_page.search('div[@class="error owl-prompt"]').inner_text.include?('ご指定のカードは見つかりませんでした。') then
			@log.warn "get_cardname_from_url(#{url}) finished. card not found. return nil."
			return nil
		end
		
		card_page.search('tr').each do |tr|
			if(tr.search('th.dc').text == "カード名") then
				@log.debug "extract card name start."
				str = extract_english_of tr.search('b').text
				@log.debug str
				card.name = str
			end
			if(tr.search('th.dc').text == "マナコスト") then
				@log.debug "extract mana cost start."
				str = tr.search('td.lc').text
				@log.debug str
				card.extract_manacost(str)
			end
			if(tr.search('th.dc').text == "タイプ") then
				@log.debug "extract card type start."
				str = tr.search('td.mc').text
				@log.debug str
				card.extract_type(str)
			end
			if(tr.search('th.dc').text == "オラクル") then
				@log.debug "extract oracle start."
				str = tr.search('td.lc').text
				@log.debug str
				card.extract_oracle(str)
			end
			if(tr.search('th.dc').text == "Ｐ／Ｔ") then
				@log.debug "extract power/toughness start."
				str = tr.search('td.lc').text
				@log.debug str
				card.extract_powertoughness(str)
			end
			if(tr.search('th.dc').text == "イラスト") then
				@log.debug "extract illustrator start."
				str = tr.search('td.lc').text
				@log.debug str
				card.extract_illustrator(str)
			end
			if(tr.search('th.dc').text == "セット等") then
				@log.debug "extract rarity, card set start."
				str = tr.search('td.mc').text
				@log.debug str
				card.extract_rarity_and_cardset(str)
			end
		end
		@log.debug "get_cardname_from_url(#{url}) finished."
		return card
	end
	
	def get_card_by_cardname cardname
		card = Card.new(cardname, @log)
		card.read_from_web
		return card
	end
end
