# encoding: UTF-8
#ruby

require 'logger'
require 'test/unit'
require 'active_record'
require '../../lib/util/tests.rb' #for must
require '../../lib/util/utils.rb'
require '../../lib/util/card.rb'

class Test_card < Test::Unit::TestCase
	@site
	class << self
		def startup
			puts File.basename(__FILE__).to_s + " start."
			@log = Logger.new("../../log")
			@log.info ""
			@log.info File.basename(__FILE__).to_s + " start."
			@log.info ""
		
		end
		def shutdown
			@log.info File.basename(__FILE__).to_s + " finished."
			puts File.basename(__FILE__).to_s + " finished."
		end
	end
	
	def setup
		@log = Logger.new("../../log")
	end

#=begin
	must "read contents of Liliana, the Last Hope from sql" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."

		db_conf = YAML.load_file('../../etc/mysql_conf.yml')
		ActiveRecord::Base.establish_connection(db_conf['db']['development'])
		sql = "DELETE FROM cards WHERE name = \"\"\"Liliana, the Last Hope\"\"\";"
		ActiveRecord::Base.connection.delete sql

		card = Card.new('Liliana, the Last Hope', @log)
		assert_equal "\"Liliana, the Last Hope\"", card.name
		card.read_contents

		card2 = Card.new('Liliana, the Last Hope', @log)
		card2.read_from_sql
		assert_equal "\"Liliana, the Last Hope\"", card2.name
		assert_equal '神話レア', card2.rarity
		assert_equal '1BB', card2.manacost
		assert_equal 3, card2.manacost_point
		assert_equal 'プレインズウォーカー—リリアナ(Liliana)', card2.cardtype
		assert_equal '', card2.powertoughness
		assert_equal 'AnnaSteinbauer', card2.illustrator
		assert_equal '異界月(93/205)', card2.cardset
		assert_equal '', card2.generating_mana_type
		assert_equal "\" +1: Up to one target creature gets -2/-1 until your next turn.
-2: Put the top two cards of your library into your graveyard, then you may return a creature card from your graveyard to your hand.
-7: You get an emblem with \"\"At the beginning of your end step, put X 2/2 black Zombie creature tokens onto the battlefield, where X is two plus the number of Zombies you control.\"\"\"", card2.oracle
	
	end
#=end
#=begin
	must "read liliana from web when sql record not exist." do
		puts "#{__method__} start."
		@log.info "#{__method__} start."

		db_conf = YAML.load_file('../../etc/mysql_conf.yml')
		ActiveRecord::Base.establish_connection(db_conf['db']['development'])
		sql = "DELETE FROM cards WHERE name = \"\"\"Liliana, the Last Hope\"\"\";"
		ActiveRecord::Base.connection.delete sql

		card = Card.new('Liliana, the Last Hope', @log)
		card.read_from_sql
		
		assert_equal "\"Liliana, the Last Hope\"", card.name
		assert_equal '神話レア', card.rarity
		assert_equal '1BB', card.manacost
		assert_equal 3, card.manacost_point
		assert_equal 'プレインズウォーカー—リリアナ(Liliana)', card.cardtype
		assert_equal '', card.powertoughness
		assert_equal 'AnnaSteinbauer', card.illustrator
		assert_equal '異界月(93/205)', card.cardset
		assert_equal '', card.generating_mana_type
		assert_equal "\" +1: Up to one target creature gets -2/-1 until your next turn.
-2: Put the top two cards of your library into your graveyard, then you may return a creature card from your graveyard to your hand.
-7: You get an emblem with \"\"At the beginning of your end step, put X 2/2 black Zombie creature tokens onto the battlefield, where X is two plus the number of Zombies you control.\"\"\"", card.oracle

	end
#=end

#=begin
	must "sql has duplicated records" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		card = Card.new('Liliana, the Last Hope', @log)
		assert_equal "\"Liliana, the Last Hope\"", card.name
		
		card = Card.new('Liliana, the Last Hope', @log)
		card.read_from_dom
		card.save_to_sql

		record = Card_for_db.new(card, @log)
		record.save
		begin
			card.read_from_sql
		rescue Exception =>e
			assert_equal e.message, "sql has duplicated records of \"Liliana, the Last Hope\"."
		end
		
		@log.info "delete duplicated record"
		sql = "DELETE FROM cards WHERE name = \"\"\"Liliana, the Last Hope\"\"\";"
		ActiveRecord::Base.connection.delete sql

	end
#=end
#=begin
	must "save Liliana to sql" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."

		#create sample card
		card = Card.new('Liliana, the Last Hope', @log)
		card.read_from_dom
		card.save_to_sql

		#establish connection to db
		db_conf = YAML.load_file('../../etc/mysql_conf.yml')
		ActiveRecord::Base.establish_connection(db_conf['db']['development'])
		records = Card_for_db.where(name: "#{card.name}")
		assert_equal 1, records.size
		assert_equal "{name=>\"Liliana, the Last Hope\", price=>0, date=>, store_url=>, generating_mana_type=>, manacost=>1BB, color=>black, manacost_point=>3, cardtype=>プレインズウォーカー—リリアナ(Liliana), oracle=>\" +1: Up to one target creature gets -2/-1 until your next turn.
-2: Put the top two cards of your library into your graveyard, then you may return a creature card from your graveyard to your hand.
-7: You get an emblem with \"\"At the beginning of your end step, put X 2/2 black Zombie creature tokens onto the battlefield, where X is two plus the number of Zombies you control.\"\"\", powertoughness=>, illustrator=>AnnaSteinbauer, rarity=>神話レア, cardset=>異界月(93/205)", records[0].to_s
	end
#=end

#=begin
	must "create nil card" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		card = Card.new('no such card', @log)
		card.read_from_dom
		assert_equal "\"no such card\"", card.name
		assert_equal '', card.cardtype
	end
#=end
#=begin
	must "read contents of Liliana, the Last Hope from dom, dom file was created by previous test" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		
		card = Card.new('Liliana, the Last Hope', @log)
		assert_equal "\"Liliana, the Last Hope\"", card.name
		
		card.read_from_dom
		
		assert_equal "\"Liliana, the Last Hope\"", card.name
		assert_equal '神話レア', card.rarity
		assert_equal '1BB', card.manacost
		assert_equal 3, card.manacost_point
		assert_equal 'プレインズウォーカー—リリアナ(Liliana)', card.cardtype
		assert_equal '', card.powertoughness
		assert_equal 'AnnaSteinbauer', card.illustrator
		assert_equal '異界月(93/205)', card.cardset
		assert_equal '', card.generating_mana_type
		assert_equal "\" +1: Up to one target creature gets -2/-1 until your next turn.
-2: Put the top two cards of your library into your graveyard, then you may return a creature card from your graveyard to your hand.
-7: You get an emblem with \"\"At the beginning of your end step, put X 2/2 black Zombie creature tokens onto the battlefield, where X is two plus the number of Zombies you control.\"\"\"", card.oracle
	end
#=end
#=begin
	must "read contents of Liliana, the Last Hope from dom, dom file not exist" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		name = 'Liliana, the Last Hope'
		if File.exist?("../../cards/#{unescape_double_quote(name)}") then
			@log.info 'delete file'
			File.unlink "../../cards/#{unescape_double_quote(name)}"
		end

		card = Card.new(name, @log)
		assert_equal "\"Liliana, the Last Hope\"", card.name

		card.read_from_dom

		assert_equal "\"Liliana, the Last Hope\"", card.name
		assert_equal '神話レア', card.rarity
		assert_equal '1BB', card.manacost
		assert_equal 3, card.manacost_point
		assert_equal 'プレインズウォーカー—リリアナ(Liliana)', card.cardtype
		assert_equal '', card.powertoughness
		assert_equal 'AnnaSteinbauer', card.illustrator
		assert_equal '異界月(93/205)', card.cardset
		assert_equal '', card.generating_mana_type
		assert_equal "\" +1: Up to one target creature gets -2/-1 until your next turn.
-2: Put the top two cards of your library into your graveyard, then you may return a creature card from your graveyard to your hand.
-7: You get an emblem with \"\"At the beginning of your end step, put X 2/2 black Zombie creature tokens onto the battlefield, where X is two plus the number of Zombies you control.\"\"\"", card.oracle
	end
#=end
#=begin
	must "read contents of Liliana, the Last Hope from web" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		card = Card.new('Liliana, the Last Hope', @log)
		assert_equal "\"Liliana, the Last Hope\"", card.name
		card.read_from_web
		assert_equal "\"Liliana, the Last Hope\"", card.name
		assert_equal '神話レア', card.rarity
		assert_equal '1BB', card.manacost
		assert_equal 3, card.manacost_point
		assert_equal 'プレインズウォーカー—リリアナ(Liliana)', card.cardtype
		assert_equal '', card.powertoughness
		assert_equal 'AnnaSteinbauer', card.illustrator
		assert_equal '異界月(93/205)', card.cardset
		assert_equal '', card.generating_mana_type
		assert_equal "\" +1: Up to one target creature gets -2/-1 until your next turn.
-2: Put the top two cards of your library into your graveyard, then you may return a creature card from your graveyard to your hand.
-7: You get an emblem with \"\"At the beginning of your end step, put X 2/2 black Zombie creature tokens onto the battlefield, where X is two plus the number of Zombies you control.\"\"\"", card.oracle
	end
#=end
	must "read contents of  Blessed Alliance from web" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		card = Card.new("\"Blessed Alliance\"", @log)
		card.store_url = 'http://whisper.wisdom-guild.net/card/Blessed Alliance/'
		card.read_from_web
		assert_equal "\"Blessed Alliance\"", card.name
		assert_equal 'アンコモン', card.rarity
		assert_equal '1W', card.manacost
		assert_equal 2, card.manacost_point
		assert_equal 'インスタント', card.cardtype
		assert_equal '', card.powertoughness
		assert_equal 'JohannBodin', card.illustrator
		assert_equal '異界月(13/205)', card.cardset
		assert_equal '', card.generating_mana_type
		assert_equal "\"Escalate {2} （Pay this cost for each mode chosen beyond the first.）
Choose one or more ---
• Target player gains 4 life.
• Untap up to two target creatures.
• Target opponent sacrifices an attacking creature.\"", card.oracle
	end
#=begin	
	must "read contents of Falkenrath Reaver, which oracle is nil" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		card = Card.new("\"Falkenrath Reaver\"", @log)
		card.store_url = 'http://whisper.wisdom-guild.net/card/Falkenrath Reaver/'
		card.read_from_web
		assert_equal "\"Falkenrath Reaver\"", card.name
		assert_equal "\"\"", card.oracle
	end

	must "decide_color of land" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		card = Card.new('Nephalia Academy', @log)
		card.read_from_web
		assert_equal 'land', card.color
	end

	must "decide_color of colorless" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		card = Card.new('Abundant Maw', @log)
		card.read_from_web
		assert_equal 'colorless', card.color
	end

	must "decide_color of mono-white" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		card = Card.new('Blessed Alliance', @log)
		card.read_from_web
		assert_equal 'white', card.color
	
	end

	must "decide_color of mono-blue" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		card = Card.new('', @log)
		card.read_from_web
		assert_equal '', card.color
	
	end

	must "decide_color of mono-black" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		card = Card.new('', @log)
		card.read_from_web
		assert_equal '', card.color
	
	end

	must "decide_color of mono-red" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		card = Card.new('', @log)
		card.read_from_web
		assert_equal '', card.color
	end

	must "decide_color of mono-green" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		card = Card.new('', @log)
		card.read_from_web
		assert_equal '', card.color	
	end

	must "decide_color of multicolor" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		card = Card.new('Tamiyo, Field Researcher', @log)
		card.read_from_web
		assert_equal 'multi', card.color	
	end


	must "get price from mtgotraders" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		require '../../lib/site/mtgotraders.rb'
		site = MTGOtraders.new(@log)
		card = Card.new('Liliana, the Last Hope', @log)
		card.renew_price_at site
		puts "card.price #{card.price} is near 37.40?"
		assert card.price > 0
	end
#=end

	must "save Nahiri's Wrath to sql" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."

		card = Card.new("Nahiri's Wrath", @log)
		assert_equal "\"Nahiri's Wrath\"", card.name
		card.read_contents
		
		card2 = Card.new("Nahiri's Wrath", @log)
		assert_equal "\"Nahiri's Wrath\"", card2.name
		card2.read_from_sql
		
		assert_equal "\"Nahiri's Wrath\"", card2.name
		assert_equal '神話レア', card2.rarity
		assert_equal '2R', card2.manacost
		assert_equal 3, card2.manacost_point
		assert_equal 'ソーサリー', card2.cardtype
		assert_equal '', card2.powertoughness
		assert_equal 'ChrisRahn', card2.illustrator
		assert_equal '異界月(137/205)', card2.cardset
		assert_equal '', card2.generating_mana_type
		assert_equal "\"As an additional cost to cast Nahiri's Wrath, discard X cards.
Nahiri's Wrath deals damage equal to the total converted mana cost of the discarded cards to each of up to X target creatures and/or planeswalkers.\"", card2.oracle

	end
end