# encoding: UTF-8
#ruby

require 'logger'
require 'test/unit'
require '../../lib/util/tests.rb' #for must
require '../../lib/util/utils.rb'
require '../../lib/site/channelfireball.rb'
require '../../lib/util/web.rb'

class Test_channelfireball < Test::Unit::TestCase
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
		@site = Channelfireball.new(@log)
	end
=begin
	must "get_limited_set_reviews with emn white " do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		outputfilename = '../../test_cases/workspace/output/output.csv'
		urls = ["http://www.channelfireball.com/articles/eldritch-moon-limited-set-review-white/"]
		@site.get_limited_set_reviews outputfilename, urls
		assert_equal 35, @site.cardnames.size
		
		assert_equal @site.scores['Borrowed Grace'], '2.0'
		assert_equal @site.comments['Borrowed Grace'], 'I’m not a fan of Trumpet Blast. But Borrowed Grace will be Trumpet Blast when Trumpet Blast is good (a.k.a. lethal). It gives your team the full +2/+2 when the game stalls out, and every now and then it will save a creature for 3 mana. Escalate is a powerful ability, and Borrowed Grace is a very good version of what it does.Not every deck will be interested in Borrowed Grace, and it’s not the type of card you’ll want more than 1 or 2 copies of. But when you have an aggressive, white, creature-swarm deck, Borrowed Grace will be a great addition.'
	end
=end
	must "get_limited_set_reviews with incorrect url" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		outputfilename = '../../test_cases/workspace/output/output.csv'
		urls = [""]
		@site.get_limited_set_reviews outputfilename, urls
		assert_equal 0, @site.cardnames.size
	end
	
	must "extract cardnames from emn white" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		@web = Web.new
		html = @web.get_dom_of("http://www.channelfireball.com/articles/eldritch-moon-limited-set-review-white/", @log)
		@site.extract_cardnames_from(html)
		assert_equal 38, @site.cardnames.size
	end
	
	must "remove invalid cards of emn white" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		@web = Web.new
		html = @web.get_dom_of("http://www.channelfireball.com/articles/eldritch-moon-limited-set-review-white/", @log)
		@site.extract_cardnames_from(html)
		@site.remove_invalid_names
		assert_equal 35, @site.cardnames.size
	end

	must "when cardnames is blank" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		assert @site.cardnames_is_blank
	end

	must "extract scores and comments of cardname from emn white html" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		@web = Web.new
		html = @web.get_dom_of("http://www.channelfireball.com/articles/eldritch-moon-limited-set-review-white/", @log)
		@site.extract_cardnames_from(html)
		@site.remove_invalid_names
		@site.extract_scores_and_comments_of('Borrowed Grace', html)
		puts '---- scores ----'
		puts @site.scores['Borrowed Grace']
		puts '---- comments ----'
		puts @site.comments['Borrowed Grace']
		
		assert_equal @site.scores['Borrowed Grace'], '2.0'
		assert_equal @site.comments['Borrowed Grace'], 'I’m not a fan of Trumpet Blast. But Borrowed Grace will be Trumpet Blast when Trumpet Blast is good (a.k.a. lethal). It gives your team the full +2/+2 when the game stalls out, and every now and then it will save a creature for 3 mana. Escalate is a powerful ability, and Borrowed Grace is a very good version of what it does.Not every deck will be interested in Borrowed Grace, and it’s not the type of card you’ll want more than 1 or 2 copies of. But when you have an aggressive, white, creature-swarm deck, Borrowed Grace will be a great addition.'
	end

	must "extract scores and comments of Harmless Offering from emn red html" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		@web = Web.new
		html = @web.get_dom_of("http://www.channelfireball.com/articles/eldritch-moon-limited-set-review-red/", @log)
		@site.extract_cardnames_from(html)
		@site.remove_invalid_names
		@site.extract_scores_and_comments_of('Harmless Offering', html)
		puts '---- scores ----'
		puts @site.scores['Harmless Offering']
		puts '---- comments ----'
		puts @site.comments['Harmless Offering']
		
		assert_equal '0.0', @site.scores['Harmless Offering']
		assert_equal 'Limited Rating: 0.0This is what my teammate Andrew Cuneo would call “a sideboard card.”Me: But Andrew, when would you sideboard this in?Andrew: I wouldn’t. I’d rather have it in my sideboard than in my deck.', @site.comments['Harmless Offering']
	end


	must "output limited set reviews to workspace/output.csv" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		outputfilename = '../../test_cases/workspace/output/output.csv'
		cardname = 'Blessed Alliance'
		@site.cardnames.push cardname
		@site.scores[cardname] = '2.5'
		@site.comments[cardname] = 'test'
		@site.output_limited_set_reviews_to outputfilename
		
		name = File.read(outputfilename).split(',')[0]
		score = File.read(outputfilename).split(',')[1]
		comment = File.read(outputfilename).split(',')[2]
		assert_equal name, "\"Blessed Alliance\""
		assert_equal score, "2.5"
		assert_equal comment, "\"test\"\n"
	end

	must "extract scores and comments of Boon of Emrakul from emn red html" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		@web = Web.new
		html = @web.get_dom_of("http://www.channelfireball.com/articles/eldritch-moon-limited-set-review-black/", @log)
		@site.extract_cardnames_from(html)
		@site.remove_invalid_names
		@site.extract_scores_and_comments_of('Boon of Emrakul', html)
		puts '---- scores ----'
		puts @site.scores['Boon of Emrakul']
		puts '---- comments ----'
		puts @site.comments['Boon of Emrakul']
		
		assert_equal @site.scores['Boon of Emrakul'], '2.5'
		assert_equal @site.comments['Boon of Emrakul'], 'Boon of Emrakul is a solid removal spell. It’s sorcery speed and can’t kill giant monsters, but it will do a nice job taking out most creatures that cost less than 5 mana. This is the type of card you really want a copy or 2 of to keep your opponent from punking you out with an evasion creature, or dominating the board with a Sigardian Priest.Naturally, you’d rather have all Murders and Dead Weights, but the world we live in is one in which we typically have to make due with non-premium removal. As far as non-premium removal goes, Boon of Emrakul is reliable and affordable, and should earn moderately high draft picks.The combo with Ironclad Slayer might prove to be a driving force in BW.\n'
	end
	#Collective Effort
	#Repel the Abominable
	#Thalia's Lancers
	#’->'
end



