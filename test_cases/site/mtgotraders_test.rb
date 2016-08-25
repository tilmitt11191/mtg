# encoding: UTF-8
#ruby

require 'logger'
require 'test/unit'
require '../../lib/util/tests.rb' #for must
require '../../lib/util/utils.rb'
require '../../lib/site/mtgotraders.rb'

class TEST_MTGOtraders < Test::Unit::TestCase
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
		@site = MTGOtraders.new(@log)
	end

=begin
	must "how match relevant test" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		card = Card.new('Liliana, the Last Hope', @log)
		assert_equal "\"Liliana, the Last Hope\"", card.name
		card.read_contents
		@site.search_option='relevant'
		card.renew_price_at @site
		puts "price[#{card.price}] is close to [38]?"
		puts "date[#{card.date}] is close to [#{DateTime.now}]?"
		assert_equal 'http://www.mtgotraders.com/store/search.php?q=%22Liliana%2C+the+Last+Hope%22&sortby=relevancy', card.store_url
	end

	must "how match highest test" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		card = Card.new('Liliana, the Last Hope', @log)
		assert_equal "\"Liliana, the Last Hope\"", card.name
		card.read_contents
		@site.search_option='highest'
		card.renew_price_at @site
		puts "price[#{card.price}] is close to [108]?"
		puts "date[#{card.date}] is close to [#{DateTime.now}]?"
		assert_equal 'http://www.mtgotraders.com/store/search.php?q=%22Liliana%2C+the+Last+Hope%22&sortby=price_desc', card.store_url
	end

	must "how match lowest test" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		card = Card.new('Liliana, the Last Hope', @log)
		assert_equal "\"Liliana, the Last Hope\"", card.name
		card.read_contents
		@site.search_option='lowest'
		card.renew_price_at @site
		puts "price[#{card.price}] is close to [108]?"
		puts "date[#{card.date}] is close to [#{DateTime.now}]?"
		assert_equal 'http://www.mtgotraders.com/store/search.php?q=%22Liliana%2C+the+Last+Hope%22&sortby=price', card.store_url
	end
#=end
#=begin
	must "how_match when url is nil" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		card = Card.new('Liliana, the Last Hope', @log)
		assert_equal "\"Liliana, the Last Hope\"", card.name
		card.store_url = ''
		@site.search_option='relevant'
		card.price = @site.how_match card
		puts "price[#{card.price}] is close to [38]?"
		puts "date[#{card.date}] is close to [#{DateTime.now}]?"
		assert_equal 'http://www.mtgotraders.com/store/search.php?q=%22Liliana%2C+the+Last+Hope%22&sortby=relevancy', card.store_url
	end
	
	must "how_match when url is invalid" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		card = Card.new('Liliana, the Last Hope', @log)
		assert_equal "\"Liliana, the Last Hope\"", card.name
		card.store_url = 'http://www'
		@site.search_option='relevant'
		card.price = @site.how_match card
		puts "price[#{card.price}] is close to [38]?"
		puts "date[#{card.date}] is close to [#{DateTime.now}]?"
		assert_equal 'http://www.mtgotraders.com/store/search.php?q=%22Liliana%2C+the+Last+Hope%22&sortby=relevancy', card.store_url	
	end
=end
	must "how_match when cardname is invalid" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		card = Card.new('no such card', @log)
		assert_equal "\"no such card\"", card.name
		@site.search_option='relevant'
		card.price = @site.how_match card
		assert_equal nil, card.price.to_s
		puts "date[#{card.date}] is close to [#{DateTime.now}]?"
		assert_equal nil, card.store_url	
	end
end