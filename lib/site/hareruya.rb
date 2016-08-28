# encoding: UTF-8
#ruby

require	'logger'
require 'active_support/core_ext/object' #for blank?
require 'open-uri'
require 'nokogiri'
require '../../lib/util/utils.rb'
require '../../lib/util/site.rb'
require '../../lib/util/deck.rb'

class Hareruya < Site

	def initialize(logger)
		super('Hareruya', logger)
		@url = 'http://www.hareruyamtg.com/jp/'
	end
	
	def how_match card
		if card.name.nil? then
			@log.error "card.name is nil at hareruya.how_match?(card)"
		end
		@log.debug "how match ["+card.name+"] at hareruya"
		card.store_url = get_url_of card
		@log.debug "url is [" + card.store_url.to_s + "]"
		read_cardpage(card.store_url)
		price = @card_nokogiri.css('span.sell_price').text
		price.gsub!(/\s|\n|￥|,/,"")
		card.price = price
		@log.debug "hareruya.how_match?(#{card.name}) finished. price is " + price
		price
	end
	
	def read_cardpage url
		@card_row_data = open url
		@card_nokogiri = Nokogiri::HTML.parse(@card_row_data, nil, @charset)
	end
	
	def get_url_of card
		@log.info "#{__method__} start."
		url = "http://www.hareruyamtg.com/jp/g/gEMN000028EN/"


		@log.info "#{__method__} finished. return #{url}"
		url
	end
	
	def detailed_search cardname
		@log.info "#{__method__} start."
		#other options
		illustrator = nil
		foil = false

		agent = Mechanize.new
		url = 'http://www.hareruyamtg.com/jp/goods/search.aspx'
		#if !url_exists? url, @log then
		#	@log.error "site url[#{url}] not exist. return nil."
		#	return nil
		#end
		page = agent.get(url)
		query = cardname
		puts page.form.field_with.name
		puts page.form.checkboxes.size
		#page.form[0].field_with(:name => 'name').value = query
		#puts page.form[0].checkbox_with.to_s
		#(:name => 'foil')
		puts "cb : #{page.form.to_s}"
		@log.debug "query: " + query

		search_results = page.form.submit
		puts "show search_results"
		search_results.css('div.autopagerize_page_element/ul.itemListLine').each do |item|
			#puts item.inner_text
		end
		#<ul class="itemListLine">
	
	end

	
	def extract_english_card_name cardname
		@log.debug "extract_english_card_name(#{cardname})start."
		if cardname.nil? then
			return nil
		elsif cardname.match('/') && cardname.match("》")
			##from 《コイロスの洞窟/Caves of Koilos》
			##to Caves of Koilos
			english_card_name = unescape_double_quote(cardname).split('/')[1]
			english_card_name.delete!("》\"")
			@log.debug "return [#{english_card_name}]"
			return english_card_name
		else
			cardname.gsub!(/[^ -~｡-ﾟ]/,"")
			#cardname.gsub!(/[ぁ-ん]/u,"")
			#cardname.gsub!(/[ァ-ヴ]/u,"")
			#cardname.gsub!(/[一-龠]/u,"")
			@log.debug "return [#{english_card_name}]"
			return cardname
		end
	end
	
	def convert_all_cardname_from_jp_to_eng(deck)
		@log.info "hareruya.convert_all_cardname_from_jp_to_eng(" + deck.deckname.to_s + ") start."
		deck.cards.each do |card|
			card.name = extract_english_card_name(card.name)
		end
	end
	
	def read_deckfile(filename, format, mode)
		#format:
		#card_type,name,quantity,price,store_url,price.date,generating_mana_type
		#for get_generating_mana_of_decks.rb
		#"card_type,name,quantity,generating_mana_type"
		#for get_deck_prices.rb
		#"card_type,name,quantity,price,store_url,price.date,generating_mana_type"
		
		#mode:
		#with_info or card_only

		@log.info "hareruya.read_deckfile[" + filename.to_s + "] start"
		@log.debug "target contents are"
		forms = format.split(',')
		forms.each do |form|
			@log.debug "\t" + form.to_s
		end
		@log.debug "mode: " + mode.to_s

		if !File.exist?(filename) then
			@log.error "hareruya.read_deckfile(" + filename.to_s + ", "+ format.to_s + ", " + mode.to_s + ")"
			@log.error "file[" + filename.to_s + "] not exist."
			return nil
		end

		#extract deckname from the first line.
		#info,BG_Con_JF 36850
		deckname = File.open(filename, "r:sjis").readlines[0].split(',')[1].split(' ')[0]
		deck = Deck.new(deckname,"hareruya",filename.to_s, @log)

		File.open(filename, "r:sjis").each do |line|
			line.chomp!
			@log.debug "line.chomp!"
			@log.debug "line[" + line.to_s + "]"
			line.encode!('utf-8')


			if line.empty? then
				@log.warn "at hareruya.read_deckfile"
				@log.warn "deckfile[" + filename.to_s + "] has empty line."
			elsif line.include?("info,") then
				card_type = "info"
			else
				#split each line according to the format
				(card_type,cardname,quantity,manacost,generating_mana_type,price,store_url,date) = line.split(',')
				#(card_type,cardname,quantity,price,store_url,date) = line.split(",")
				#contents = line.split(",")
				#for i in 0..forms.size-1
					#puts forms[i].to_s + " =  " + contents[i].to_s
					#instance_eval("#{forms[i]}") = contents[i]
				#end
			end
			
			if card_type.include?("land") or card_type.include?("creature") or card_type.include?("spell") or card_type.include?("sideboardCards") then
				cardname=reconvert_period(cardname)
				card = Card.new(cardname.to_s, @log)
				card.quantity = quantity
				card.manacost = manacost
				card.generating_mana_type = generating_mana_type
				card.store_url = store_url
				card.card_type = card_type
				card.price.value = price
				card.price.date = date
				deck.cards.push(card)
			end
			
		end
		
		if mode == "with_info" then deck.set_information() end

		@log.debug "hareruya.read_deckfile(" + filename.to_s + ") finished. return deck."

		return deck
	end
	
	#create deck.cards which is array of Card in accordance with deck.path.
	def create_card_list(deck, create_mode)
	#create_mode:[full, except_price, from_file]
	#if create_mode is "full", the contents of each card are
		#card_type,
		#name,
		#quantity,
		#price, <-very slow!
		#store_url,
		#price.date,
	#if create_mode is "except_price", the contents of each card are
		#card_type,
		#name,
		#quantity,
		#store_url,
	#if create_mode is "from_file", the contents are depend on the file(deck.path)
		@log.debug "Hareruya.create_card_list(" + deck.deckname.to_s + ", " + create_mode.to_s + ") start"
		
		if create_mode != "full" && create_mode != "except_price" && create_mode != "from_file" then
			@log.error "create_mode ERROR. create_mode is [" + create_mode.to_s + "]"
		end
		
		deck.cards = []
		if deck.path.nil? then
			@log.error "open[nil]@hareruya.create_card_list"
		end
		@log.debug "open[" + deck.path + "]"
		@deck_row_data = open(deck.path)
		
		quantity_list=[] #Array of card quantity
		card_type="land"
		deck.quantity_of_mainboard_cards = 0
		deck.quantity_of_lands = 0
		@deck_row_data.each_line do |line|
			if line.include?('Lands</h3>') then
				card_type = "creature"
				deck.quantity_of_creatures = 0
			end
			if line.include?('Creatures</h3>') then
				card_type = "spell"
				deck.quantity_of_spells = 0
			end
			if line.include?('Spells</h3>') then
				card_type = "sideboardCards"
				deck.quantity_of_sideboard_cards = 0
			end
			
			#extract quantity
			if line.include?('decksNumber') then
				quantity = Nokogiri::HTML.parse(line, nil, @charset).text
				quantity.chomp!
				quantity_list.push quantity
				
				case card_type
				when "land"
					deck.quantity_of_mainboard_cards += quantity.to_i
					deck.quantity_of_lands += quantity.to_i
					#puts "quantity_of_lands " + deck.quantity_of_lands.to_s
				when "creature"
					deck.quantity_of_mainboard_cards += quantity.to_i
					deck.quantity_of_creatures +=quantity.to_i
					#puts "quantity_of_creatures " + deck.quantity_of_creatures.to_s
				when "spell"
					deck.quantity_of_mainboard_cards += quantity.to_i
					deck.quantity_of_spells +=quantity.to_i
					#puts "quantity_of_spells " + deck.quantity_of_spells.to_s
				when "sideboardCards"
					deck.quantity_of_sideboard_cards += quantity.to_i
					#puts "quantity_of_sideboard_cards " + deck.quantity_of_sideboard_cards.to_s
				else
					@log.error "invalid card_type at extract quantity"
				end
			end

			#extract card_name and url
			if line.include?('data-goods') then
				card_name = Nokogiri::HTML.parse(line, nil, @charset).text
				card_name.chomp!
				url = "http://www.hareruyamtg.com" + line.split("\"")[1]
				card = Card.new(card_name, @log)
				card.store_url = url
				card.card_type = card_type
				if create_mode == "full" then
					@log.debug "hareruya.create_card_list call #{card.name}.renew_at(card, hareruya)"
					card.price.renew_at(self)
					@log.debug "renewed value is #{card.price}"
				end
				@log.debug "name[" + card_name.to_s + "], card_type[" + card.card_type.to_s + "], card.price[" + card.price.to_s + "]"
				deck.cards.push(card)
			end
		end

		for i in 0..deck.cards.size-1
			deck.cards[i].quantity = quantity_list[i]
		end
	end
	



	def create_deck_from_url(url,priceflag:"off",fileflag:"off")
	#input:url #http://www.hareruyamtg.com/jp/k/kD08241S/
	#output:deck
		if url.split('/').size < 6 then
			@log.error "[error] at hareruya.create_deck_from_url_execpt_price(url)"
			@log.error "url not invalid. cannot get deckname."
			@log.error "url = " + url
			return nil
		end

		#deckname = url.split('/')[6]
		deckname = get_archetype_from_url(url).to_s + "_" + url.split('/')[6].to_s
		deck = Deck.new(deckname, "hareruya", url, @log)
		if priceflag == true || priceflag == "on" then
			create_card_list(deck, "full")
		else
			create_card_list(deck, "except_price")
		end
		convert_all_cardname_from_jp_to_eng(deck)
		deck.get_contents_of_all_cards
		deck.get_sum_of_generating_manas
		
		if priceflag == true || priceflag == "on" then
			#calculate price of each_card_type and deck.
			#such as deck.price, land, creatures, spells, MainboardCards, sideboardCards
			#using card.price, which had been set at create_card_list(deck, "full").
			deck.calc_price_of_whole_deck

			deck_prices = Deck_prices.new(@log)
			deck_prices.read("../../decks/decklist.csv")
			deck_prices.add(deck)
			deck_prices.write("../../decks/decklist.csv")
		end

		if fileflag == true || fileflag == "on" then
			if priceflag == true || priceflag == "on" then
				deck.create_deckfile("../../decks/hareruya_auto/" + deckname.to_s + ".csv", "card_type,name,quantity,manacost,generating_mana_type,price,price.date,store_url", "with_info")
			else
				deck.create_deckfile("../../decks/hareruya_auto/" + deckname.to_s + ".csv", "card_type,name,quantity,manacost,generating_mana_type,store_url", "with_info")
			end
		end
		return deck
	end


	
	def get_archetype_from_url(url)
		@log.info "get_archetype_from_url(" + url.to_s + ") start"
		
		#### get url start
		html_row_data = open(url)
		#File.open("deckpage.html", "w") do |file|
		#	file.write index_row_data.read
		#end
		html_nokogiri = Nokogiri::HTML.parse(html_row_data, nil, @charset)
		str = html_nokogiri.css("div.container/div/span.kuzu").inner_text
		@log.debug "extract[" + str.to_s + "]"

		deckname = format_deckname(str)

		@log.debug "get_archetype_from_url(" + url.to_s + ") finished."
		@log.debug "return " + deckname.to_s
		return deckname
	end

	
	def format_deckname(str)
		#from "デッキ検索トップ > 赤単/Mono Red"
		#to "Mono Red"
		@log.info "format_deckname from[" + str.to_s + "]"
		deckname = str.split('/')[1].gsub(' ','_')
		if deckname.nil? then deckname = "nil" end
		@log.info "to[" + deckname.to_s + "]"
		return deckname
	end



	def search_deckurls_from_webpage(deck_num)
		@log.info "search_deckurls_from_webpage(" + deck_num.to_s + ") start" 
		#get url of each deck at
		#http://www.hareruyamtg.com/jp/deck/search.aspx?name_je_type=1&search.x=submit&date_format=Standard+-+DTK_SOI&format=Standard&ps=50&p=2&releasedt_type=1
		# and
		#http://www.hareruyamtg.com/jp/deck/search.aspx?name_je_type=1&search.x=submit&date_format=Standard+-+DTK_SOI&format=Standard&ps=50&p=1&releasedt_type=1
		# and so on.
		
		deck_urls = [] #array of url
		index_size = 50 #num of decks in one index page.
		index_page = 1 #
		while 1 do
			@log.debug "index_page[" + index_page.to_s + "], deck_urls.size[" + deck_urls.size.to_s + "]"
			#### get url start
			index_url = "http://www.hareruyamtg.com/jp/deck/search.aspx?name_je_type=1&search.x=submit&date_format=Standard+-+DTK_SOI&format=Standard&ps=" + index_size.to_s + "&p=" + index_page.to_s + "&releasedt_type=1"
			index_row_data = open(index_url)
			#File.open("index_page[" + index_page.to_s + "].txt", "w") do |file|
			#	file.write index_row_data.read
			#end
			index_nokogiri = Nokogiri::HTML.parse(index_row_data, nil, @charset)
			index_nokogiri.css('a').each do |a|
				if a.attribute('href').value.match('/jp/k/') then # =>/jp/k/kD01419K/
					url = "http://www.hareruyamtg.com/" + a.attribute('href').value
						# => http://www.hareruyamtg.com//jp/k/kD01418K/
					@log.debug "url[" + url.to_s + "]"
					#deck_name = a.css('div/ul/li/span.deckTitle').inner_text
					deck_name = url.split('/')[6] #kD01419K
					@log.debug "deck_name[" + deck_name.to_s + "]"
					private_flag = a.css('div/ul/li/div.private').inner_html
					# if open deck list => ""
					# if closed deck list => <img src="/img/usr/search_closed.png" alt="private">
					@log.debug "private_flag[" + private_flag.to_s + "]"
					if private_flag.size == 0 then
						deck_urls.push(url)
					end
					if(deck_urls.size >= deck_num) then
						return deck_urls
					end

				end
			end
			index_page += 1
		end
	end
	
	
	
	def select_archetype_of(deck)
	#by deck.path, deck.id
		if deck.nil?
			@log.error "Hareruya.select_archetype_of(nil)."
			exit 1
		end
		@log.info "Hareruya.select_archetype_of[#{deck.deckname}] start."
		
		@log.debug "first try by path/filename[#{deck.path}"
		#if filename is archetype_id WB_Control_kD01304K
		if deck.path.include?(deck.id) then
			#extract filename from ../../test_cases/decklists/output/WB_Control_kD01304K.csv
			*,filename = deck.path.split('/')
			@log.debug "filename[#{filename}]"
			archetype,* = filename.split('_'+deck.id.to_s)
			@log.debug "archetype[#{archetype}]"
			deck.archetype = archetype
			@log.info "Hareruya.select_archetype(#{deck.deckname}) finished. return deck.archetype[#{deck.archetype}]"
			return deck.archetype
		end
		
		
		@log.debug "second try by id"
		url = "http://www.hareruyamtg.com/jp/k/#{deck.id}"
		if url_exists?(url, @log) then
			deck.archetype = get_archetype_from_url(url)
			@log.debug "url[#{url}], archetype[#{deck.archetype}]"
			@log.info "Hareruya.select_archetype(#{deck.deckname}) finished. return deck.archetype[#{deck.archetype}]."
			return deck.archetype
		end
		
		
		deck.archetype = nil
		@log.info "Hareruya.select_archetype(#{deck.deckname}) finished. cannot identify deck.archetype. return nil"
		return nil
	end
	
	
end

