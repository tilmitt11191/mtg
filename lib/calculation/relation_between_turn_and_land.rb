
#ruby
require "logger"
require '../../lib/util/utils.rb'
require '../../lib/util/card.rb'
require '../../lib/util/deck.rb'






begin
	puts File.basename(__FILE__).to_s + " start."
	@log = Logger.new("../../log", 5, 10 * 1024 * 1024)
	@log.info ""
	@log.info File.basename(__FILE__).to_s + " start."
	@log.info ""
	

	def combination(a,b)
		# if a and b isn't int
		if b.to_i > a.to_i then
			puts error
			return nil
		end
		molecule = 1
		for i in 1..b
			molecule = molecule*(a-i+1)
		end
		denominator=1
		for i in 1..b
			denominator = denominator*i
		end
		return molecule / denominator
	end
	
	
	##create decks with different number of lands.
	@log.info "start creating decks with different number of lands."
	decks = {} #hash of Deck.The key is number of lands.
	@lowest_land_num = 25
	@highest_land_num = 26
	@library = 60
	for num_of_land in @lowest_land_num..@highest_land_num
		@log.info "num_of_land = " + num_of_land.to_s
		land_card = Card.new("land", @log)
		land_card.card_type = "land"
		land_card.quantity = num_of_land
		other_card = Card.new("MainboardCard", @log)
		land_card.card_type = "MainboardCard"
		land_card.quantity = @library - num_of_land
		
		deck = Deck.new("#{num_of_land}", "simulation", "", @log)
		deck.cards.push(land_card)
		deck.cards.push(other_card)
		decks[:"#{num_of_land}"] = deck
	end
	@log.info "creating " + decks.size().to_s + " decks with different number of lands finished."
	
	

=begin	
	@lands_in_decks = []
	@expected_land_num = {} #expected_land_num[:lands_in_decks] = [probability_of_land1, 2, 3 ]
	@probabilities_of_each_turn = [] # array of @expected_land_num

	@library = 60
	@lowest_land_num = 17
	@highest_land_num = 30
	for i in @lowest_land_num..@highest_land_num
		@lands_in_decks.push(i)
		@expected_land_num[:i] = []
	end
	

	@initial_draw = 7
	@draw_per_turn = 1
	@lands_in_hand = 0
	
	
	for turn in 0..1
		puts "turn[" + turn.to_s + "]"
		hand = @initial_draw + @draw_per_turn * turn
		@lands_in_decks.each do |land_in_deck|
			sum = [] #array of str
			for probability_of_lands in 1..hand
				@log.info "parameters"
				@log.info "land_in_deck[" + land_in_deck.to_s + "]"
				@log.info "turn[" + turn.to_s + "]"
				@log.info "hand[" + hand.to_s + "]"
				@log.info "probability_of_lands[" + probability_of_lands.to_s + "]"
				@log.info "combination(" + hand.to_s + "," + probability_of_lands.to_s + ") * (((" + land_in_deck.to_s + "/" + @library.to_s + ") ** " + probability_of_lands.to_s + ")) * (((" + @library.to_s + " - "+land_in_deck.to_s + ")/" + @library.to_s + ") ** (" + hand.to_s + "-"+probability_of_lands.to_s + "))"
				sum.push((combination(hand,probability_of_lands).to_f * (((land_in_deck.to_f/@library.to_f) ** probability_of_lands)) * (((@library.to_f - land_in_deck.to_f)/@library.to_f) ** (hand - probability_of_lands)))*100).to_s
				@log.info "\t=" + sum[probability_of_lands - 1].round(3).to_s
			end
			@expected_land_num[:"#{land_in_deck}"] = sum
			#puts @expected_land_num[:land_in_deck].to_s
		end
		@probabilities_of_each_turn.push(@expected_land_num)
	end


File.open("relation_between_turn_and_land.csv", "w:sjis") do |file|
	#header
	for turn in 0..1
		@expected_land_num = @probabilities_of_each_turn[turn - 1]
		file.puts "turn[" + turn.to_s + "]"
		file.print "lib\\hand,"
			columns = 1
			sum = 0
			@expected_land_num[:"#{i}"].each do |probability|
				sum += probability.to_f
				file.print columns.to_s + ","
				columns += 1
			end
			file.print "\n"
	end

	#each probability
	for turn in 0..1
		@expected_land_num = @probabilities_of_each_turn[turn - 1]
		for i in @lowest_land_num..@highest_land_num
			file.print i.to_s + ","
			@expected_land_num[:"#{i}"].each do |probability|
				file.print probability.round(3).to_s + ","
			end
			file.print "\n"
		end
	end
	
=end


rescue => e
	puts_write(e,@log)
end


@log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."

