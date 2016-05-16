

require	"logger"
require 'open-uri'
require 'nokogiri'
require '../../lib/util/card.rb'
require '../../lib/util/util.rb'

class Store
	@log
	@store_name
	@card_name
	@url
	@charset="UTF-8"
	@card_row_data
	@card_nokogiri
	@deck_row_data
	@deck_nokogiri
	

	attr_accessor :store_name
	
	def initialize(store_name)
		@log = Logger.new("../../log")
		@log.info "Store.initialize(" + store_name + ")"
		@store_name = store_name
	end
	
	def how_match?(cardname)
	end
	
	def extract_english_card_name(cardname)
	end
	
	def create_card_list(path)
		#return cards
	end
	
	def read_cardpage(url)
		@card_row_data = open(url)
		#File.open(@card_name+".txt", "w") do |file|
		#	file.write @card_row_data.read
		#end
		@card_nokogiri = Nokogiri::HTML.parse(@card_row_data, nil, @charset)
		#puts @card_nokogiri.css('span').attribute('class="sell_price"').text
		#puts @card_nokogiri.css('span.sell_price').text
		#@card_nokogiri.xpath('//li[@class="item_info_top"]').each do |line|
		#	puts line
		#end
	end
	
	def write_html_to_file(filename)
		@log.debug "write_html_to_file to " + filename
		
		#File.open(filename, "w") do |file|
		#	file.write @card_row_data.read
		#end
		@card_row_data.read do |line|
			puts line
		end
	end

end


class Hareruya < Store	
	def initialize()
		super("Hareruya")
		@url = "http://www.hareruyamtg.com/jp/"
	end
	
	def how_match?(card)
		@log.debug "how match ["+card.name+"]@hareruya"
		@card_name = card.name
		@log.debug "url is [" + card.store_url + "]"
		read_cardpage(card.store_url)
		price = @card_nokogiri.css('span.sell_price').text
		#price = "100"
		price.gsub!(/\s|\n|￥|,/,"")
		card.price.value = price
		@log.debug "price is " + price
		return price
	end
	
	def extract_english_card_name(cardname)
		english_card_name = cardname.split('/')[1]
		english_card_name.delete!("》")
		return english_card_name
		##from 《コイロスの洞窟/Caves of Koilos》
		##to Caves of Koilos
	end
	
	def convert_all_cardname_from_jp_to_eng(deck)
		@log.info "hareruya.convert_all_cardname_from_jp_to_eng(" + deck.deckname.to_s + ") start."
		deck.cards.each do |card|
			card.name = extract_english_card_name(card.name)
		end
	end
	
	
	
	#fill deck.cards.
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
		@log.debug "open[" + deck.path + "]"
		@deck_row_data = open(deck.path)
		
		#File.open("BGCON.txt", "w") do |file|
		#	file.write @deck_row_data.read
		#end
		
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
				card = Card.new(card_name)
				card.store_url = url
				card.card_type = card_type
				if create_mode == "full" then card.price.renew_at("hareruya") end
				deck.cards.push(card)
			end
		end

		for i in 0..deck.cards.size-1
			#deck.deck_list["#{deck.cards[i].name}"] = quantity_list[i].to_s
			deck.cards[i].quantity = quantity_list[i]
		end
		
		#@deck_nokogiri = Nokogiri::HTML.parse(@deck_row_data, nil, @charset)
		#quantity_list=[] #Array of card quantity
		#@deck_nokogiri.xpath('/').each do |line|
		#	quantity_list.push(line.css('td.decksNumber').inner_text)
		#	deck.cards.push(line.css('a.popup_product').inner_text)
		#end
		
		#if @deck_nokogiri.css('td.decksNumber').size != @deck_nokogiri.css('a.popup_product').size then
		#	@log.error "Hareruya.create_card_list"
		#	@log.error "quantitylist.size not equal popup_product.size"
		#end
		
		#for i in 0..@deck_nokogiri.css('td.decksNumber').size-1
		#	puts i
		#	puts @deck_nokogiri.css('td.decksNumber')[i].inner_text
		#	puts @deck_nokogiri.css('a.popup_product')[i].inner_text
		#end
		#puts @deck_nokogiri.css('td.decksNumber').size
		#puts @deck_nokogiri.css('a.popup_product').size
		#puts deck.cards.size
		#puts quantity_list.size
		
		
		#@deck_nokogiri.css('a.popup_product').each do |card|
		#	puts card.text
		#end
		
		#deck.cards.push("Kalitas, Traitor of Ghet")
		#deck.cards.push("Ob Nixilis Reignited")
	end
	
=begin	
	def create_card_list_simple(deck)
		#english name,num
		@log.debug "Hareruya.create_card_list_simple start."
		deck.cards = []
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
				card_name=extract_english_card_name(card_name)
				card = Card.new(card_name)
				#card.store_url = url
				card.card_type = card_type
				deck.cards.push(card)
			end
		end
		
		for i in 0..deck.cards.size-1
			deck.cards[i].quantity = quantity_list[i]
		end


		@log.debug "Hareruya.create_card_list_simple finished."
	end
=end
end

class MagicOnline < Store
	def initialize()
		super("MagicOnline")
		@url = ""
	end
	
	def create_card_list(deck, filename)
		@log.info "MagicOnline.create_card_list start."
		@log.debug "convert " + deck.deckname.to_s + " and save to " + filename.to_s
		 File.open(filename, "w:sjis") do |file|
		 	previous_card_type = "nil"
			deck.cards.each do |card|
				if previous_card_type == "nil" and card.card_type == "sideboardCards" then
					file.print "\n\n"
					previous_card_type = "sideboardCards"
				end
				file.puts card.quantity.to_s + " " + card.name.to_s
			end
		end
	end
	

end