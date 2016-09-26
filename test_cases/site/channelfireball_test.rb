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
	must "get_limited_set_reviews with incorrect url" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		outputfilename = '../../test_cases/workspace/output/output.csv'
		urls = [""]
		@site.get_limited_set_reviews outputfilename, urls
		assert_equal 0, @site.cardnames.size
	end
=end
=begin
	must "extract cardnames from emn white" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		@web = Web.new
		html = @web.get_dom_of("http://www.channelfireball.com/articles/eldritch-moon-limited-set-review-white/", @log)
		@site.extract_cardnames_from(html)
		assert_equal 35, @site.cardnames.size
	end
=end
=begin
	must "extract cardnames from emn red" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		@web = Web.new
		html = @web.get_dom_of("http://www.channelfireball.com/articles/eldritch-moon-limited-set-review-red/", @log)
		@site.extract_cardnames_from(html)
		assert_equal 35, @site.cardnames.size
	end
=end
=begin	
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
#=end
#=begin
	must "extract scores and comments of cardname from emn white html" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		@web = Web.new
		html = @web.get_dom_of("http://www.channelfireball.com/articles/eldritch-moon-limited-set-review-white/", @log)
		@site.extract_cardnames_from(html)
		@site.remove_invalid_names
		@site.extract_scores_and_comments_of('Borrowed Grace', html)
		
		assert_equal @site.scores['Borrowed Grace'], '2.0'
		assert_equal @site.comments['Borrowed Grace'], 'I’m not a fan of Trumpet Blast. But Borrowed Grace will be Trumpet Blast when Trumpet Blast is good (a.k.a. lethal). It gives your team the full +2/+2 when the game stalls out, and every now and then it will save a creature for 3 mana. Escalate is a powerful ability, and Borrowed Grace is a very good version of what it does.Not every deck will be interested in Borrowed Grace, and it’s not the type of card you’ll want more than 1 or 2 copies of. But when you have an aggressive, white, creature-swarm deck, Borrowed Grace will be a great addition.'
	end
=end
=begin
	must "extract scores and comments of Harmless Offering from emn red html" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		@web = Web.new
		html = @web.get_dom_of("http://www.channelfireball.com/articles/eldritch-moon-limited-set-review-red/", @log)
		@site.extract_cardnames_from(html)
		@site.remove_invalid_names
		@site.extract_scores_and_comments_of('Harmless Offering', html)
		
		assert_equal '0.0', @site.scores['Harmless Offering']
		assert_equal 'This is what my teammate Andrew Cuneo would call “a sideboard card.”', @site.comments['Harmless Offering']
	end
=end
=begin
	must "output limited set reviews to workspace/output/output.csv" do
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
=end
=begin
	must "extract scores and comments of Boon of Emrakul from emn black html" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		@web = Web.new
		html = @web.get_dom_of("http://www.channelfireball.com/articles/eldritch-moon-limited-set-review-black/", @log)
		@site.extract_cardnames_from(html)
		@site.remove_invalid_names
		@site.extract_scores_and_comments_of('Boon of Emrakul', html)
		
		assert_equal @site.scores['Boon of Emrakul'], '2.5'
		assert_equal @site.comments['Boon of Emrakul'], 'Boon of Emrakul is a solid removal spell. It’s sorcery speed and can’t kill giant monsters, but it will do a nice job taking out most creatures that cost less than 5 mana. This is the type of card you really want a copy or 2 of to keep your opponent from punking you out with an evasion creature, or dominating the board with a Sigardian Priest.Naturally, you’d rather have all Murders and Dead Weights, but the world we live in is one in which we typically have to make due with non-premium removal. As far as non-premium removal goes, Boon of Emrakul is reliable and affordable, and should earn moderately high draft picks.The combo with Ironclad Slayer might prove to be a driving force in BW.'
	end
=end
=begin
	must "extract scores and comments of Collective Effort from emn white html" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		@web = Web.new
		html = @web.get_dom_of("http://www.channelfireball.com/articles/eldritch-moon-limited-set-review-white/", @log)
		@site.extract_cardnames_from(html)
		@site.extract_scores_and_comments_of('Collective Effort', html)
		
		assert_equal @site.scores['Collective Effort'], '4.0'
		assert_equal @site.comments['Collective Effort'], 'You’ll most commonly use the Smite the Monstrous and the “Nissa -2” modes on Collective Effort. In doing so, you combine a solid removal spell with a free, permanent power and toughness bonus to your whole team. The result is a great Limited card. The ability to sometimes tack on destroying an enchantment is just gravy!'
	end
=end
=begin
	must "extract scores and comments of Thalia's Lancers from emn white html" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		@web = Web.new
		html = @web.get_dom_of("http://www.channelfireball.com/articles/eldritch-moon-limited-set-review-white/", @log)
		@site.extract_cardnames_from(html)
		@site.extract_scores_and_comments_of('Thalia’s Lancers', html)

		assert_equal @site.scores['Thalia’s Lancers'], '2.5/4.5'
		assert_equal @site.comments['Thalia’s Lancers'], 'Thalia’s Lancers require things to have gone pretty well for you before they can be at their most powerful—both the floor and the ceiling are pretty high in terms of their power level. 5 mana for a 4/4 first strike usually makes the cut in your draft deck on its own. If you add searching for your bomb rare onto that, then you have something really special.Given something like a Bruna, the Fading Light to search for, Thalia’s Lancers easily earns a 4.5 rating. If you have nothing to search for, it’s somewhere in the 2.0-2.5 range. My “pack 1 pick 1 rating” is a 3.0. When possible, you want to keep yourself open for the chance of getting lucky.'
	end
=end
=begin
	must "extract scores and comments of Repel the Abominable from emn white html" do
		#not marked by <h1>
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		@web = Web.new
		html = @web.get_dom_of("http://www.channelfireball.com/articles/eldritch-moon-limited-set-review-white/", @log)
		@site.extract_cardnames_from(html)
		@site.extract_scores_and_comments_of('Repel the Abominable', html)

		assert_equal @site.scores['Repel the Abominable'], nil
		assert_equal @site.comments['Repel the Abominable'], nil
	end
=end
#=begin
		must "extract scores and comments of Skysovereign, Consul Flagship from KLD artifacts html" do
		#<h1>Prakhata Pillar-Bug</h1>
		#<h1><strong>Prophetic Prism</strong></h1>
		#<h1><strong>Skysovereign, Consul Flagship</strong></h1>
		
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		@web = Web.new
		html = @web.get_dom_of("http://www.channelfireball.com/articles/ehttp://www.channelfireball.com/articles/kaladesh-limited-set-review-artifacts/", @log)
		@site.extract_cardnames_from(html)
		@site.extract_scores_and_comments_of('Skysovereign, Consul Flagship', html)
		assert_equal '5.0', @site.scores['Skysovereign, Consul Flagship']
		assert_equal 'Welp. There’s a reason this is the flagship Vehicle of the set, as it provides a ton of power at a very reasonable cost. Even if you never crew it, it’s a 5-mana deal 3, which is passable, and if it ever takes flight you get to destroy your opponent. I’d slam Consul Flagship and make sure I had ample crew, then I would collect my profits.', @site.comments['Skysovereign, Consul Flagship']
	end
#=end
#=begin
		must "extract scores and comments of Accomplished Automaton from KLD artifacts html" do
		puts "#{__method__} start."
		@log.info "#{__method__} start."
		@web = Web.new
		html = @web.get_dom_of("http://www.channelfireball.com/articles/ehttp://www.channelfireball.com/articles/kaladesh-limited-set-review-artifacts/", @log)
		@site.extract_cardnames_from(html)
		@site.extract_scores_and_comments_of('Accomplished Automaton', html)

		assert_equal '1.0', @site.scores['Accomplished Automaton']
		assert_equal 'Despite my enduring love for Hexplate Golem, I can’t realistically claim that Accomplished Automaton is going to live up to its name. A 6/8 or a 5/7 + a 1/1 is a passable deal for 7 mana, but I’d hope that you can do better. Where this may fit is in control decks that need finishers and can’t pick anything else up, making it a card you can likely get almost automatically as a late pick.', @site.comments['Accomplished Automaton']
	end
#=end
end



