
require	"logger"
require 'date'
require '../../lib/util/utils.rb'
require '../../lib/util/card.rb'
require "../../lib/util/store.rb"

class Deck
	@log
		
	@deckname
	@cards #Array of Card
	@price #Class Price. deck_price.
	@sum_of_mainboard_generating_manas #str
	@sum_of_sideboard_generating_manas #str

	attr_accessor :deckname, :cards, :price, :sum_of_mainboard_generating_manas, :sum_of_sideboard_generating_manas

	@list_type #file or hareruya or...
	@path #dir+name or url+name or...
	@date
	@store
	@mana_analyzer
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
		path, \
		logger)
		## list_type is storename or file etc...
		@log = logger
		@log.info "Deck initialize"
		@log.debug "set deck name[" + deckname + "]"
		@deckname = deckname
		@cards = []
		@price = Price.new(nil,@log)
		@sum_of_mainboard_generating_manas = "" #str
		@sum_of_sideboard_generating_manas = "" #str
		@log.debug "set list type[" + list_type + "]"
		@list_type = list_type
		@log.debug "set path[" + path + "]"
		@path = path
		@date = DateTime.now
		@mana_analyzer = Mana_analyzer.new(self)

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
	
	
	
	def view_deck_list #TODO: view_deck_list(format)
		#card_type,card_name,quantity,price
		@log.debug "Deck[" + @deckname + "] view_deck_list start"
		@cards.each do |card|
			print card.card_type.to_s + "," + card.name.to_s + "," + card.quantity.to_s + "," + card.price.to_s + "," + card.store_url.to_s + "," + card.price.date.to_s + "," + card.generating_mana_type.to_s + "\n"
		end
		@log.debug "Deck[" + @deckname + "] view_deck_list finished"
	end
	
	
	
	def create_cardlist(create_mode)
	#create @cards
	#the options of "create_mode" are depend on the creator.
	#For example, when deck.list_type is "hareruya" and created by hareruya,
	#if create_mode is "full", the contents of each card are
	#card_type,name,quantity,price,store_url,price.date,
	#and if create_mode is "except_price", the contents of each card are
	#card_type,name,quantity,store_url,
	#and if create_mode is "from_file", the contents are depend on the file(deck.path).
	#Please read the creator's comments.
		@log.debug "Deck[" + @deckname + "] create_cardlist() start."
		case @list_type
		when "hareruya" then
			@log.debug "create cardlist by hareruya."
			@log.debug "create_mode[" + create_mode.to_s + "], path[" + @path.to_s + "]"
			@store = Hareruya.new()
			@store.create_card_list(self, create_mode)
		else
			@log.error "Deck.create_cardlist(invalid list_type)"
			@log.error "list_type is " + @list_type
		end
		@log.debug "Deck[" + @deckname + "] create_cardlist() finished."
	end
	

	
	def create_deckfile(filename, format, mode)
	#create filename.csv.
		#info,BG Con JF 41930 W3U3B21R3G14C2A3
		#land,Evolving Wilds,3,20,http://www.hareruyamtg.com/jp/g/gBFZ000236JN/,2016-05-08T13:07:46+09:00,
		#land,Forest,5,20,http://www.hareruyamtg.com/jp/g/gSOI000297JN/,2016-05-08T13:07:47+09:00,
		#land,Hissing Quagmire,4,850,http://www.hareruyamtg.com/jp/g/gOGW000171JN/,2016-05-08T13:07:59+09:00,
		#:
		#spell,Transgress the Mind,2,300,http://www.hareruyamtg.com/jp/g/gBFZ000101JN/,2016-05-08T13:09:49+09:00,
		#spell,Dead Weight,1,30,http://www.hareruyamtg.com/jp/g/gSOI000106JN/,2016-05-08T13:09:51+09:00,
		#info,30 Spells 16470
		#info,60 MainboardCards 35970 111 W0U0B47R0G7C0
		#sideboardCards,Kalitas Traitor of Ghet,1,5000,http://www.hareruyamtg.com/jp/g/gOGW000086JN/,2016-05-08T13:09:52+09:00,
		#sideboardCards,Clip Wings,1,50,http://www.hareruyamtg.com/jp/g/gSOI000197JN/,2016-05-08T13:09:54+09:00,
		#sideboardCards,Naturalize,3,10,http://www.hareruyamtg.com/jp/g/gDTK000205JN/,2016-05-08T13:09:56+09:00,
		#:
		#	sideboardCards,Orbs of Warding,1,60,http://www.hareruyamtg.com/jp/g/gORI000234JN/,2016-05-08T13:10:19+09:00,
		#info,15 SideboardCards 5960 33 W0U0B12R0G4C0
		#info,http://www.hareruyamtg.com/jp/k/kD08246S/


	#selective format:
	#card_type,name,quantity,price,store_url,price.date,generating_mana_type
	#selective mode:
	#"with_info", "card_only"

	#the format for get_generating_mana_of_decks.rb
	#"card_type,name,quantity,generating_mana_type"
	#mode:with_info

	#the format for get_deck_prices.rb
	#"card_type,name,quantity,price,store_url,price.date,generating_mana_type"
	#mode:with_info
		
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
			get_contents_of_all_cards
			get_sum_of_generating_manas
			@mana_analyzer.calc_sum_of_needed_mana
			File.open(filename, "w:sjis") do |file|
				set_information
				file.puts "info," + @deckname.to_s + " " + @price_of_all.to_s + " " + @sum_of_mainboard_generating_manas.to_s
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
					elsif((previous_type == "spell" || previous_type == "mainboardCards") && card.card_type == "sideboardCards") then
						@log.debug "write spell and main_board information"
						file.puts "info," + @quantity_of_spells.to_s + " Spells " + @price_of_spells.to_s					
						file.puts "info," + @quantity_of_mainboard_cards.to_s + " MainboardCards " + @price_of_mainboard_cards.to_s + " " + @mana_analyzer.sum_of_manacost_point_at_mainboard.to_s + " " + @mana_analyzer.sum_of_needed_mana_at_mainboard.to_s
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
				file.puts "info," + @quantity_of_sideboard_cards.to_s + " SideboardCards " + @price_of_sideboard_cards.to_s + " " + @mana_analyzer.sum_of_manacost_point_at_sideboard.to_s  + " " + @mana_analyzer.sum_of_needed_mana_at_sideboard.to_s
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
				card = Card.new(cardname.to_s, @log)
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



	def get_contents_of_all_cards
	#get contents of all cards. such as manacost, oracle,...
	#from dom file at ../../cards/ or http://whisper.wisdom-guild.net/
		@log.info "deck.get_contents start"
		@cards.each do |card|
			card.read_contents()
			if !File.exist?("../../cards/" + card.name.to_s) then
				card.write_contents()
			end
		end
	end


	def get_sum_of_generating_manas
	#get sum of all card's generating manas. 
	#Please execute this method after get_contents()
		@log.info @deckname.to_s + ".get_sum_of_generationg_manas() start."
		sum_of_generationg_manas = @mana_analyzer.calc_sum_of_generating_mana()
		if sum_of_generationg_manas.size == 2 then
			@sum_of_mainboard_generating_manas = sum_of_generationg_manas[0]
			@sum_of_sideboard_generating_manas = sum_of_generationg_manas[1]
		end
	end
	
	
	def set_information
	#set quantity_of_*** and price_of_*** from this.cards
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

			elsif card.card_type.to_s == "mainboardCards"
			@quantity_of_mainboard_cards += card.quantity.to_i
			@quantity_of_all += card.quantity.to_i
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
	
	
	
=begin	
	def calc_price_of_all_deck
	#calculate total price of this deck.
		@log.info "calculate_price start"
		price = 0
		@cards.each do |card|
			@log.debug card.name + ", " + card.quantity + ", " + card.price.to_s
			price += card.quantity.to_i * card.price.to_i
			@log.debug "price="+price.to_s
		end
		return price
	end
=end
	
	def calc_price_of_whole_deck
	#calculate price of each_card_type and deck.
	#such as deck.price, land, creatures, spells, MainboardCards, sideboardCards
	#using card.price, which have to be already set.
		@log.info deckname.to_s + ".calc_price_of_whole_deck start"
		if @cards.nil? then @log.error "@cards is nil at calc_price_of_each_card_type." end
		@price_of_lands = 0
		@price_of_creatures = 0
		@price_of_spells = 0
		@price_of_mainboard_cards = 0
		@price_of_sideboard_cards = 0

		@cards.each do |card|
			@price += card.price.to_i * card.quantity.to_i
			@log.debug "@price_of_all = " + @price.to_s
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
				@log.error "card_type = " + card.card_type
			end
		end
	end
end

