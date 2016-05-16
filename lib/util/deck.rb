
require	"logger"
require 'date'
require '../../lib/util/util.rb'
require '../../lib/util/card.rb'
require "../../lib/util/store.rb"

class Deck
	@log
		
	@deckname
	@cards #Array of Card
	#@deck_list #hash. deck_list[:cardname]=num
	@price #Class Price. deck_price. deck_list[:cardname]*cards.price
	attr_accessor :deckname, :cards, :deck_list, :price

	@list_type
	@path #url+name or dir+name
	@date
	@store
	attr_accessor :date, :path, :date, :store

	#quantity of each card type.
	@quantity_of_all
	@quantity_of_lands
	@quantity_of_creatures
	@quantity_of_spells
	@quantity_of_mainboard_cards
	@quantity_of_sideboard_cards
	attr_accessor :quantity_of_lands, :quantity_of_creatures,:quantity_of_spells,:quantity_of_mainboard_cards,:quantity_of_sideboard_cards

	#price of each card type.
	@price_of_all
	@price_of_lands
	@price_of_creatures
	@price_of_spells
	@price_of_mainboard_cards
	@price_of_sideboard_cards
	attr_accessor :price_of_all, :price_of_lands, :price_of_creatures,:price_of_spells,:price_of_mainboard_cards,:price_of_sideboard_cards

	
	def initialize( \
		deckname, \
		list_type, \
		path)
		## list_type is storename or file etc...
		@log = Logger.new("../../log")
		@log.info "Deck initialize"
		@log.debug "set deck name[" + deckname + "]"
		@deckname = deckname
		@log.debug "set list type[" + list_type + "]"
		@list_type = list_type
		@log.debug "set path[" + path + "]"
		@path = path
		@date = DateTime.now
		@deck_list = {}
		
		@quantity_of_lands = 0
		@quantity_of_creatures = 0
		@quantity_of_spells = 0
		@quantity_of_mainboard_cards = 0
		@quantity_of_sideboard_cards = 0
		@price_of_all = 0		
		@price_of_lands = 0
		@price_of_creatures = 0
		@price_of_spells = 0
		@price_of_mainboard_cards = 0
		@price_of_sideboard_cards = 0
	end
	
	def create_cardlist #TODO: rename to create_cardlist_with_price
		@log.debug "Deck[" + @deckname + "] create_cardlist() start"
		case @list_type
		when "hareruya" then
			@log.debug "create from hareruya webpage[" + @path + "]"
			@store = Hareruya.new()
			@store.create_card_list(self)
		else
			@log.error "Deck.create_cardlist(invalid list_type)"
			@log.error "list_type is " + @list_type
		end
	end
	
	def create_cardlist_simple
		#english name,num
		@log.debug "Deck[" + @deckname + "] create_cardlist_simple() start"
		case @list_type
		when "hareruya" then
			@log.debug "create from hareruya webpage[" + @path + "]"
			@store = Hareruya.new()
			@store.create_card_list_simple(self)
		else
			@log.error "Deck.create_cardlist(invalid list_type)"
			@log.error "list_type is " + @list_type
		end
	end
	
	def create_deckfile(filename, format, mode)
		#format:
		#card_type,name,quantity,price,store_url,price.date,generating_mana_type
		#for get_generating_mana_of_decks.rb
		#"card_type,name,quantity,generating_mana_type"
		#for get_deck_prices.rb
		#"card_type,name,quantity,price,store_url,price.date,generating_mana_type"
		
		#mode:
		#with_info or card_only
		
		@log.info "create_deckfile(" + filename + ") start."
		@log.debug "filename: " + filename.to_s
		@log.debug "target contents are"
		forms = format.split(',')
		forms.each do |form|
			@log.debug "\t" + form.to_s
		end
		@log.debug "mode: " + mode.to_s

		#puts cards[0].name
		#form = "name"
		#puts cards[0].instance_eval "print #{form}" # == puts cards[0].name
		case mode
		when "card_only" then
			@log.debug "start writing. mode is card_only."
			File.open(filename, "w:sjis") do |file|
				@cards.each do |card|
					#write decks
					forms.each do |form|
						contents = card.instance_eval("#{form}")
						if contents.nil? then
							@log.fatal "contents of[" + card.name + "]." + form + " is nil"
						end
						file.print convert_period(contents.to_s).to_s + ","
					end
					file.print "\n"
				end	
			end
		when "with_info" then
			@log.debug "start writing. mode is with_info."
			File.open(filename, "w:sjis") do |file|
				set_information
				file.puts "info," + @deckname.to_s + " " + @price_of_all.to_s
				previous_type = "info"
				@cards.each do |card|
					#write informations
					@log.info "previous_type[" + previous_type.to_s + "], card_type[" + card.card_type.to_s + "]"
					if(previous_type == "land" && card.card_type == "creature") then
						@log.debug "write land information"
						file.puts "info," + @quantity_of_lands.to_s + " Lands " + @price_of_lands.to_s
					elsif(previous_type == "creature" && card.card_type == "spell") then
						@log.debug "write creature information"
						file.puts "info," + @quantity_of_creatures.to_s + " Creatures " + @price_of_creatures.to_s
					elsif(previous_type == "spell" && card.card_type == "sideboardCards") then
						@log.debug "write spell and main_board information"
						file.puts "info," + @quantity_of_spells.to_s + " Spells " + @price_of_spells.to_s					
						file.puts "info," + @quantity_of_mainboard_cards.to_s + " MainboardCards " + @price_of_mainboard_cards.to_s
					end
					#write cards
					forms.each do |form|
						contents = card.instance_eval("#{form}")
						if contents.nil? then
							@log.fatal "contents of[" + card.name + "]." + form + " is nil"
						end
						@log.info "write " + card.name + "." + form + "[" + convert_period(contents.to_s).to_s + "]"
						file.print convert_period(contents.to_s).to_s + ","
					end
					file.print "\n"
					previous_type = card.card_type
					@log.debug "card[" + card.name.to_s + "] fineished.set previous_type [" + previous_type.to_s + "]"
				end
				#write informations
				@log.debug "write sideboardCards information"
				file.puts "info," + @quantity_of_sideboard_cards.to_s + " SideboardCards " + @price_of_sideboard_cards.to_s
				file.puts "info," + @path
			end
		else
			@log.error "mode error"
			puts "mode error"
		end
	end

	def create_deckfile_full(filename)
		#card_type,card_name,quantity,price
		@log.debug "create_deckfile(" + filename + ") start."
		File.open(filename, "w:sjis") do |file|
			@cards.each do |card|
				#write decks
				file.print card.card_type.to_s + "," + convert_period(card.name).to_s + "," + card.quantity.to_s + "," + card.price.to_s + "," + card.store_url.to_s + "," + card.price.date.to_s + "\n"
			end	
		end
	end

	def read_deckfile_simple(filename)
		#cardtype,english name,num
		@log.info "read_deckfile_simple[" + filename.to_s + "] start"
		@cards = []
		File.open(filename, "r:sjis").each do |line|
			@log.debug "line[" + line.to_s + "]"
			line.encode!('utf-8')
			(card_type,cardname,quantity) = line.split(",")
			
			if card_type.include?("land") or card_type.include?("creature") or card_type.include?("spell") or card_type.include?("sideboardCards") then
				card_name=reconvert_period(cardname)
				card = Card.new(card_name.to_s)
				card.quantity = quantity
				card.card_type = card_type
				@cards.push(card)
			end
			
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

		@log.info "read_deckfile[" + filename.to_s + "] start"
		@log.debug "target contents are"
		forms = format.split(',')
		forms.each do |form|
			@log.debug "\t" + form.to_s
		end
		@log.debug "mode: " + mode.to_s

		@cards = []
		File.open(filename, "r:sjis").each do |line|
			line.chomp!
			@log.debug "line.chomp!"
			@log.debug "line[" + line.to_s + "]"
			line.encode!('utf-8')

			if line.include?("info,") then
				card_type = "info"
			else
				(card_type,cardname,quantity,price,store_url,date) = line.split(",")
				#split according to the format
				contents = line.split(",")
				#for i in 0..forms.size-1
					#puts forms[i].to_s + " =  " + contents[i].to_s
					#instance_eval("#{forms[i]}") = contents[i]
				#end
			end
			
			if card_type.include?("land") or card_type.include?("creature") or card_type.include?("spell") or card_type.include?("sideboardCards") then
				cardname=reconvert_period(cardname)
				card = Card.new(cardname.to_s)
				card.quantity = quantity
				card.store_url = store_url
				card.card_type = card_type
				card.price.value = price
				card.price.date = date
				@cards.push(card)
			end
			
		end
		
		if mode == "with_info" then set_information() end
	end


	def read_deckfile_(filename) #TODO: move to hareruya
		#card_type,cardname,quantity,price,store_url,date
		@log.info "read_deckfile[" + filename.to_s + "] start"
		@cards = []
		File.open(filename, "r:sjis").each do |line|
			line.chomp!
			@log.debug "line.chomp!"
			@log.debug "line[" + line.to_s + "]"
			line.encode!('utf-8')
			(card_type,cardname,quantity,price,store_url,date) = line.split(",")
			
			if card_type.include?("land") or card_type.include?("creature") or card_type.include?("spell") or card_type.include?("sideboardCards") then
				card_name=reconvert_period(card_name)
				card = Card.new(cardname.to_s)
				card.quantity = quantity
				card.store_url = store_url
				card.card_type = card_type
				card.price.value = price
				@cards.push(card)
			end
			
		end
	end
	
	def get_contents
		@log.info "deck.get_contents start"
		@cards.each do |card|
			card.read_contents
			if !File.exist?("../../cards/" + card.name.to_s) then
				card.write_contents()
			end
		end
	end
	
	def set_information #from this.cards
		#set quantity_of_*** and price_of_***
		@log.info "set_information start."

		#initialize
		@quantity_of_lands = 0
		@quantity_of_creatures = 0
		@quantity_of_spells = 0
		@quantity_of_mainboard_cards = 0
		@quantity_of_sideboard_cards = 0
		@quantity_of_all = 0
		@price_of_lands = 0
		@price_of_creatures = 0
		@price_of_spells = 0
		@price_of_mainboard_cards = 0
		@price_of_sideboard_cards = 0
		@price_of_all = 0

		@cards.each do |card|
			@log.debug "card.card_type = " + card.card_type.to_s
			
			if card.card_type.to_s == "land"
			@quantity_of_lands += card.quantity.to_i
			@quantity_of_mainboard_cards += card.quantity.to_i
			@quantity_of_all += card.quantity.to_i
			@price_of_lands += card.price.to_i * card.quantity.to_i
			@price_of_mainboard_cards += card.price.to_i * card.quantity.to_i			
			@price_of_all += card.price.to_i * card.quantity.to_i

			elsif card.card_type.to_s == "creature"
			@quantity_of_creatures += card.quantity.to_i
			@quantity_of_mainboard_cards += card.quantity.to_i
			@quantity_of_all += card.quantity.to_i
			@price_of_creatures += card.price.to_i * card.quantity.to_i
			@price_of_mainboard_cards += card.price.to_i * card.quantity.to_i			
			@price_of_all += card.price.to_i * card.quantity.to_i
			
			elsif card.card_type.to_s == "spell"
			@quantity_of_spells += card.quantity.to_i
			@quantity_of_mainboard_cards += card.quantity.to_i
			@quantity_of_all += card.quantity.to_i
			@price_of_spells += card.price.to_i * card.quantity.to_i			
			@price_of_mainboard_cards += card.price.to_i * card.quantity.to_i			
			@price_of_all += card.price.to_i * card.quantity.to_i

			elsif card.card_type.to_s == "sideboardCards"
			@quantity_of_sideboard_cards += card.quantity.to_i
			@quantity_of_all += card.quantity.to_i
			@price_of_sideboard_cards += card.price.to_i * card.quantity.to_i			
			@price_of_all += card.price.to_i * card.quantity.to_i
			end
		end
		
	end
	
	def calculate_price
		@log.info "calculate_price start"
		@price = 0
		@cards.each do |card|
			@log.debug card.name + ", " + card.quantity + ", " + card.price.to_s
			@price += card.quantity.to_i * card.price.to_i
			@log.debug "price="+price.to_s
		end
		return @price
	end
	
	
	def view_deck_list
		#card_type,card_name,quantity,price
		@log.debug "Deck[" + @deckname + "] view_deck_list start"
		@cards.each do |card|
			print card.card_type.to_s + "," + card.name.to_s + "," + card.quantity.to_s + "," + card.price.to_s + "," + card.store_url.to_s + "," + card.price.date.to_s + "\n"
		end
		@log.debug "Deck[" + @deckname + "] view_deck_list finished"
	end
	
	
	def calc_price_of_each_card_type
		if @cards.nil? then @log.error "@cards is nil at calc_price_of_each_card_type." end
		@log.debug "calc_price_of_each_card_type(deck) start"
		@price_of_all = 0		
		@price_of_lands = 0
		@price_of_creatures = 0
		@price_of_spells = 0
		@price_of_mainboard_cards = 0
		@price_of_sideboard_cards = 0

		@cards.each do |card|
			@price_of_all += card.price.to_i * card.quantity.to_i
			case card.card_type
			when "land"
				@price_of_lands +=card.price.to_i * card.quantity.to_i
				@price_of_mainboard_cards +=card.price.to_i * card.quantity.to_i
			when "creature"
				@price_of_creatures += card.price.to_i * card.quantity.to_i
				@price_of_mainboard_cards +=card.price.to_i * card.quantity.to_i
			when "spell"
				@price_of_spells +=card.price.to_i * card.quantity.to_i
				@price_of_mainboard_cards +=card.price.to_i * card.quantity.to_i
			when "sideboardCards"
				@price_of_sideboard_cards +=card.price.to_i * card.quantity.to_i
			else
				@log.error "invalid card_type at calc_price_of_each_card_type"
			end
		end
	end
end

