# encoding: UTF-8
#ruby

require 'logger'
require 'test/unit'
require '../../lib/util/tests.rb' #for must
require '../../lib/util/utils.rb'

class Test_utils < Test::Unit::TestCase
	@log
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
	
	must "escape_by_double_quote standard str" do
		@log.info "#{__method__} start."
		assert_equal "\"aa a\"", escape_by_double_quote("aa a", @log)
	end

	must "escape_by_double_quote already escaped str" do
		@log.info "#{__method__} start."
		assert_equal "\"aaa\"", escape_by_double_quote("\"aaa\"", @log)
	end

	must "unescape_double_quote str" do
		@log.info "#{__method__} start."
		assert_equal "aaa", unescape_double_quote("\"aaa\"")
	end

#=begin	
	#check url_exists?
	must "correct url" do
		@log.info "#{__method__} start."
		correct_url='http://www.google.com'
		correct_result = url_exists?(correct_url,@log)
		assert_equal true, correct_result
	end
	
	must "incorrect url" do
		incorrect_url='http://www.google__.com'
		incorrect_result = url_exists?(incorrect_url,@log)
		assert_equal false, incorrect_result
	end
#=end
	
end
