
#ruby
#This program is related to Magic the Gathering.
#This program calcurates the probabilities of drwaing lands in any condition.

#ruby ../../lib/calculation/relation_between_turn_and_land.rb -l 25 -t 6 -e 6 -v lands_in_decks,hands,expecting_land_nums
# => lands_in_decks[25]hands[13]expecting_land_nums[6]=47.502

#ruby ../../lib/calculation/relation_between_turn_and_land.rb -l 25 -t 6 -e 6 -v ""
#47.502

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

options[:hands]                          = [7]

options[:expecting_land_nums]            = [0,2]
opt.banner = " \
	This program calculates or simulates about land number of Magic the Gathering.\n \
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
	hands = []
	options[:hands].each do |hand|
		hands.push(hand.to_i)
	end

	if @opt_turn_flag && !@opt_hand_flag then
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
	@log.debug "\thands" + hands.to_s




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
					hand = initial_hand + turn * draw
					expecting_land_nums.each do |expecting_land_num|
						##############################  
						#### main process start!! ####
						##############################
						## the probability of two land in hand is set on probabilities_of_lands_in_hand[2]
						probabilities_of_lands_in_hand = create_probabilities_of_lands_in_hand(deck, hand, @log)
						more = calc_probability_of_more_than_x_lands_in_hand(probabilities_of_lands_in_hand, expecting_land_num, hand, @log).round(3)
						#puts "num_of_land[" + num_of_land.to_s + "/" + deck.calc_num_of_mainboard_cards_in_deck.to_s + "], turn[" + turn.to_s + "], expecting_land_num[" + expecting_land_num.to_s + "]=" + more.to_s
						viewing_parameters.each do |param|
							print "#{param}["
							case param
							when "initial_hands" then print initial_hand
							when "draw_per_turn" then print draw
							when "lands_in_decks" then print num_of_lands
							when "turns" then print turn
							when "hands" then print hand
							when "expecting_land_nums" then print expecting_land_num
							end
							print "]"
						end
						if viewing_parameters.size > 0 then print "=" end
						puts "#{more}"
						@log.info "cards[#{num_of_cards}],lands[#{num_of_lands}],expect[#{expecting_land_num}],initial_hand[#{initial_hand}],turn[#{turn}],draw[#{draw}],current_hand[#{hand}]=#{more}"
						#################################
						#### main process finished!! ####
						#################################
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

