# encoding: UTF-8
#ruby

require 'logger'
require 'test/unit'
require '../../lib/util/tests.rb' #for must
require '../../lib/site/hareruya.rb'

class Test_hareruya < Test::Unit::TestCase
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
		@site = Hareruya.new(@log)
	end
	
=begin
	must "initialize" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		assert_equal 'Hareruya', @site.name
		assert_equal 'http://www.hareruyamtg.com/jp/', @site.url
	end
#=end
#=begin
	must "create deck from url" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		url = 'http://www.hareruyamtg.com/jp/k/kD13230S/'
		deck = @site.create_deck_from_url(url, priceflag:'on')
		assert_equal 75, deck.calc_num_of_all_cards_in_deck
		assert_equal 26, deck.calc_num_of_lands_in_deck
		assert_equal 60, deck.calc_num_of_mainboard_cards_in_deck
		
		deck.create_deckfile('../../test_cases/site/sample_deck_WBConkD13230S.csv', 'card_type,name,quantity,price,store_url,price.date,generating_mana_type', 'with_info')
		#assert_equal #TDL
	end
=end
=begin
	must "how_match Cinder Glade" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		card = Card.new('Cinder Glade', @log)
		card.renew_price_at @site
		puts "card.price[#{card.price}] is close to 400?"
		assert_equal'http://www.hareruyamtg.com/jp/g/gBFZ000235EN/', card.store_url
	end
	
	must "how_match Nahiri, the Harbinger" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		card = Card.new('Nahiri, the Harbinger', @log)
		card.renew_price_at @site
		puts "card.price[#{card.price}] is close to 2800?"
		assert_equal'http://www.hareruyamtg.com/jp/g/gSOI000246EN/', card.store_url
	end

#=begin
	must "how_match Liliana, the Last Hope" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		card = Card.new('Liliana, the Last Hope', @log)
		card.renew_price_at @site
		puts "card.price[#{card.price}] is close to 5800?"
		assert_equal'http://www.hareruyamtg.com/jp/g/gEMN000028EN/', card.store_url
	end
#=end
#=begin
	must "how_match Emrakul, the Promised End" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		card = Card.new('Emrakul, the Promised End', @log)
		card.renew_price_at @site
		puts "card.price[#{card.price}] is close to 2500?"
		assert_equal'http://www.hareruyamtg.com/jp/g/gEMN000004EN/', card.store_url
	end
#=end
#=begin
	must "get url of Emrakul" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		card = Card.new('Emrakul, the Promised End', @log)
		url = @site.get_url_of card
		assert url_exists? url,@log
		assert_equal'http://www.hareruyamtg.com/jp/g/gEMN000004EN/',url
	end
#=end
	must "how_match Linvala, the Preserver" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		card = Card.new('Linvala, the Preserver', @log)
		card.renew_price_at @site
		puts "card.price[#{card.price}] is close to 400?"
		assert_equal'http://www.hareruyamtg.com/jp/g/gOGW000025EN/', card.store_url
	end
=end
	must "how_match no such card" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		card = Card.new('no such card', @log)
		card.renew_price_at @site
		puts "card.price[#{card.price}] is close to 400?"
		assert_equal'', card.store_url
	end
end




def analyse_htmls
	puts "#{__method__} start."
	agent = Mechanize.new
	url = 'http://www.hareruyamtg.com/jp/goods/search.aspx'
	#if !url_exists? url, @log then
	#	@log.error "site url[#{url}] not exist. return nil."
	#	return nil
	#end
	page = agent.get(url)
	puts "--field--"
	puts page.form.fields.size
	page.form.fields.each do |el|
		puts "name:" + el.name
		puts "value:" + el.value
	end
	puts "--file_uploads--"
	puts page.form.file_uploads.size
	page.form.file_uploads.each do |el|
		puts "name:" + el.name
		puts "value:" + el.value
	end
	puts "--hiddens--"
	puts page.form.hiddens.size
	page.form.hiddens.each do |el|
		puts "name:" + el.name
		puts "value:" + el.value
	end
	puts "--radiobuttons--"
	puts page.form.radiobuttons.size
	page.form.radiobuttons.each do |el|
		puts "name:" + el.name
		puts "value:" + el.value
	end
	puts "--submits--"
	puts page.form.submits.size
	page.form.submits.each do |el|
		puts "name:" + el.name
		puts "value:" + el.value
	end
	puts "--texts--"
	puts page.form.texts.size
	page.form.texts.each do |el|
		puts "name:" + el.name
		puts "value:" + el.value
	end
	#puts "--values--"
	#puts page.form.values.size
	#page.form.values.each do |el|
	#	puts "name:" + el.name
	#	puts "value:" + el.value
	#end
	puts "--resets--"
	puts page.form.resets.size
	page.form.resets.each do |el|
		puts "name:" + el.name
		puts "value:" + el.value
	end
	puts "--textareas--"
	puts page.form.textareas.size
	page.form.textareas.each do |el|
		puts "name:" + el.name
		puts "value:" + el.value
	end
	puts "--checkboxes--"
	puts page.form.checkboxes.size
	page.form.checkboxes.each do |el|
		puts "name:" + el.name
		puts "value:" + el.value
	end
	puts "cb : #{page.form.to_s}"
	puts "--buttons--"
	puts page.form.buttons.size
	page.form.buttons.each do |el|
		puts "name:" + el.name
		puts "value:" + el.value
	end
	
	#puts "--page--"
	#page.css('tr/td').each do |line|
	#	puts line.inner_text
	#end

end

#analyse_htmls
