# encoding: UTF-8
#ruby

require 'logger'
require 'test/unit'
require '../../lib/util/tests.rb' #for must
require '../../lib/util/utils.rb'
require '../../lib/util/web.rb'

class Test_web < Test::Unit::TestCase
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
			@log.info "#{__method__} start."
			correct_url='http://www.google.com'
			correct_result = @web.url_exists?(correct_url,@log)
			assert_equal true, correct_result
	end
	
	must "incorrect url exists?" do
			@log.info "#{__method__} start."
			incorrect_url='http://www.google__.com'
			incorrect_result = @web.url_exists?(incorrect_url,@log)
			assert_equal false, incorrect_result
	end
	
	must "get dom of google" do
			@log.info "#{__method__} start."
			url = 'http://www.google.com'
			dom = @web.get_dom_of(url, @log)
			assert_equal 'Google', dom.title
	end
	
	must "get dom of incorrect url" do
			@log.info "#{__method__} start."
			url = 'http://www.google__.com'
			dom = @web.get_dom_of(url, @log)
			assert_equal nil, dom
	end

	must "get dom of iso-8859-1 url" do
			@log.info "#{__method__} start."
			url = 'http://syunakira.com/smd/pointranking/index.php?packname=UnravelTheMadness&language=Japanese'
			dom = @web.get_dom_of(url, @log)
			assert_equal 'Point Ranking', dom.title
	end
	
	must "output google's src to google.html" do
			@log.info "#{__method__} start."
			url = 'http://www.google.com'
			@web.get_dom_of(url, @log)
			@web.output_html_src_to('../../test_cases/workspace/google.html', @log)
			html = File.open('../../test_cases/workspace/google.html', 'r:utf-8', :invalid => :replace, :undef => :replace, :replace => '?')
			assert html.readlines[0].match('世界中のあらゆる情報を検索するためのツールを提供しています。さまざまな検索機能を活用して、お探しの情報を見つけてください。')
	end
	
	must "output incorrect url src" do
			@log.info "#{__method__} start."
			url = 'http://www.google__.com'
			@web.get_dom_of(url, @log)
			assert_equal false, @web.output_html_src_to('../../test_cases/workspace/google__.html', @log)
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

=begin
		begin

		rescue AssertionFailedError => failure
			_set_failed_information(failure, expected, actual, message)
			raise failure # For JRuby. :<
		rescue => e
			write_error_to_log(e,@log)
		end

=end