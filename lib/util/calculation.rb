
#ruby
require "logger"
require '../../lib/util/utils.rb'
require '../../lib/util/card.rb'
require '../../lib/util/deck.rb'


	def combination(a,b,log)
	#return a_C_b
		# if a and b isn't int
		if b.to_i > a.to_i then
			log.warn "error"
			return 0.0
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
	

	def create_probabilities_of_lands_in_hand(deck, hand,log)
	#parameter:
		#hand | 0 < x <= hand
		#library | lands_in_deck + other_cards_in_deck = library
		#lands_in_deck
		#other_cards_in_deck
	#the probability p(x)of x lands in hand is
		#p(x) = hand_C_x * {(lands_in_deck/library)** x} * {(other_cards_in_deck/library ** (hand - x)}
	#sum^hand_n=0(p(n)) = 1
		log.info "create_probabilities_of_lands_in_hand start."
		probabilities_of_lands_in_hand = Array.new(hand+1)

		library = deck.calc_num_of_mainboard_cards_in_deck
		lands_in_deck = deck.calc_num_of_lands_in_deck
		other_cards_in_deck = library - lands_in_deck

		log.debug "library[" + library.to_s + "]"
		log.debug "lands_in_deck[" + lands_in_deck.to_s + "]"
		log.debug "other_cards_in_deck[" + other_cards_in_deck.to_s + "]"
		sum_of_p = 0
		for x in 0..hand
			log.debug  "p[" + x.to_s + "] = "
			log.debug  combination(hand, x, log).to_s + " * "
			log.debug  ((lands_in_deck.to_f/library.to_f) ** x.to_i).to_s + " * "
			log.debug  ((other_cards_in_deck.to_f/library.to_f) ** (hand - x).to_i)
			probabilities_of_lands_in_hand[x] =  \
				100.0 * combination(hand, x, log).to_f * \
					((lands_in_deck.to_f/library.to_f) ** x.to_i) * \
						((other_cards_in_deck.to_f/library.to_f) ** (hand - x).to_i)
			log.debug " = " + probabilities_of_lands_in_hand[x].to_s
			sum_of_p += probabilities_of_lands_in_hand[x].to_f
		end
		log.debug "sum_of_p = " + sum_of_p.to_s
		log.info "create_probabilities_of_lands_in_hand finished."
		return probabilities_of_lands_in_hand
	end


	def calc_probability_of_more_than_x_lands_in_hand( \
			probabilities_of_lands_in_hand, x, hand,log)
		#return sum^hand_n=x p(n)
		#TODO: if size not equal
		log.info "calc_probability_of_more_than_x_lands_in_hand start."
		sum = 0.0
		for n in x..hand
			sum += probabilities_of_lands_in_hand[n]
		end
		log.info "calc_probability_of_more_than_x_lands_in_hand finished. return " + sum.to_s
		return sum
	end



	def create_a_deck_with_target_number_of_cards(num_of_cards, num_of_lands, log)
		deck = Deck.new("#{num_of_lands}/#{num_of_cards}", "simulation", "", @log)
		land_cards = Card.new("land", @log)
		land_cards.card_type = "land"
		land_cards.quantity = num_of_lands
		deck.cards.push(land_cards)
		other_cards = Card.new("MainboardCard", @log)
		other_cards.card_type = "MainboardCard"
		other_cards.quantity = num_of_cards - num_of_lands
		deck.cards.push(other_cards)

		return deck
	end



	def algorithm_A_simple(x, y, deck, log)
#	if X >= Y then
#		return 0
#	else (X < Y)
#		return t = (Y - X) / (ll_i/lib_i)
#	end
# For more information, read "../../lib/calculation/calc_how_many_turns_to_draw_x_lands.rb"
		if x >= y then
			return 0
		else
			return ((y.to_f - x.to_f) / (deck.calc_num_of_lands_in_deck.to_f / deck.calc_num_of_mainboard_cards_in_deck.to_f)).to_f
		end
	end

	def algorithm_A2_simple(x, y, hand, deck, log)
#	if X >= Y then
#		return 0
#	else (X < Y)
#		return t = (Y - X) / (ll_c/lib_c)
#	end
# For more information, read "../../lib/calculation/calc_how_many_turns_to_draw_x_lands.rb"
		if x >= y then
			return 0
		else
			lands_in_current_deck = deck.calc_num_of_lands_in_deck - x
			cards_in_current_deck = deck.calc_num_of_mainboard_cards_in_deck - hand

			return ((y.to_f - x.to_f) / (lands_in_current_deck.to_f / cards_in_current_deck.to_f)).to_f
		end
	end

	def algorithm_B_correct(lands_in_current_hand, expecting_land, cards_in_current_hand, draw_per_turn, deck, log)
#	Parameters
#		X: number of lands in current hand
#		Y: expecting land
#		Z: number of cards already drawn
#		T: additional turns you need to draw Y lands if you have X lands in hand now.
#
#		 	T = sum^infinity_k=t{ t * p(k, Y-X)_deck(t)}
#		 	  = sum^N_t=0 p(x'(t),Y-X,)_deck(t) * t
#		 	here,
#		 	N = round_down(cards_in_deck / draw_per_turn)
#			x'(t) = t * draw_per_turn
#			deck(t) consists of
#				cards_in_deck = initial_cards_in_deck - Z - t * draw_per_turn
#				land_in_deck = initial_lands_in_deck - X - drawn_land(t-1)
#				drawn_land(t-1), which is the number of lands drew until turn t-1, 
#				 = ((t-1) * draw_per_turn) * (initial_lands_in_deck/initial_cards_in_deck)

# For more information, read "../../lib/calculation/calc_how_many_turns_to_draw_x_lands.rb"
		if lands_in_current_hand >= expecting_land then
			return 0
		else
			lands_in_initial_deck = deck.calc_num_of_lands_in_deck
			cards_in_initial_deck = deck.calc_num_of_mainboard_cards_in_deck
			lands_in_current_deck = lands_in_initial_deck - lands_in_current_hand
			cards_in_current_deck = cards_in_initial_deck - cards_in_current_hand
			puts "cards_in_current_deck[#{cards_in_current_deck}],draw_per_turn[#{draw_per_turn}],"

			sum = 0.0
			if (cards_in_current_deck == 0) || (lands_in_current_deck) then
				puts "error"
			end
			n = (cards_in_current_deck.to_f/draw_per_turn).to_i
			for t in 1..n
				drawn_lands = ((t - 1) * draw_per_turn + cards_in_current_hand ) * (lands_in_initial_deck.to_f / cards_in_initial_deck.to_f)
				lands_in_deck = lands_in_initial_deck - drawn_lands
				cards_in_deck = cards_in_initial_deck - (t-1) * draw_per_turn
				deck = create_a_deck_with_target_number_of_cards(cards_in_deck, lands_in_deck, log)
				y = expecting_land - lands_in_current_hand - drawn_lands
				x = cards_in_current_hand + t * draw_per_turn
				puts "combination(#{x},#{y})[#{combination(x, y, log).to_f.round(3)}]"
				puts "(lands_in_deck.to_f/cards_in_deck.to_f)[#{(lands_in_deck.to_f/cards_in_deck.to_f).round(3)}]"
				puts "((cards_in_deck - lands_in_deck).to_f/cards_in_deck.to_f)[#{((cards_in_deck - lands_in_deck).to_f/cards_in_deck.to_f).round(3)}]"
				probability = combination(x, y, log).to_f *
						((lands_in_deck.to_f/cards_in_deck.to_f) ** y) *
						(((cards_in_deck - lands_in_deck).to_f/cards_in_deck.to_f) ** x)
				puts "t[#{t}],drawn_lands(t-1)[#{drawn_lands.round(1)}],lands_in_deck[#{lands_in_deck.round(1)}],cards_in_deck[#{cards_in_deck}],x[#{x}],y[#{y}],p[#{probability}]"
				sum += t * probability
			end
			return sum
		end
	end

