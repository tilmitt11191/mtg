# encoding: UTF-8
#ruby

require	'logger'
require 'active_support/core_ext/object' #for blank?
require 'open-uri'
require 'nokogiri'
require '../../lib/util/utils.rb'
require '../../lib/util/site.rb'
require '../../lib/util/deck.rb'

class Channelfireball < Site

	#for get_limited_set_reviews
	@cardnames
	@scores
	@comments
	attr_accessor :cardnames, :scores, :comments
	
	def initialize(logger)
		super('Channelfireball', logger)
		@url = 'http://www.channelfireball.com/articles/'

		@cardnames = []
		@scores = {}
		@comments = {}
	end
	
	def get_limited_set_reviews(outputfilename,urls)
		@log.info "#{__method__} start."
		urls.each do |url|
			html = @web.get_dom_of(url, @log)
			if html.nil? then
				@log.fatal "url[#{url}] is incorrect."
				return false
			end
			extract_cardnames_from html
			extract_scores_and_comments_from html
			output_limited_set_reviews_to outputfilename
		end
	end
	
	def extract_cardnames_from(html)
		@log.info "#{__method__} start."
		if html.nil? then
			@log.fatal "html is nil"
		else
			html.css('h1').each do |element|
				@log.debug "cardname[#{element.inner_text}]"
				@cardnames.push element.inner_text
			end
			remove_invalid_names
		end
	end

	def remove_invalid_names
		@log.info "#{__method__} start."
		return false if cardnames_is_blank
		@cardnames.reject! do |cardname| 
			if /(Limited Set Review|Previous Set Reviews|Ratings Scale|Top 5|White|Blue|Black|Red|Green|Artifacts|Colorless|Gold|Lands)/=~ cardname then
				@log.debug "remove #{cardname}"
				true
			end
		end
		@log.info "#{__method__} finished."
	end
	
	def extract_scores_and_comments_from(html)
		@log.info "#{__method__} start."
		return false if cardnames_is_blank
		
		@cardnames.each do |cardname|
			extract_scores_and_comments_of(cardname, html)
		end
	end
	
	def extract_scores_and_comments_of(cardname, html)
		puts "#{__method__}(#{cardname}) start."
		@log.info "#{__method__}(#{cardname}) start."
		cardname_flag = false
		html.inner_html.split("\n").each do |line|
			break if cardname_flag && line.include?('<h1>') #break if this card's score, comment finished and next start.
			cardname_flag = true if (line ==  "<h1>#{cardname}</h1>" || line == "<h1><strong>#{cardname}</strong></h1>")
			@scores[cardname] = format_score line if cardname_flag && ( line.include?('<h3>') || line.include?('<h3><strong>'))
			@scores[cardname] = format_score line if cardname_flag && @scores[cardname].nil? && line.include?('<p><strong>') #for EMN Black-Land
			@comments[cardname] = @comments[cardname].to_s + (format_comments line) if cardname_flag && line.include?('<p>')
		end
		@log.info "#{__method__}(#{cardname}) finished.@scores[cardname][#{@scores[cardname]}], @comments[cardname][#{@comments[cardname]}]]."
	end

	def output_limited_set_reviews_to outputfilename
		@log.info "#{__method__}(#{outputfilename}) start."
		outputfile = File.open(outputfilename, "w:Shift_JIS", :invalid => :replace, :undef => :replace, :replace => '?')
		@cardnames.each do |cardname|
			outputfile.puts "\"#{cardname}\",#{@scores[cardname]},\"#{@comments[cardname]}\""
		end
		
		outputfile.close
	end


	def	cardnames_is_blank
		if @cardnames.blank? then
			@log.warn '@cardnames is nil'
			return true
		end
	end
	
	def format_score str
		str = remove_html_tag str
		#for Make Mischief http://www.channelfireball.com/articles/eldritch-moon-limited-set-review-red/
		str.gsub!(/LimitedRatingg:/, '')
		return str.gsub!(/Limited:|Limited Rating:|\s/, '')
	end
	
	def format_comments str
		output = str.gsub(/<p><strong>(.+?)<\/strong>(.+?)<\/p>/, '')
		output = remove_html_tag output
		output
	end
	
	def remove_html_tag str
		str.gsub(/<(".*?"|'.*?'|[^'"])*?>/, '')
	end
	
	def get_decklist_from_article(url)
		@log.info "channelfireball.get_decklist_from_article start."
		@log.info "url[#{url}]"
		
		if !url_exists?(url, @log) then
			@log.error "url[#{url}] not exist."
			@log.error "channelfireball.get_decklist_from_article finished."
			return nil
		end
		
		html_row_data = open(url)
		html_nokogiri = Nokogiri::HTML.parse(html_row_data, nil, @charset)
		puts html_nokogiri.css('div').attribute('crystal-catalog-helper-sublist').to_s
		
	end
end