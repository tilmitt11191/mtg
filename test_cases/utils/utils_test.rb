# encoding: UTF-8
#ruby

require 'logger'
require 'test/unit'
require '../../lib/util/tests.rb' #for must
require '../../lib/util/utils.rb'

class Test_utils < Test::Unit::TestCase
	#@log = Logger.new("../../log")
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
	
	#check url_exists?
	must "correct url" do
		begin
			@log.info "#{__method__} start."
			correct_url='http://www.google.com'
			correct_result = url_exists?(correct_url,@log)
			assert_equal true, correct_result
		rescue => e
			write_error_to_log(e,@log)
		end
	end
	
	must "incorrect url" do
		begin
			incorrect_url='http://www.google__.com'
			incorrect_result = url_exists?(incorrect_url,@log)
			assert_equal false, incorrect_result
		rescue => e
			write_error_to_log(e,@log)
		end
	end
	
end
