

require	"logger"
require 'open-uri'
require 'nokogiri'
require '../../lib/util/site.rb'

class SMDS < Site
	
	def initialize(logger)
		super("SMDS", logger)
		@url = "http://syunakira.com/smd/"
	end
	
	def create_pointranking_list_of(packname)
		@log.info "SMDS.create_pointranking_list_of(#{packname}) start."
		url = "http://syunakira.com/smd/pointranking/index.php?packname=#{packname}&language=Japanese"

		html_row_data = open(url)
		#File.open("url.html", "w") do |file|
		#	file.write html_row_data.read
		#end
		html_nokogiri = Nokogiri::HTML.parse(html_row_data, nil, @charset)
		File.open("pointranking_list_of_#{packname}.csv", "w") do |file|
			html_nokogiri.css('td/center').each do |text|
				file.write text.inner_text.to_s + ",\"\"\n" if /[0-9]/ =~ text.inner_text
			end
		end
		@log.info "SMDS.create_pointranking_list_of(#{packname}) finished."
	end

end