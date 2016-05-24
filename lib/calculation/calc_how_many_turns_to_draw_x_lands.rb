
#ruby
#This program is related to Magic the Gathering.
#If you have X lands in hand now,
#this program calculates how many additional turns you need to draw Y lands.

## How to calculate
=begin
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
		 	  = sum^N_t=0 q(x'(t),y',deck(t)) * t
		 	here,
		 	N = round_down(cards_in_deck / draw_per_turn)
			x'(t) = t * draw_per_turn
			y' = Y - X
			deck(t):
				cards_in_deck = initial_cards_in_deck - Z - t * draw_per_turn
				land_in_deck = initial_lands_in_deck - X - drawn_land(t-1)
				drawn_land(t-1) is the number of lands drew until turn t-1
				 = ((t-1) * draw_per_turn) * (ll_i/lib_i)

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
=end

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

options[:cards_in_decks]                 = [60]
options[:lands_in_decks]                 = [17,26]
options[:turns]                          = [0]
options[:draw_per_turn]                  = [1]
options[:initial_hands]                  = [7]

options[:cards_in_hands]                 = [7]
options[:lands_in_hands]                 = [2]

options[:expecting_land_nums]            = [6]


opt.banner = " \
	This program calculates how many additional turns you need to draw Y lands if you have X lands in hand now. This program is related to land number of Magic the Gathering.\n \
	Usage: #{File.basename($0)} [options]\
	"

opt.on('-h','--help','show help') { print opt.help; exit }
opt.on( '-o output','--output','The place printing results. stdout or ... Default value is stdout.',\
			String){|v| options[:output] = v}
opt.on( '-v viewing_parameters','--viewing_parameters','Viewing parameters with results. Default values are [lands_in_decks, turns, expecting_land_nums].',\
			Array){|v| options[:viewing_parameters] = v}


opt.on( '-c cards_in_decks','--cards_in_decks','Specify some numbers of cards in decks. Default values is "60".The format is Array.',\
			Array){|v| options[:cards_in_decks] = v}
opt.on( '-l land_in_decks','--lands_in_decks','Specify some numbers of lands in decks. Default values are "17 26".The format is Array as default',\
			Array){|v| options[:lands_in_decks] = v}
opt.on( '-t turn','--turn','Default values is 0.',\
			Array){
				|v| options[:turns] = v
				@opt_turn_flag = true
			}
opt.on( '-d draw_per_turn','--draw_per_turn','Default values is 1.',\
			Array){|v| options[:draw_per_turn] = v}
opt.on( '-i initial_hands','--initial_hands','Default values is 7.',\
			Array){|v| options[:initial_hands] = v}
opt.on( '-n numbers of cars in hand','--cards_in_hands','Default values is "7".',\
			Array){
				|v| options[:cards_in_hands] = v
				@opt_hand_flag = true
			}
opt.on( '-L numbers of lands in hand','--lands_in_hands','Default values is "2".',\
			Array){|v| options[:lands_in_hands] = v}			
opt.on( '-e expecting_land_num','--expecting_land_num','Default values is "6".',\
			Array){|v| options[:expecting_land_nums] = v}
opt.permute!( ARGV )




begin
	puts File.basename(__FILE__).to_s + " start."
	@log = Logger.new("../../log", 5, 10 * 1024 * 1024)
	@log.info ""
	@log.info File.basename(__FILE__).to_s + " start."
	@log.info ""


	#check legals of ARGVs
	viewing_parameters = []
	options[:viewing_parameters].each do |param|
		viewing_parameters.push(param.to_s)
	end

	nums_of_cards = []
	options[:cards_in_decks].each do |card|
		nums_of_cards.push(card.to_i)
	end
	nums_of_lands = []
	options[:lands_in_decks].each do |land|
		nums_of_lands.push(land.to_i)
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
	cards_in_hands = []
	options[:cards_in_hands].each do |hand|
		cards_in_hands.push(hand.to_i)
	end
	lands_in_hands = []
	options[:lands_in_hands].each do |land|
		lands_in_hands.push(land.to_i)
	end

	if @opt_turn_flag && !@opt_hand_flag then
		puts "calc hands by turns and draw_per_turn."
		@log.debug "calc hands by turns and draw_per_turn."
		hands = []
		initial_hands.each do |initial_hand|
			draw_per_turn.each do |draw|
				turns.each do |turn|
					hands.push(initial_hand + turn * draw)
				end
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

	@log.debug "Palameters:"
	@log.debug "\tnums_of_cards" + nums_of_cards.to_s
	@log.debug "\tnums_of_lands" + nums_of_lands.to_s
	@log.debug "\texpecting_land_nums" + expecting_land_nums.to_s
	@log.debug "\tturns" + turns.to_s
	@log.debug "\tinitial_hands" + initial_hands.to_s
	@log.debug "\tdraw_per_turn" + draw_per_turn.to_s
	@log.debug "\tcards_in_hands" + cards_in_hands.to_s
	@log.debug "\tlands_in_hands" + lands_in_hands.to_s


	##create decks with different number of lands.
	@log.debug "start creating decks with different number of lands."
	decks = {} #hash of Deck.The key is number of lands.
	nums_of_cards.each do |num_of_cards|
		nums_of_lands.each do |num_of_lands|
			deck = create_a_deck_with_target_number_of_cards(num_of_cards, num_of_lands, @log)
			@log.debug "deck[#{num_of_lands}/#{num_of_cards}] was created."
			decks[:"#{num_of_lands}/#{num_of_cards}"] = deck
		end
	end
	@log.debug "creating " + decks.size().to_s + " decks with different number of lands finished."


	initial_hands.each do |initial_hand|
		draw_per_turn.each do |draw|
			decks.each do |key ,deck|
				num_of_lands = key.to_s.split('/')[0].to_i
				num_of_cards = key.to_s.split('/')[1].to_i
				turns.each do |turn|
					lands_in_hands.each do |lands_in_hand|
						hand = initial_hand + turn * draw
						expecting_land_nums.each do |expecting_land_num|
						##############################  
						#### main process start!! ####
						##############################
						puts "cards[#{num_of_cards}],lands[#{num_of_lands}],expect[#{expecting_land_num}],initial_hand[#{initial_hand}],turn[#{turn}],draw[#{draw}],current_hand[#{hand}],lands_in_hand[#{lands_in_hand}]"
						puts "You have #{lands_in_hand} lands in hand now, the additional turn you need to draw #{expecting_land_num} lands is "
						puts "A"
						puts algorithm_A_simple(lands_in_hand, expecting_land_num, deck, @log).round(3)

						puts "B"
						cards_in_deck = num_of_cards - hand
						puts algorithm_B_correct(lands_in_hand, expecting_land_num, hand, draw, deck, @log).round(3)

						#################################
						#### main process finished!! ####
						#################################
						end
					end
				end
			end
		end
	end





rescue => e
	puts_write(e,@log)
end


@log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."

