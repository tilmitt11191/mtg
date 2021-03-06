# encoding: UTF-8
#ruby
require '../../lib/util/utils.rb'
require '../../lib/util/site.rb'
require '../../lib/util/card.rb'
require '../../lib/util/web.rb'


class MTGOtraders < Site
	def initialize(logger)
		super("mtgotraders", logger)
		@url = "http://www.mtgotraders.com/"
		@search_option = 'relevant'
	end

=begin
	def how_match?(card)
		@log.info "how match ["+card.name+"] at mtgotraders"
		@card_name = card.name
		@log.debug "url is [" + card.store_url.to_s + "]"
		if card.store_url.nil? then
			@log.error "card.store_url is nil at mtgotraders.how_match?"
			@log.error "return nil"
			return nil		
		elsif !card.store_url.include?("http://www.mtgotraders.com/") then
			@log.error "invalid card.store_url[" + card.store_url.to_s + "]"
			@log.error "return nil"
			return nil
		end
		card.price.value = 0
		#read_cardpage(card.store_url)
		#price = @card_nokogiri.css('span.sell_price').text
		#price.gsub!(/\s|\n|￥|,/,"")
		#card.price.value = price
		#@log.debug "price is " + price
		return card.price
	end
=end

	def how_match card
		@log.info "how match [#{card.name}], option[#{card.price.store.search_option}]  at mtgotraders start"
		price = Price.new(card, @log)

		agent = Mechanize.new
		url = 'http://www.mtgotraders.com/store/index.html'
		if !Web::url_exists? url, @log then
			@log.error "site url[#{url}] not exist. return nil."
			return nil
		end
		page = agent.get(url)
		query = card.name.to_s
		page.form.q = query
		@log.debug "query: " + query

		search_results = page.form.submit
		
		optional_urls = {}
		search_results.search('div.searchopt-sortby/select/option').each do |options|
			optional_urls[:"#{options.text}"] = options.attribute('value').value
		end
		#<div class="searchopt-sortby">
		#	<label>Sort by:</label>
		#	<select name="sortby" onchange="document.location.href=this.value">
		#		<option value="http://www.mtgotraders.com/store/search.php?q=Jace%2C+Unraveler+of+Secrets&sortby=relevancy" selected="selected">Relevancy</option>
		#		<option value="http://www.mtgotraders.com/store/search.php?q=Jace%2C+Unraveler+of+Secrets&sortby=name">Name: A to Z</option>
		#		<option value="http://www.mtgotraders.com/store/search.php?q=Jace%2C+Unraveler+of+Secrets&sortby=name_desc">Name: Z to A</option>
		#		<option value="http://www.mtgotraders.com/store/search.php?q=Jace%2C+Unraveler+of+Secrets&sortby=price">Price: Low to High</option>
		#		<option value="http://www.mtgotraders.com/store/search.php?q=Jace%2C+Unraveler+of+Secrets&sortby=price_desc">Price: High to Low</option>
		#	</select>
		#</div>
		
		case card.price.store.search_option
		when 'relevant' then
			@log.debug "get relevant price."
			search_url = optional_urls[:Relevancy] #http://www.mtgotraders.com/store/search.php?q=%22Liliana%2C+the+Last+Hope%22&sortby=relevancy
		when 'highest' then
			@log.debug "get highest price."
			search_url = optional_urls[:"Price: High to Low"] #http://www.mtgotraders.com/store/search.php?q=%22Liliana%2C+the+Last+Hope%22&sortby=price_desc
		when 'lowest' then
			@log.debug "get lowest price."
			search_url = optional_urls[:"Price: Low to High"] #http://www.mtgotraders.com/store/search.php?q=%22Liliana%2C+the+Last+Hope%22&sortby=price
		end
		@log.debug "search_url[#{search_url}]"
		card.store_url = search_url
		search_results = agent.get(search_url)
		card.store_url = search_results.search('td.cardname/a').attribute('href').value

		if !check_validness_of card then
			@log.warn "cardpage of [#{card.name}] not exist. return nil"
			return nil
		end

		result = search_results.at('td.price').text #get only one result which hit first
		value = result.gsub!(/\$/,'')
		@log.info "how match [#{card.name}]  at mtgotraders finished. return[#{value}]"
		return value
	end
	
	
	
=begin
	def set_store_page_of(card)
		@log.info "search_store_page_of[" + card.name.to_s + "] start"
		agent = Mechanize.new
		page = agent.get('http://www.mtgotraders.com/store/index.html')
		query = card.name.to_s
		page.form.q = query
		@log.debug "query: " + query
		#@log.debug "[search_condition]"
		#@log.debug "#{page.forms}"
				
		search_results = page.form.submit
		#@log.debug "[search_results]"
		#@log.debug "#{search_results.body}"
		
		#TODO README(first hit)
		card.store_url = search_results.search('td.cardname/a').attribute('href').value
		@log.debug "card.store_url[" + card.store_url.to_s + "]"

		@log.info "search_store_page_of[" + card.name.to_s + "] finished."
		@log.info "return[" + card.store_url.to_s + "]"
		return card.store_url
	end
=end
	
	def check_validness_of card
		#puts "#{__method__}[#{card.name}] start."
		@log.info "#{__method__}[#{card.name}] start."
		@log.warn "this method not complete."
		#puts card.store_url
		converted_cardname = card.name.gsub(/\s/,'_')
		#puts converted_cardname

		return true
	end
	
	def get_prices(price_manager,relevant:true,highest:true,lowest:true)
		##TODO Exception
		@log.info " get_prices start."
		if price_manager.card.nil? then
			@log.error "price_manager.card is nil."
		end
		
		@log.debug "card[" + price_manager.card.name.to_s + "]"
		@log.debug "relevant[" + relevant.to_s + "], highest[" + highest.to_s + "], lowest[" + lowest.to_s + "]"

		agent = Mechanize.new
		page = agent.get('http://www.mtgotraders.com/store/index.html')
		query = price_manager.card.name.to_s
		page.form.q = query
		@log.debug "query: " + query

		search_results = page.form.submit
		
		optional_urls = {}
		search_results.search('div.searchopt-sortby/select/option').each do |options|
			optional_urls[:"#{options.text}"] = options.attribute('value').value
		end
		#<div class="searchopt-sortby">
		#	<label>Sort by:</label>
		#	<select name="sortby" onchange="document.location.href=this.value">
		#		<option value="http://www.mtgotraders.com/store/search.php?q=Jace%2C+Unraveler+of+Secrets&sortby=relevancy" selected="selected">Relevancy</option>
		#		<option value="http://www.mtgotraders.com/store/search.php?q=Jace%2C+Unraveler+of+Secrets&sortby=name">Name: A to Z</option>
		#		<option value="http://www.mtgotraders.com/store/search.php?q=Jace%2C+Unraveler+of+Secrets&sortby=name_desc">Name: Z to A</option>
		#		<option value="http://www.mtgotraders.com/store/search.php?q=Jace%2C+Unraveler+of+Secrets&sortby=price">Price: Low to High</option>
		#		<option value="http://www.mtgotraders.com/store/search.php?q=Jace%2C+Unraveler+of+Secrets&sortby=price_desc">Price: High to Low</option>
		#	</select>
		#</div>
		
		if relevant then
			@log.debug "get relevant price."
			result = search_results.at('td.price').text #get only one result which hit first
			price_manager.relevant_price.value = result.gsub!(/\$/,'')
			@log.debug price_manager.relevant_price.value
		end
		
		if highest then
			@log.debug "get highest price."
			optional_url = optional_urls[:"Price: High to Low"] #http://www.mtgotraders.com/store/search.php?q=Jace%2C+Unraveler+of+Secrets&sortby=price_desc
			search_results = agent.get(optional_url)
			result = search_results.at('td.price').text #get only one result which hit first
			price_manager.highest_price.value = result.gsub!(/\$/,'')
			@log.debug price_manager.highest_price.value
		end
		
		if lowest then
			@log.debug "get highest price."
			optional_url = optional_urls[:"Price: Low to High"] #http://www.mtgotraders.com/store/search.php?q=Jace%2C+Unraveler+of+Secrets&sortby=price_desc
			search_results = agent.get(optional_url)
			result = search_results.at('td.price').text #get only one result which hit first
			price_manager.lowest_price.value = result.gsub!(/\$/,'')
			@log.debug price_manager.lowest_price.value
		end
		@log.info " get_prices finished."

	end
	
	
end
