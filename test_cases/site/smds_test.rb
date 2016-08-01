# encoding: UTF-8
#ruby

require 'logger'
require 'test/unit'
require '../../lib/util/tests.rb' #for must
require '../../lib/util/utils.rb'
require '../../lib/site/smds.rb'
require '../../lib/util/web.rb'
require '../../lib/util/store.rb'

class Test_SMDS < Test::Unit::TestCase
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
		@site = SMDS.new(@log)
	end

	must "create pointranking list of emn" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		outputfilename = '../../test_cases/workspace/output/output.csv'
		url = 'http://syunakira.com/smd/pointranking/index.php?packname=EldritchMoom&language=Japanese'
		packname_short = 'EMN'
		@site.create_pointranking_list(outputfilename, url, packname_short)
		#assert line num 205
	end

	must "create pointranking list of incorrect url" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		outputfilename = '../../test_cases/workspace/output/output.csv'
		url = ""		
		packname_short = 'EMN'
		assert !@site.create_pointranking_list(outputfilename, url, packname_short)
	end

	must "get_cardnames_and_scores" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		@site.database = WisdomGuild.new(@log)
		url = 'http://syunakira.com/smd/pointranking/index.php?packname=EldritchMoom&language=Japanese'
		packname_short = 'EMN'
		@site.html = @site.web.get_dom_of(url, @log)
		@site.get_cardnames_and_scores packname_short
		assert_equal @site.cardnames.size, 205
		assert_equal @site.scores.size, 205
	end

	must "get_cardname_by_number" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		@site.database = WisdomGuild.new(@log)
		number = "093"
		packname_short = 'EMN'
		assert_equal 'Liliana, the Last Hope', @site.get_cardname_by_number(number, packname_short)
	end

	must "nonbasicland card can be set?" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		cardname = 'Liliana, the Last Hope'
		score = "10"
		number = "093"
		@site.add_to_array cardname, score, number
		assert_equal 1, @site.cardnames.size
	end

	must "basicland doesn't be set?" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		cardname = false
		score = "0.4"
		number = "220"
		@site.add_to_array cardname, score, number
		assert_equal 0, @site.cardnames.size
	end

end



