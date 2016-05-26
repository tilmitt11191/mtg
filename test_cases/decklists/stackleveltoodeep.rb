
#ruby
require "logger"
require '../../lib/util/deck.rb'
require '../../lib/util/store.rb'
require '../../lib/util/deck_prices.rb'

#The Error occurred when mode_of_create_cardlist = "full", on macos at 5/25/2016 .
#The purpose of this program is to identify the cause.
#
#git:(master*)workspace $ ruby ../../lib/decklists/convert_from_full_to_mo.rb
#convert_from_full_to_mo.rb start.
#/Volumes/share/program/mtg/lib/util/price.rb:50: stack level too deep (SystemStackError)
#
#The detail of convert_from_full_to_mo.rb are written on the bottom of this page.


#ruby
require "logger"

begin
	puts File.basename(__FILE__).to_s + " start."
	@log = Logger.new("../../log", 5, 10 * 1024 * 1024)
	@log.info ""
	@log.info File.basename(__FILE__).to_s + " start."
	@log.info ""

	cardnames = ["Eldrazi Displacer"]
	for i in 1..10000
		cardnames.push("Eldrazi Displacer")
	end
	@store = Hareruya.new(@log)
	@counter = 0
	cardnames.each do |cardname|
		@counter += 1
		puts @counter
		card = Card.new(cardname, @log)
		if File.exist?("../../cards/" + cardname.to_s) then
			#read local file
			@log.debug cardname.to_s + ".read_from_dom()"
			card.read_from_dom()
		else
			#get contents of card from "http://whisper.wisdom-guild.net/"
			@log.debug cardname.to_s + ".read_from_url"
			card.read_from_url("http://whisper.wisdom-guild.net/card/" + cardname.to_s + "/")
		end
		card.store_url = "http://www.hareruyamtg.com/jp/g/gOGW000013JN/"
		card.print_contents()
		card.write_contents()
		card.value =  @store.how_match?(card)
	end

rescue => e
	puts_write(e,@log)
end


@log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."



#The error occured when 9000 < ARGV < 10000
#def func(n)
#if n == 1 then
#return "hoge"
#elsif n > 1
#p n
#func(n-1)
#end
#end
#p func ARGV[0].to_i

=begin
	deckname = "Monitor_Combo_kD09885S"
	get_from = "web" #web or file
	mode_of_create_cardlist = "full"

	deck = Deck.new(deckname, "hareruya", "http://www.hareruyamtg.com/jp/k/kD09885S/",@log)
	hareruya = Hareruya.new(@log)

	case get_from
	when "web" then
		#deck.create_cardlist(mode_of_create_cardlist) #<= occurred
		#hareruya.create_card_list(deck, mode_of_create_cardlist) # <= occurred

		deck.cards = []
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
				if mode_of_create_cardlist == "full" then
					#card.price.renew_at("hareruya") # <= occurred

					@log.debug "renew at hareruya start"
					@store = Hareruya.new(@log)
					@value = @store.how_match?(card)
					@log.debug "[" + card.name.to_s + "] is [" + @value.to_s + "]"
					@date = DateTime.now
					@log.debug "date is " + @date.to_s

				end
				@log.debug "name[" + card_name.to_s + "], card_type[" + card.card_type.to_s + "], card.price[" + card.price.to_s + "]"
				deck.cards.push(card)
			end
		end
	end
=end


#@log.info File.basename(__FILE__).to_s + " finished."
#puts File.basename(__FILE__).to_s + " finished."
#class Hareruya < Store
#	def initialize(logger)
#		super("Hareruya", logger)
#		@url = "http://www.hareruyamtg.com/jp/"
#	end
#	
#	def how_match?(card)
#
#		@log.debug "hareruya.how_match?(#{card.name}) finished. price is " + price
#		return card.price # <= occurred
#	end

#class Price
#	def renew_at(card, storename)
#		#@value = @store.how_match?(card)
#		@store.how_match?(card)


####../../lib/decklists/convert_from_full_to_mo.rb####
=begin
#ruby
require "logger"
require '../../lib/util/deck.rb'
require '../../lib/util/store.rb'
require '../../lib/util/deck_prices.rb'

begin
	puts File.basename(__FILE__).to_s + " start."
	@log = Logger.new("../../log", 5, 10 * 1024 * 1024)
	@log.info ""
	@log.info File.basename(__FILE__).to_s + " start."
	@log.info ""


	deckname = "Monitor_Combo_kD09885S"
	get_from = "web" #web or file
	mode_of_create_cardlist = "full"

	deck = Deck.new(deckname, "hareruya", "http://www.hareruyamtg.com/jp/k/kD09885S/",@log)
	hareruya = Hareruya.new(@log)

	case get_from
	when "web" then
		deck.create_cardlist(mode_of_create_cardlist)
		hareruya.convert_all_cardname_from_jp_to_eng(deck)

		deck.get_contents_of_all_cards
		deck.get_sum_of_generating_manas

		if mode_of_create_cardlist == "full" then
			deck.calc_price_of_whole_deck
		end

		deck.create_deckfile("../../decks/" + deckname.to_s + ".csv", "card_type,name,quantity,manacost,generating_mana_type,price,store_url,price.date", "with_info")

		if mode_of_create_cardlist == "full" then
			deck_prices = Deck_prices.new(@log)
			deck_prices.read("../../decks/decklist.csv")
			deck_prices.add(deck)
			deck_prices.write("../../decks/decklist.csv")
		end
	when "file" then
		deck.read_deckfile("../../decks/" + deckname.to_s + ".csv", "card_type,name,quantity,manacost,generating_mana_type,price,price.date,store_url", "with_info")
		hareruya.convert_all_cardname_from_jp_to_eng(deck)
	end

	mo = MagicOnline.new(@log)
	mo.create_card_list(deck, "../../decks/magiconline/" + deckname + ".txt")


rescue => e
	puts_write(e,@log)
end


@log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."


####deck.rb####

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
		@mana_analyzer = Mana_analyzer.new(self, @log)

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
	#create @cards which is array of Card.
	#The options of "create_mode" are depend on the creator.
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
			@store = Hareruya.new(@log)
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
	
	
	def calc_num_of_all_cards_in_deck
		#this method returns the number of all cards in this deck.
		@log.info "calc_lands_in_deck(" + @deckname.to_s + ") start."
		num_of_lands = 0
		
		@cards.each do |card|
			num_of_lands += card.quantity.to_i
		end
		
		return num_of_lands
	end

	def calc_num_of_lands_in_deck
		#this method returns the number of lands in this deck.
		@log.info "calc_lands_in_deck(" + @deckname.to_s + ") start."
		num_of_lands = 0
		
		@cards.each do |card|
			if card.card_type == "land" then
				num_of_lands += card.quantity.to_i
			end
		end
		
		return num_of_lands
	end

	def calc_num_of_mainboard_cards_in_deck
		#this method returns the number of cards in mainboard of this deck.
		@log.info "calc_num_of_all_cards_in_deck(" + @deckname.to_s + ") start."
		num_of_cards = 0
		
		@cards.each do |card|
			if card.card_type != "sideboardCards" then
				num_of_cards += card.quantity.to_i
			end
		end
		
		return num_of_cards
	end
	
end









####price.rb####


require	"logger"
require 'date'
require '../../lib/util/card.rb'
require "../../lib/util/store.rb"

class Price
	include Comparable
	@log
	@value
	@date
	@store
	@card
	attr_accessor :value, :date

	def initialize(card, logger)
		@log = logger
		if card.nil? then
			@log.warn "price.initialize(nil)"
			@value = 0
			@date = nil
		else
			@log = Logger.new("../../log")
			@log.info "price of " + card.name + " initialize"
			@card = card
			@value = 0
			@date = nil
		end
	end
	
	def renew_at(storename)
		@log.debug "card.price.renew_at("+storename+")"
		case storename
		when "hareruya" then
			@log.debug "renew at hareruya start"
			@store = Hareruya.new(@log)
			@value = @store.how_match?(@card)
			@log.debug "[" + @card.name.to_s + "] is [" + @value.to_s + "]"
			@date = DateTime.now
			@log.debug "date is " + @date.to_s
		else
			@log.error "Price.renew_at(invalid store)"
			@log.error "store name is " + storename
			@value = nil
		end
	end
	
	def to_s
		if @value.nil? then
			@log.warn @card.name.to_s + ".price.to_i = nil. return nil."
			"nil"
		else
			@value.to_s
		end
	end

	def to_i
		if @value.nil? then
			@log.error @card.name.to_s + ".price.to_i = nil. return 0."
			0
		else
			@value.to_i
		end
	end

	def +(price)
		@value += price.to_i
	end

	def <=>(other)
		@value.to_f - other.to_f
	end
	

end


#### card.rb ####


require	"logger"
require "mechanize"
require 'rexml/document'
require "../../lib/util/price.rb"
require '../../lib/util/mana_analyzer.rb'


class Card
	@log
	@card_type #land,creature,spell,mainboardCards,sideboardCards ##TODO: rename to type
	@name
	@quantity #int
	@price #Price::price
	@value
	@store_url
	@generating_mana_type #if name is mountain, set "R"
	attr_accessor :name, :card_type, :quantity, :price, :value, :store_url, :generating_mana_type
	
	@manacost #string
	@manacost_array #array[string]
	@manacost_point #点数で見たマナコスト
	@type ##TODO: rename to ...
	@oracle
	@powertoughness
	@illustrator
	@rarity
	@cardset
	attr_accessor :manacost, :type, :oracle, :powertoughness, :illustrator, :rarity, :cardset
	
	def initialize(name, logger)
		@log = logger
		@log.info "Card.initialize"
		@name = name
		@price = Price.new(self, @log)
		@value = nil
		@store_url = nil
		@generating_mana_type = ""
	end
	
	def set_store_page(url)
		@log.debug "Card["+@name+"].set_store_page[" + url +"]"
		@store_url = url
	end
	
	
	def read_contents()
		#get contents of card. such as manacost, oracle,...
		@log.info @name.to_s + ".read_contents() start"
		if File.exist?("../../cards/" + @name.to_s) then
			#read local file
			read_from_dom()
		else
			#get contents of card from "http://whisper.wisdom-guild.net/"
			read_from_web()
		end
	end
	
	
	def read_from_dom()
		@log.info @name.to_s + ".read_from_dom() start"
		doc = REXML::Document.new(File.open("../../cards/" + @name.to_s))
		root = doc.elements["root"]
		if root.nil? then
			@log.warn @name.to_s + ".read_from_dom"
			@log.warn "the root of dom is nil."
			@log.warn "try read from web."
			read_from_web()
		end
		
		if root.nil? then
			@log.error @name.to_s + ".read_from_dom"
			@log.error "the root of dom is stil nil."
			@log.error "read a nil card."
			doc = REXML::Document.new(File.open("../../cards/nil"))
			root = doc.elements["root"]
		end
		
		@name= root.elements["name"].text
		@manacost= root.elements["manacost"].text
		@manacost_point= root.elements["manacost_point"].text
		@type= root.elements["type"].text
		@oracle= root.elements["oracle"].text
		@powertoughness= root.elements["powertoughness"].text
		@illustrator= root.elements["illustrator"].text
		@rarity= root.elements["rarity"].text
		@cardset= root.elements["cardset"].text
		@generating_mana_type= root.elements["generating_mana_type"].text
		
		@log.info @name.to_s + ".read_from_dom() finished"
	end
	
	def read_from_web()
		@log.info "@name.to_s + read_from_web() start"
		@log.info "get contents of card from http://whisper.wisdom-guild.net/"
		agent = Mechanize.new
		page = agent.get('http://www.wisdom-guild.net/')
		query = @name.to_s
		@log.debug "query: " + query
		page.form.q = @name.to_s
		card_page = page.form.submit
		
		if !card_page.search('tr/th.dc').text.include?("カード名") then
			@log.error "ERROR at card.read_from_web()"
			@log.error "get contents of card from http://whisper.wisdom-guild.net/"
			@log.error "cardname(" + @name.to_s + ") not hit or cannot narrow the target to one."
			File.open("../../lib/card_operation/errorlist.txt", "a") do |file|
				file.puts(@name)
			end
			return 1
		end
		
		card_page.search('tr').each do |tr|
			if(tr.search('th.dc').text == "カード名") then
				@log.debug "extract card name start."
				@log.debug tr.search('b').text
			end
			if(tr.search('th.dc').text == "マナコスト") then
				@log.debug "extract mana cost start."
				str = tr.search('td.lc').text
				@log.debug str
				extract_manacost(str)
			end
			if(tr.search('th.dc').text == "タイプ") then
				@log.debug "extract card type start."
				str = tr.search('td.mc').text
				@log.debug str
				extract_type(str)
			end
			if(tr.search('th.dc').text == "オラクル") then
				@log.debug "extract oracle start."
				str = tr.search('td.lc').text
				@log.debug str
				extract_oracle(str)
			end
			if(tr.search('th.dc').text == "Ｐ／Ｔ") then
				@log.debug "extract power/toughness start."
				str = tr.search('td.lc').text
				@log.debug str
				extract_powertoughness(str)
			end
			if(tr.search('th.dc').text == "イラスト") then
				@log.debug "extract illustrator start."
				str = tr.search('td.lc').text
				@log.debug str
				extract_illustrator(str)
			end
			if(tr.search('th.dc').text == "セット等") then
				@log.debug "extract rarity, card set start."
				str = tr.search('td.mc').text
				@log.debug str
				extract_rarity_and_cardset(str)
			end
		end
		
		set_generating_mana_type()
		@log.info "@name.to_s + read_from_web() finished"
	end


	def read_from_url(url)
		@log.info "read_from_url(" + url + ") start"
		@log.info "get contents of card from http://whisper.wisdom-guild.net/"
		agent = Mechanize.new
		card_page = agent.get(url)
						
		card_page.search('tr').each do |tr|
			if(tr.search('th.dc').text == "カード名") then
				@log.debug "extract card name start."
				@log.debug tr.search('b').text
			end
			if(tr.search('th.dc').text == "マナコスト") then
				@log.debug "extract mana cost start."
				str = tr.search('td.lc').text
				@log.debug str
				extract_manacost(str)
			end
			if(tr.search('th.dc').text == "タイプ") then
				@log.debug "extract card type start."
				str = tr.search('td.mc').text
				@log.debug str
				extract_type(str)
			end
			if(tr.search('th.dc').text == "オラクル") then
				@log.debug "extract oracle start."
				str = tr.search('td.lc').text
				@log.debug str
				extract_oracle(str)
			end
			if(tr.search('th.dc').text == "Ｐ／Ｔ") then
				@log.debug "extract power/toughness start."
				str = tr.search('td.lc').text
				@log.debug str
				extract_powertoughness(str)
			end
			if(tr.search('th.dc').text == "イラスト") then
				@log.debug "extract illustrator start."
				str = tr.search('td.lc').text
				@log.debug str
				extract_illustrator(str)
			end
			if(tr.search('th.dc').text == "セット等") then
				@log.debug "extract rarity, card set start."
				str = tr.search('td.mc').text
				@log.debug str
				extract_rarity_and_cardset(str)
			end
		end
		
		set_generating_mana_type()
		@log.info "read_from_url(" + url + ") finished."
	end


	def print_contents()
		@log.info ""
		@log.info "Card().print_contents"
		@log.info "name:"; @log.info @name
		@log.info ""
		@log.info "manacost:"; @log.info @manacost
		@log.info "manacost_point:"; @log.info @manacost_point
		@log.info "type:"; @log.info @type
		@log.info "oracle:"; @log.info @oracle
		@log.info "powertoughness:"; @log.info @powertoughness
		@log.info "illustrator:"; @log.info @illustrator
		@log.info "rarity:"; @log.info @rarity
		@log.info "cardset:"; @log.info @cardset
		@log.info "generating_mana_type:"; @log.info @generating_mana_type
		@log.info "\n"
	
	end

	
	def write_contents(dir:"../../cards/")
		@log.info "card(" + @name.to_s + ").write_contents() start."

		@log.info "create dom"
		doc = REXML::Document.new
		root = doc.add_element("root")
		root.add_element("name").add_text @name.to_s
		root.add_element("manacost").add_text @manacost.to_s
		root.add_element("manacost_point").add_text @manacost_point.to_s
		root.add_element("type").add_text @type.to_s
		root.add_element("oracle").add_text @oracle.to_s
		root.add_element("powertoughness").add_text @powertoughness.to_s
		root.add_element("illustrator").add_text @illustrator.to_s
		root.add_element("rarity").add_text @rarity.to_s
		root.add_element("cardset").add_text @cardset.to_s
		root.add_element("generating_mana_type").add_text @generating_mana_type.to_s
		
		@log.info "write dom to[" + dir.to_s + "]"
		doc.write(File.new(dir.to_s + @name.to_s, "w+"))
		@log.info "card(" + @name.to_s + ").write_contents() finished."
	end

	def extract_manacost(str)
		@manacost_array = []
		@manacost_point = 0
		symbols = str.split(")")
		symbols.each do |symbol|
			symbol.slice!("(")
			symbol.tr!("０-９", "0-9")
			symbol.tr!("白", "W")
			symbol.tr!("青", "U")
			symbol.tr!("黒", "B")
			symbol.tr!("赤", "R")
			symbol.tr!("緑", "G")
			symbol.tr!("◇", "C")
			@manacost = @manacost.to_s + symbol.to_s
			@manacost_array.push(symbol)
			if symbol =~ /^[0-9]/ then @manacost_point += symbol.to_i
			else @manacost_point += 1
			end
		end
		@log.debug "extracted from(" + str.to_s + ") to (" + @manacost.to_s + ")"
	end
	
	def extract_type(str)
		@type = str
	end
	
	def extract_oracle(str)
		@oracle = str
	end
	
	def extract_powertoughness(str)
		@powertoughness = str
	end
	
	def extract_illustrator(str)
		@illustrator = str
	end
	
	def extract_rarity_and_cardset(str)
		if str.include?(',') then
			@rarity = str.split(',')[0]
			@cardset = str.split(',')[1]
		else
			@log.error "cardname(" + @cardname.to_s + ") not include rarity or cardset"
		end
		@log.info "rarity: " + @rarity.to_s
		@log.info "cardset: " + @cardset.to_s
	end

	def set_generating_mana_type
	#set_generating_mana_type
		@log.info "card(" + name.to_s + ").set_generating_mana_type start."
		mana_analyzer = Mana_analyzer.new(nil, @log)
		@generating_mana_type = mana_analyzer.get_generating_mana_type(self)
		write_contents()
	end


	def search_card_page(card)
		
	
	end
end


class Wish_card < Card
			#Card Name,Quantity,ID #,Rarity,Set,Collector #,Premium,Sideboarded,
			#"Kalitas, Traitor of Ghet",1,59417,Mythic Rare,OGW,86/184,No,Yes
				#if (line.split("\"").size != 1) && #except head line or blank line
					#(quantity = line.split("\"")[2].split(',').size == 8) then
	@name
	@quantity
	@id
	@rarerity
	@set
	@collector_number
	@premium
	attr_accessor :name,:quantity,:id,:rarerity,:set,:collector_number,:premium
	
	def initialize(line, logger)
		@log = logger
		@log.info "Wish_card.initialize"
	#"Kalitas, Traitor of Ghet",1,59417,Mythic Rare,OGW,86/184,No,Yes
		if (line.split("\"").size != 1) && #except head line or blank line
			(quantity = line.split("\"")[2].split(',').size == 7) then
			@name = line.split("\"")[1]
			@quantity = line.split("\"")[2].split(',')[1]
			@id = line.split("\"")[2].split(',')[2]
			@rarerity = line.split("\"")[2].split(',')[3]
			@set = line.split("\"")[2].split(',')[4]
			@collector_number = line.split("\"")[2].split(',')[5]
			@premium = line.split("\"")[2].split(',')[6]
		end
	end
	
	def get_line
		return "\"" + @name.to_s + "\"," + @quantity.to_s + "," + @id.to_s + "," + @rarerity.to_s + "," + @set.to_s + "," + @collector_number.to_s + "," + @premium.to_s
	end
end



=end