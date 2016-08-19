

require	"logger"
require 'open-uri'
require 'nokogiri'
require 'mechanize'
require '../../lib/util/card.rb'
require '../../lib/util/deck.rb'
require '../../lib/util/utils.rb'
require '../../lib/util/deck_prices.rb'

class Store
	@log
	@name
	@card_name
	@url
	@charset="UTF-8"
	@card_row_data
	@card_nokogiri
	@deck_row_data
	@deck_nokogiri
	

	attr_accessor :name
	
	def initialize(store_name, logger)
		@log = logger
		@log.info "Store.initialize(" + store_name + ")"
		@name = store_name
	end
	
	def how_match?(card)
	end
	
	def extract_english_card_name(cardname)
	end
	
	def create_card_list(deck, create_mode)
		#return cards
	end
	
	def read_cardpage(url)
		@card_row_data = open(url)
		#File.open(@card_name+".txt", "w") do |file|
		#	file.write @card_row_data.read
		#end
		@card_nokogiri = Nokogiri::HTML.parse(@card_row_data, nil, @charset)
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

class MagicOnline < Store
	def initialize(logger)
		super("MagicOnline", logger)
		@url = ""
	end
	
	
	def read_deckfile(deckname, filename,filetype:"text")
	#create deck class from text or csv file exported by magic online application.
		@log.info "MagicOnline.read_deckfile start."
		@log.debug "deckname[" + deckname.to_s + "], filename[" + filename.to_s + "], filetype[" + filetype.to_s + "]"
		#TODO if file not exist.
		deck = Deck.new(deckname, "mo", filename, @log)
		
		case filetype
		when "text" then
			card_type = "mainboardCards"
	
			File.open(filename, 'r').each do |line|
				if line =~ /^\s*$/ then
					card_type = "sideboardCards"
				else
					line.chomp!
					cardname = line.split(' ',2)[1]
					quantity = line.split(' ',2)[0]
					@log.debug "deck.cards.push[cardname(" + cardname.to_s + "), quantity(" + quantity.to_s + "), card_type(" + card_type.to_s + ")]"

					card = Card.new(cardname, @log)
					card.quantity = quantity.to_i
					card.card_type = card_type

					deck.cards.push(card)
				end
			end
			
		when "csv" then
	
			File.open(filename, 'r').each do |line|
			#Card Name,Quantity,ID #,Rarity,Set,Collector #,Premium,Sideboarded,
			#"Kalitas, Traitor of Ghet",1,59417,Mythic Rare,OGW,86/184,No,Yes
				if (line.split("\"").size != 1) && #except head line or blank line
					(quantity = line.split("\"")[2].split(',').size == 8) then
					cardname = line.split("\"")[1]
					quantity = line.split("\"")[2].split(',')[1]
					id = line.split("\"")[2].split(',')[2]
					rarerity = line.split("\"")[2].split(',')[3]
					set = line.split("\"")[2].split(',')[4]
					collector_number = line.split("\"")[2].split(',')[5]
					premium = line.split("\"")[2].split(',')[6]
					sideboarded = line.split("\"")[2].split(',')[7]
					
					if sideboarded.match("No") then card_type = "mainboardCards"
					else card_type = "sideboardCards"
					end

					card = Card.new(cardname, @log)
					card.quantity = quantity.to_i
					card.card_type = card_type
					deck.cards.push(card)
				end
			end		
		end
		return deck
	end



	def create_card_list(deck, filename)
	#create filename.text
		@log.info "MagicOnline.create_card_list start."
		@log.debug "convert " + deck.deckname.to_s + " and save to " + filename.to_s
		 File.open(filename, "w+:sjis") do |file|
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