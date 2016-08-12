# encoding: UTF-8
#ruby

require	"logger"
require "mechanize"
require 'rexml/document'
require 'active_support/core_ext/object' #for blank?
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
	@color
	@manacost_array #array[string]
	@manacost_point #点数で見たマナコスト
	@type ##TODO: rename to ...
	@oracle
	@powertoughness
	@illustrator
	@rarity
	@cardset
	attr_accessor :manacost, :color, :manacost_array, :manacost_point, :type, :oracle, :powertoughness, :illustrator, :rarity, :cardset
	
	def initialize(name, logger)
		@log = logger
		@log.info "Card.initialize"
		@name = escape_by_double_quote name,@log
		@price = Price.new(self, @log)
		@value = ''
		@store_url = ''
		@generating_mana_type = ''

		@manacost = ''
		@color = ''
		@manacost_array = []
		@manacost_point = ''
		@type = ''
		@oracle = ''
		@powertoughness = ''
		@illustrator = ''
		@rarity = ''
		@cardset = ''
	end
	
	def create_nil_card
		@log.info "#{__method__} start."
		@price = Price.new(self, @log)
		@value = ''
		@store_url = ''
		@generating_mana_type = ''

		@manacost = ''
		@color = ''
		@manacost_array = []
		@manacost_point = ''
		@type = ''
		@oracle = ''
		@powertoughness = ''
		@illustrator = ''
		@rarity = ''
		@cardset = ''
		@log.info "#{__method__} finished."	
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

	def extract_contents_from_dom(dom_root)
		@log.info "#{__method__} start."
		if dom_root.nil? then
			@log.warn "dom_root.nil"
			create_nil_card
			return 1
		end
		
		@name = escape_by_double_quote dom_root.elements["name"].text, @log
		@manacost = dom_root.elements["manacost"].text || ''
		@manacost_point = dom_root.elements["manacost_point"].text || ''
		@type = dom_root.elements["type"].text || ''
		@oracle = escape_by_double_quote dom_root.elements["oracle"].text,@log || ''
		@powertoughness = dom_root.elements["powertoughness"].text || ''
		@illustrator = dom_root.elements["illustrator"].text || ''
		@rarity = dom_root.elements["rarity"].text || ''
		@cardset = dom_root.elements["cardset"].text || ''
		@generating_mana_type = dom_root.elements["generating_mana_type"].text || ''
		@log.info "#{__method__} finished."
	end
	
	
	def read_from_dom()
		@log.info @name.to_s + ".read_from_dom() start"
		if File.exist?("../../cards/" + unescape_double_quote(@name.to_s)) then
			@log.debug "../../cards/#{unescape_double_quote(@name.to_s)} exist.read it."
			f = File.open("../../cards/" + unescape_double_quote(@name.to_s),'r+')
			doc = REXML::Document.new(f)

			if doc.nil? then
				@log.warn "file[#{unescape_double_quote(@name.to_s)} exists, but doc is nil.create nil card."
				create_nil_card
			else
				root = doc.elements["root"]
				extract_contents_from_dom root
			end
		else
			@log.debug @name.to_s + ".read_from_dom"
			@log.debug "../../cards/#{unescape_double_quote(@name.to_s)} not exist.read from web."
			@log.debug "the root of dom is nil."
			@log.debug "try to read from web."
			read_from_web()
		end
		
		@log.info @name.to_s + ".read_from_dom() finished"
	end

	
	def read_from_web()
		@log.info "@name.to_s + read_from_web() start"
		@log.info "get contents of card from http://whisper.wisdom-guild.net/"
		agent = Mechanize.new
		page = agent.get('http://www.wisdom-guild.net/')
		query = unescape_double_quote @name.to_s
		@log.debug "query: " + query
		page.form.q = unescape_double_quote @name.to_s
		card_page = page.form.submit
		
		if !card_page.search('tr/th.dc').text.include?("カード名") then
			@log.error "ERROR at card.read_from_web()"
			@log.error "get contents of card from http://whisper.wisdom-guild.net/"
			@log.error "cardname(" + @name.to_s + ") not hit or cannot narrow the target to one."
			File.open("../../lib/card_operation/errorlist.txt", "a") do |file|
				file.puts(@name)
			end
			create_nil_card
			return 1
		end
		
		parse_card_page card_page
		set_generating_mana_type()

		@log.info "@name.to_s + read_from_web() finished"
	end


	def read_from_url(url)
		@log.info "read_from_url(" + url + ") start"
		@log.info "get contents of card from http://whisper.wisdom-guild.net/"
		agent = Mechanize.new
		card_page = agent.get(url)
		
		parse_card_page card_page
		set_generating_mana_type

		@log.info "read_from_url(" + url + ") finished."
	end


	def parse_card_page card_page
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
		@log.info "card.write_contents() to #{dir}#{@name.to_s} start."

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
		f = File.new(dir.to_s + unescape_double_quote(@name.to_s), "w+")
		f.flock(File::LOCK_EX)
		doc.write(f)
		f.flock(File::LOCK_UN)
		@log.info "card(" + unescape_double_quote(@name.to_s) + ").write_contents() finished."
	end

	def extract_manacost(str)
		@manacost = ""
		@manacost_array = []
		@manacost_point = 0
		symbols = str.split(")")
		symbols.each do |symbol|
			@log.debug "symbol[#{symbol}]"
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
		@manacost_point = @manacost_point.to_s
		decide_color
		
		@log.debug "extracted from(" + str.to_s + ") to (" + @manacost.to_s + ")"
	end
	
	def decide_color
		if @manacost.blank? then
			@color = 'land'
			@log.debug "@color[#{@color}]"
		elsif @manacost.match(/^Ｘ{0,}[0-9]{0,}$/) then
			@color = 'colorless'
			@log.debug "@color[#{@color}]"
		elsif @manacost.match(/^Ｘ{0,}[0-9]{0,}W{0,}$/) then
			@color = 'white'			
			@log.debug "@color[#{@color}]"
		elsif @manacost.match(/^Ｘ{0,}[0-9]{0,}U{0,}$/) then
			@color = 'blue'			
			@log.debug "@color[#{@color}]"
		elsif @manacost.match(/^Ｘ{0,}[0-9]{0,}B{0,}$/) then
			@color = 'black'			
			@log.debug "@color[#{@color}]"
		elsif @manacost.match(/^Ｘ{0,}[0-9]{0,}R{0,}$/) then
			@color = 'red'			
			@log.debug "@color[#{@color}]"
		elsif @manacost.match(/^Ｘ{0,}[0-9]{0,}G{0,}$/) then
			@color = 'green'			
			@log.debug "@color[#{@color}]"
		else
			@color = 'multi'			
			@log.debug "@color[#{@color}]"
		end
	end
	
	def extract_type(str)
		@type = str.gsub(/\n|\s/,"") || ''
	end
	
	def extract_oracle(str)
		@oracle = escape_by_double_quote str, @log
	end
	
	def extract_powertoughness(str)
		@powertoughness = str || ''
	end
	
	def extract_illustrator(str)
		@illustrator = str.gsub(/\n|\s/,"") || ''
	end
	
	def extract_rarity_and_cardset(str)
		if str.include?(',') then
			@rarity = str.split(',')[0]
			@cardset = str.split(',')[1].gsub(/\n|\s/,"")
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
		@generating_mana_type = mana_analyzer.get_generating_mana_type(self) || ''
		write_contents()
	end


=begin
	def get_price_by site
		puts "#{__method__} start."
		if site.respond_to?(:how_match) then
			site.how_match self
		else
			@log.fatal "#{site} not have method(:how_match)"
			puts "#{__method__} finished."
		end
	end
=end
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
			@name = escape_by_double_quote line.split("\"")[1]
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
