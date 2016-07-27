# encoding: UTF-8
#ruby

require 'logger'
require 'test/unit'
require '../../lib/util/tests.rb' #for must
require '../../lib/util/utils.rb'
require '../../lib/site/wisdomGuild.rb'

class Test_wisdomGuild < Test::Unit::TestCase
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
		@site = WisdomGuild.new(@log)
	end
=begin
	must "extract english of Liliana, the Last Hope" do
		assert_equal 'Liliana, the Last Hope', @site.extract_english_of('最後の望み、リリアナ/Liliana, the Last Hope')
	end
	
	must "get contents of Liliana, the Last Hope from web" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		card = @site.get_card_by_cardname 'Liliana, the Last Hope'
		assert_equal 'Liliana, the Last Hope', card.name
		assert_equal '神話レア', card.rarity
		assert_equal '1BB', card.manacost
		assert_equal 3, card.manacost_point
		assert_equal 'プレインズウォーカー—リリアナ(Liliana)', card.type
		assert_equal nil, card.powertoughness
		assert_equal 'AnnaSteinbauer', card.illustrator
		assert_equal '異界月(93/205)', card.cardset
		assert_equal nil, card.generating_mana_type
	end
	
	
	must "get contents of Liliana, the Last Hope from url" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		card = @site.get_card_from_url 'http://whisper.wisdom-guild.net/card/EMN093/'
		assert_equal 'Liliana, the Last Hope', card.name
		assert_equal '神話レア', card.rarity
		assert_equal '1BB', card.manacost
		assert_equal 3, card.manacost_point
		assert_equal 'プレインズウォーカー—リリアナ(Liliana)', card.type
		assert_equal nil, card.powertoughness
		assert_equal 'AnnaSteinbauer', card.illustrator
		assert_equal '異界月(93/205)', card.cardset
		assert_equal nil, card.generating_mana_type
	end
=end
	must "get contents of Blessed Alliance, which encoding include U + 2022" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		card = @site.get_card_from_url 'http://whisper.wisdom-guild.net/card/Blessed Alliance/'
		assert_equal 'Blessed Alliance', card.name
		assert_equal 'アンコモン', card.rarity
		assert_equal '1W', card.manacost
		assert_equal 2, card.manacost_point
		assert_equal 'インスタント', card.type
		assert_equal nil, card.powertoughness
		assert_equal 'JohannBodin', card.illustrator
		assert_equal '異界月(13/205)', card.cardset
		assert_equal nil, card.generating_mana_type
		puts card.oracle.encode('Shift_JIS', :invalid => :replace, :undef => :replace, :replace => '?')
	end
	

end