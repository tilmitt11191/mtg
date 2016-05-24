
#ruby
require "logger"
require '../../lib/util/utils.rb'
require '../../lib/util/card.rb'
require '../../lib/util/deck.rb'


	def combination(a,b,log)
	#return a_C_b
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

	
