
#ruby
#This program is related to Magic the Gathering.
#If you have X lands in hand now,
#this program calculates how many additional turns you need to draw Y lands.

## How to calculate
Algorithm A (simple)
	Parameters
		X:number of lands in current hand
		Y:number of expecting lands
		t:additional turns

		lib_i:number of cards in library when game started.
		ll_i:number of lands in liblary when game started.

	if X >= Y then
		you have already Y lands so you need no additional turn.
		return 0
	else (X < Y)
		Expected value drawing land card E = ll_i/lib_i.
		When X + t * E = Y, you can draw Y lands,
		so return t = (Y - X) / (ll_i/lib_i)
	end

Algorithm B (correct)
	Parameters
		X: number of lands in current hand
		Y: expecting land
		Z: number of cards already drew
		T: additional turns you need to draw Y lands if you have X lands in hand now.

		Then T = sum^infinity_t=0 p(t,Y),
		p(t,y): The probability of drawing ""more"" than y lands after t turns.

		The probability of drawing more than y lands when draw x cards from deck -
		q(x,y,deck):
			= x_C_y * {(lands_in_deck/cards_in_deck)** y} * {(other_cards_in_deck/cards_in_deck ** (x - y)}

		 If the event of drawing a card seems Similarly certainly, the objective probability is q(Z+t*draw_per_turn,Y,deck)/q(Z,X,deck).
		 The event of drawing a card, however, doesn't seem Similarly certainly because as you drew a card, as the deck changes.
		 Therefore, using deck(t),
		 	T = sum^infinity_t=0 p(t,Y)
		 	  = sum^infinity_t=0 q(x',y',deck(t)) 
		 	here,
			x' = t * draw_per_turn
			y' = Y - X
			deck(t):
				cards_in_deck = initial_cards_in_deck - Z
				land_in_deck = initial_lands_in_deck - X.

Algorithm C (simulation)
	if X >= Y then
		you have already Y lands so you need no additional turn.
		return 0
	else (X < Y)
		t = 0
		while !deck.empty
			(draw a card)
			t += 1
			card = deck.draw_a_card #deck.size -=1

			if card.island? then X += 1 end
			if (X >= Y) then return t end
		end
	end


require "logger"
require '../../lib/util/utils.rb'
require '../../lib/util/card.rb'
require '../../lib/util/deck.rb'
require '../../lib/util/calculation.rb'

require 'optparse'
opt = OptionParser.new
options = {}

# option parser
options[:output]                         = "stdout"
options[:viewing_parameters]             = ["lands_in_decks", "turns", "expecting_land_nums"]

options[:lands_in_decks]                 = [17,26]
options[:turns]                          = [0]
options[:draw_per_turn]                  = [1]
options[:initial_hands]                  = [7]
options[:hands]                          = [7]
options[:expecting_land_nums]            = [0,2]
opt.banner = " \
	This program calculates or simulates about land number of Magic the Gathering.\n \
	Usage: #{File.basename($0)} [options]\
	"

opt.on('-h','--help','show help') { print opt.help; exit }
opt.on( '-o output','--output','Default value is stdout.',\
			String){|v| options[:output] = v}
opt.on( '-v viewing_parameters','--viewing_parameters','Default values are [lands_in_decks, turns, expecting_land_nums].',\
			Array){|v| options[:viewing_parameters] = v}
opt.on( '-l land_in_decks','--lands_in_decks','Specify some numbers of lands in decks. Default values are "17 26".
		The format of land numbers is Array as default',\
			Array){|v| options[:lands_in_decks] = v}
opt.on( '-t turn','--turn','Default values is 0.',\
			Array){
				|v| options[:turns] = v
				@opt_turn_flag = true
			}
opt.on( '-d draw_per_turn','--draw_per_turn','Default values is 1.',\
			Array){|v| options[:draw_per_turn] = v}
opt.on( '-i initial_hands','--initial_hands','Default values is 7.',\
			Array){|v| options[:draw_per_turn] = v}
opt.on( '-n numbers of cars in hand','--numbers_of_hand','Default values is "7".',\
			Array){
				|v| options[:hands] = v
				@opt_hand_flag = true
			}
opt.on( '-e expecting_land_num','--expecting_land_num','Default values are 0,2.',\
			Array){|v| options[:expecting_land_nums] = v}
opt.permute!( ARGV )

begin
	#puts File.basename(__FILE__).to_s + " start."
	@log = Logger.new("../../log", 5, 10 * 1024 * 1024)
	@log.info ""
	@log.info File.basename(__FILE__).to_s + " start."
	@log.info ""
	

	#check legals of ARGVs
	viewing_parameters = []
	options[:viewing_parameters].each do |param|
		viewing_parameters.push(param.to_s)
	end

	num_of_lands = []
	options[:lands_in_decks].each do |land|
		num_of_lands.push(land.to_i)
	end
	turns = []
	options[:turns].each do |turn|
		turns.push(turn.to_i)
	end
	draw_per_turn = []
	options[:draw_per_turn].each do |draw|
		draw_per_turn.push(draw.to_i)
	end
	initial_hands = []
	options[:initial_hands].each do |initial_hand|
		initial_hands.push(initial_hand.to_i)
	end
	hands = []
	options[:hands].each do |hand|
		hands.push(hand.to_i)
	end
	initial_hand = 7
	if @opt_turn_flag && !@opt_hand_flag then
		@log.debug "calc hands by turns and draw_per_turn."
		hands = []
		draw_per_turn.each do |draw|
			turns.each do |turn|
				hands.push(initial_hand + turn * draw)
			end
		end
	elsif !@opt_turn_flag && @opt_hand_flag then
		@log.debug "no calculation to get hand."
	elsif !@opt_turn_flag && !@opt_hand_flag then
		@log.debug "use default hands."
	elsif @opt_turn_flag && @opt_hand_flag then
		puts "calc legal."
		#TODO
	end

	expecting_land_nums = []
	options[:expecting_land_nums].each do |expecting_land_num|
		expecting_land_nums.push(expecting_land_num.to_i)
	end

	@log.debug "num_of_lands" + num_of_lands.to_s
	@log.debug "turns" + turns.to_s
	@log.debug "draw_per_turn" + draw_per_turn.to_s
	@log.debug "hands" + hands.to_s
	@log.debug "expecting_land_nums" + expecting_land_nums.to_s

	####main
	##create decks with different number of lands.
	@log.info "start creating decks with different number of lands."
	decks = {} #hash of Deck.The key is number of lands.
	@library = 60
	num_of_lands.each do |num_of_land|
		@log.info "num_of_land = " + num_of_land.to_s
		deck = Deck.new("#{num_of_land}", "simulation", "", @log)
		land_card = Card.new("land", @log)
		land_card.card_type = "land"
		land_card.quantity = num_of_land
		deck.cards.push(land_card)
		other_card = Card.new("MainboardCard", @log)
		other_card.card_type = "MainboardCard"
		other_card.quantity = @library - num_of_land
		deck.cards.push(other_card)

		decks[:"#{num_of_land}"] = deck
	end
	@log.info "creating " + decks.size().to_s + " decks with different number of lands finished."
	#puts decks[:"25"].calc_num_of_lands_in_deck
	#puts decks[:"25"].cards[0].card_type
	
	initial_hands.each do |initial_hand|
		draw_per_turn.each do |draw|
			decks.each do |num_of_land ,deck|
				turns.each do |turn|
					hand = initial_hand + turn * draw
					expecting_land_nums.each do |expecting_land_num|
						## the probability of two land in hand is set on probabilities_of_lands_in_hand[2]
						probabilities_of_lands_in_hand = create_probabilities_of_lands_in_hand(deck, hand, @log)
						more = calc_probability_of_more_than_x_lands_in_hand(probabilities_of_lands_in_hand, expecting_land_num, hand, @log).round(3)
						#puts "num_of_land[" + num_of_land.to_s + "/" + deck.calc_num_of_mainboard_cards_in_deck.to_s + "], turn[" + turn.to_s + "], expecting_land_num[" + expecting_land_num.to_s + "]=" + more.to_s
						viewing_parameters.each do |param|
							print "#{param}["
							case param
							when "initial_hands" then print initial_hand# end
							when "draw_per_turn" then print draw# end
							when "lands_in_decks" then print num_of_land# end
							when "turns" then print turn# end
							when "hands" then print hand# end
							when "expecting_land_nums" then print expecting_land_num# end
							end
							print "]"
						end
						if viewing_parameters.size > 0 then print "=" end
						puts "#{more}"
					end
				end
			end
		end
	end


rescue => e
	puts_write(e,@log)
end


@log.info File.basename(__FILE__).to_s + " finished."
#puts File.basename(__FILE__).to_s + " finished."

