# encoding: UTF-8
#ruby

require 'logger'
require 'test/unit'
require '../../lib/util/tests.rb' #for must
require '../../lib/util/utils.rb'
require '../../lib/util/web.rb'

class Test_utils < Test::Unit::TestCase
	@log
	@web
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
		@web = Web.new
	end
	
	must "correct url exists?" do
		begin
			@log.info "#{__method__} start."
			correct_url='http://www.google.com'
			correct_result = @web.url_exists?(correct_url,@log)
			assert_equal true, correct_result
		rescue => e
			write_error_to_log(e,@log)
		end
	end
	
	must "incorrect url exists?" do
		begin
			@log.info "#{__method__} start."
			incorrect_url='http://www.google__.com'
			incorrect_result = @web.url_exists?(incorrect_url,@log)
			assert_equal false, incorrect_result
		rescue => e
			write_error_to_log(e,@log)
		end
	end
	
	must "get dom of google" do
		begin
			@log.info "#{__method__} start."
			url = 'http://www.google.com'
			dom = @web.get_dom_of(url, @log)
			assert_equal 'Google', dom.title
		rescue => e
			write_error_to_log(e,@log)
		end
	end
	
	must "get dom of incorrect url" do
		begin
			@log.info "#{__method__} start."
			url = 'http://www.google__.com'
			dom = @web.get_dom_of(url, @log)
			assert_equal nil, dom
		rescue => e
			write_error_to_log(e,@log)
		end
	end
	
	#must "print google src" do
	#	begin
	#		@log.info "#{__method__} start."
	#		url = 'http://www.google.com'
	#		@web.get_dom_of(url, @log)
	#		@web.print_html_src(@log)
	#	rescue => e
	#		write_error_to_log(e,@log)
	#	end
	#end
	
end

