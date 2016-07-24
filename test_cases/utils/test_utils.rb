# encoding: UTF-8
#ruby

require 'logger'
require '../../lib/util/utils.rb'


begin
	puts File.basename(__FILE__).to_s + " start."
	@log = Logger.new("../../log")
	@log.info ""
	@log.info File.basename(__FILE__).to_s + " start."
	@log.info ""


#check url_exists?
	correct_url='http://www.google.com'
	url_exists?(correct_url,@log)
	incorrect_url='http://www.google__.com'
	url_exists?(incorrect_url,@log)


rescue => e
		puts_write(e,@log)
end


@log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."




