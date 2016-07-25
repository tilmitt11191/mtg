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

	must "extract cardnames from emn white" do
		begin
			@log.info "#{__method__} start."
			@web = Web.new
			html = @web.get_dom_of("http://www.channelfireball.com/articles/eldritch-moon-limited-set-review-white/", @log)
			@site.extract_cardnames_from(html)
			assert_equal 38, @site.cardnames.size
		rescue AssertionFailedError => failure
			_set_failed_information(failure, expected, actual, message)
			raise failure # For JRuby. :<
		rescue => e
			write_error_to_log(e,@log)
		end
	end

	must "remove invalid cards" do
		begin
			@log.info "#{__method__} start."
			@web = Web.new
			html = @web.get_dom_of("http://www.channelfireball.com/articles/eldritch-moon-limited-set-review-white/", @log)
			@site.extract_cardnames_from(html)
			@site.remove_invalid_cards
			assert_equal 35, @site.cardnames.size
		rescue AssertionFailedError => failure
			_set_failed_information(failure, expected, actual, message)
			raise failure # For JRuby. :<
		rescue => e
			write_error_to_log(e,@log)
		end
	end


end



