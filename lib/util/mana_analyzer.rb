
#ruby
require	"logger"
require '../../lib/util/card.rb'

class Mana_analyzer
	@log

	@deck

	@sum_of_manacost_point_at_mainboard # <- 111
	@sum_of_manacost_point_at_sideboard # <- 33
	@sum_of_needed_mana_at_mainboard # <- W0U0B47R0G7C0
	#needed_white_mana_at_mainboard
	#needed_blue_mana_at_mainboard
	#needed_black_mana_at_mainboard # <- 47
	#needed_red_mana_at_mainboard
	#needed_green_mana_at_mainboard
	@sum_of_needed_mana_at_sideboard # <- W0U0B12R0G4C0
	#needed_white_mana_at_sideboard
	#needed_blue_mana_at_sideboard
	#needed_black_mana_at_sideboard # <-12
	#needed_red_mana_at_sideboard
	#needed_green_mana_at_sideboard
	
	@sum_of_generating_mana_at_mainboard # <- W3U3B21R3G14C2A3
	#generating_white_mana_at_mainboard # <- 3
	#generating_blue_mana_at_mainboard
	#generating_black_mana_at_mainboard
	#generating_red_mana_at_mainboard
	#generating_green_mana_at_mainboard
	#generating_colorless_mana_at_mainboard
	@sum_of_generating_mana_at_sideboard # <- W0U0B0R0G0C0A0
	#generating_white_mana_at_sideboard # <- 0
	#generating_blue_mana_at_sideboard
	#generating_black_mana_at_sideboard
	#generating_red_mana_at_sideboard
	#generating_green_mana_at_sideboard
	#generating_colorless_mana_at_sideboard
	attr_accessor :sum_of_needed_mana_at_mainboard, :sum_of_needed_mana_at_sideboard,
:sum_of_manacost_point_at_mainboard, :sum_of_manacost_point_at_sideboard, :sum_of_generating_mana_at_mainboard, :sum_of_generating_mana_at_sideboard


	def initialize(deck, log)
	#if no deck, set nil.
	#at such time using only get_generating_mana_type(card).
		@log = log
		@log.info "Mana_analyzer.initialize"
		@deck = deck
		@sum_of_manacost_point_at_mainboard = 0
		@sum_of_manacost_point_at_sideboard = 0
		@sum_of_needed_mana_at_mainboard = ""
		@sum_of_needed_mana_at_sideboard = ""
		@sum_of_generating_mana_at_mainboard = ""
		@sum_of_generating_mana_at_sideboard = ""
	end
	
	def decompose_generationg_mana_symbol(str)
	#C-B-G -> ["C", "B", "G"]
	#RR-GG -> ["RR", "GG"]
		@log.info "decompose_generationg_mana_symbol(" + str.to_s + ") start."
		if str.nil?
			@log.error "str is nil at Mana_analyzer.decompose_generationg_mana_symbol(str)."
		elsif str.match("W|U|B|R|G|C|A") then
			manas = str.split('-')
			@log.debug "return " + manas.to_s
			return manas
		else
			@log.debug "return nil"
			return nil
		end
	end

	def decompose_needed_mana_symbol(str)
	#U -> ["U"]
	#WW -> ["W", "W"]
	#2BB -> ["2", "B", "B"]
	#12GGG -> ["12", "G", "G", "G"]
		@log.info "decompose_needed_mana_symbol(" + str.to_s + ") start."
		if str.nil?
			@log.error "str is nil at Mana_analyzer.decompose_needed_mana_symbol(str)."
			return nil
		elsif str.match("[0-9]|W|U|B|R|G|C|A") then
			manas = []
			if str.match(/[0-9]/) then #extract number
				manas.push(str.gsub(/[^0-9]/,""))
			end
			if str.match(/[^0-9]/) then #extract other
				manas.concat(str.gsub(/[0-9]/,"").split(""))
			end
			@log.debug "return " + manas.to_s
			return manas
		else
			@log.debug "return nil"
			return nil
		end
	end


	def get_generating_mana_type(card)
		@log.info "card[" + @name.to_s + "].set_generating_mana_type start."
		#Mountain =>R
		#Caves of Koilos => C-W-B
		#Highland Lake => U-R
		#Westvale Abbey => C
		#Shambling Vent => W-B
		#Corrupted Crossroads => C-A
			#A = any color

		#analyze_cardtype
		cardtype = analyze_cardtype(card)
		
		@log.info "set_generating_mana_type(" + card.name.to_s + ") start."
		case cardtype
		when "nil" then 
			@log.info "set_generating_mana_type(" + card.name.to_s + ") finished.return nil."
			@log.info "Please set manually. set_generating_mana_type(" + card.name.to_s + ") finished."
			@generating_mana_type = "nil"
			return @generating_mana_type
		when "basicLand"
			@log.debug "basic land"
			@generating_mana_type = card.oracle
			return @generating_mana_type

		when "damageLand","shadowLand", "SOItapinLand","KTKtapinLand","BFZMishraLand","battleLand" then
			@log.debug "major land"
			@generating_mana_type = extract_mana_from_major_land(card)
			return @generating_mana_type
		
		when "anyColorLandtypeA" then
			@log.debug "any color land"
			@generating_mana_type = extract_mana_from_any_color_land(card)
			return @generating_mana_type

		when "abilityColorlessLandtypeA" then
			@log.debug "ability Colorless Land typeA"
			@generating_mana_type = extract_mana_from_major_land(card)
			return @generating_mana_type

		when "wastes" then
			@log.debug "wastes"
			@generating_mana_type = "C"
			return @generating_mana_type
			
		else
			@log.debug "else"
			@log.info "Please set manually. set_generating_mana_type(" + card.name.to_s + ") finished."
			@generating_mana_type = "manually"
			return @generating_mana_type
		end
		@log.error "must return before"
	end

	def analyze_cardtype(card)
		#return land type, such as "basicLand" "damageLand" ...
		@log.info "analyze_cardtype(" + card.name.to_s + ") start."
		@log.debug "card.oracle="
		@log.debug card.oracle
		
		if card.oracle.nil? then
			@log.debug "oracle is nil.return nil."
			return "nil"
		end

		# basic land
		if card.oracle == "W" || card.oracle == "U" || card.oracle == "B" || card.oracle == "R" || card.oracle == "G" then #basic land
			@log.debug "cardtype is basicLand. analyze_cardtype finished."
			return "basicLand"
		end

		# Wastes
		if card.name == "Wastes" then
			@log.debug "cardtype is wastes. analyze_cardtype finished."
			return "wastes"
		end

		# damage land
		# Caves of Koilos
			#{T}: Add {C} to your mana pool.{T}: Add {W} or {B} to your mana pool. Caves of Koilos deals 1 damage to you.
		if card.oracle.lines.size == 2 &&
			card.oracle.lines[1].match("Add {.+} to your mana pool.+deals 1 damage to you") then
				@log.debug "cardtype is damageLand. analyze_cardtype finished."
				return "damageLand"
		end

		#shadowLand
		#"Game Trail"
			#As Game Trail enters the battlefield, you may reveal a Mountain or Forest card from your hand. If you don&apos;t, Game Trail enters the battlefield tapped.
			#{T}: Add {R} or {G} to your mana pool.card = Card.new("Sunken Hollow")
		if card.oracle.lines.size == 2 &&
			card.oracle.lines[0].match("As.+you may reveal a.+enters the battlefield tapped")	&& 
				card.oracle.lines[1].match(".+Add {.} or {.} to your mana pool") then
				return "shadowLand"
		end
		
		# SOI tapin land
		# Highland Lake
			#Highland Lake enters the battlefield tapped.
			#{T}: Add {U} or {R} to your mana pool.
		if card.oracle.lines.size == 2 &&
			card.oracle.lines[0].match(".+enters the battlefield tapped")	&& 
				card.oracle.lines[1].match(".+Add {.} or {.} to your mana pool") then
				return "SOItapinLand"
		end

		# KTK tapin land
		# Opulent Palace
			#Opulent Palace enters the battlefield tapped.
			#{T}: Add {B}, {G}, or {U} to your mana pool.
		if card.oracle.lines.size == 2 &&
			card.oracle.lines[0].match(".+enters the battlefield tapped")	&& 
				card.oracle.lines[1].match(".+Add {.}, {.}, or {.} to your mana pool") then
				return "KTKtapinLand"
		end

		# BFZ Mishra Land
		#Shambling Vent
			#Shambling Vent enters the battlefield tapped.
			#{T}: Add {W} or {B} to your mana pool.
			#{1}{W}{B}: Shambling Vent becomes a 2/3 white and black Elemental creature with lifelink until end of turn. It's still a land.
		card.oracle.lines do |line|
			if line.match(" becomes .+ creature .+ until end of turn") then
				return "BFZMishraLand"
			end
		end

		# BFZ battle Lnad
		#"Sunken Hollow"
			#{T}: Add {U} or {B} to your mana pool.j
			#Sunken Hollow enters the battlefield tapped unless you control two or more basic lands.
		if card.oracle.lines.size == 2 &&
			card.oracle.lines[0].match(".+Add {.} or {.} to your mana pool")	&& 
			card.oracle.lines[1].match("enters the battlefield tapped unless you control two or more basic lands") then
			return "battleLand"
		end

		#abilityLandtypeA
		#this rule is very wide, but adapted only colorless land.
		#Westvale Abbey
			#{T}: Add {C} to your mana pool.
			#{5}, {T}, Pay 1 life: Put a 1/1 white and black Human Cleric creature token onto the battlefield.
			#{5}, {T}, Sacrifice five creatures: Transform Westvale Abbey, then untap it.
		card.oracle.lines do |line|
			if line.match("{T}: Add {C} to your mana pool.") then
				return "abilityColorlessLandtypeA"
			end
		end

		#anyColorLandtypeA
		#Corrupted Crossroads
			#{T}: Add {C} to your mana pool. ¡Ê{C} represents colorless mana.¡Ë
			#{T}, Pay 1 life: Add one mana of any color to your mana pool. Spend this mana only to cast a spell with devoid.
		card.oracle.lines do |line|
			if line.match("Add .+ mana of any color") then
				return "anyColorLandtypeA"
			end
		end

		@log.debug "cardtype is nil.return."
		return "nil"
	end
	

	def extract_mana_from_major_land(card)
		@log.info "extract_mana_from_major_land(" + card.name.to_s + ") start"
		#Westvale Abbey
		#{T}: Add {C} to your mana pool.{5}, {T}, Pay 1 life: Put a 1/1 white and black Human Cleric creature token onto the battlefield.{5}, {T}, Sacrifice five creatures: Transform Westvale Abbey, then untap it.

		@generating_mana_type = ""
		card.oracle.lines do |line|
			if line.match("Add {.+} to your mana pool") then
				#remove meta strings.
				@log.debug line.gsub!(/Â¥|/,"")
				#remove irrelevant strings.
				@log.debug line.gsub!(/Add {/, "").gsub!(/} to your mana pool.+/, "")
				#convert "or" to meta string.
				@log.debug line.gsub!(/or/, "|")
				#remove all irrelevant strings.
				line.scan(/C|W|U|B|R|G/).each do |mana|
					@log.debug @generating_mana_type += "-" + mana.to_s
				end
			end
		end
		@log.debug @generating_mana_type.gsub!(/^-/,"")
		return @generating_mana_type
	end

	def extract_mana_from_any_color_land(card)
		@generating_mana_type = "C-A"
		return @generating_mana_type
	end


	def calc_sum_of_needed_mana()
		@log.info "calc_sum_of_needed_mana(" + @deck.deckname.to_s + ") start."
		#initialize each color of mainboardcards.
		mwhite = 0; mblue = 0; mblack = 0; mred = 0; mgreen =0; mcolorless = 0
		#initialize each color of sideboardcards.
		swhite = 0; sblue = 0; sblack = 0; sred = 0; sgreen =0; scolorless = 0
		@deck.cards.each do |card|
			@log.debug "card_type[" + card.card_type.to_s + "], card.name[" + card.name.to_s + "], card.quantity[" + card.quantity.to_s + "], manacost[" + card.manacost.to_s + "]"
			manas = decompose_needed_mana_symbol(card.manacost.to_s)
			if manas.nil? then
				@log.debug "manas[nil]"
			else
				@log.debug "manas[" + manas.to_s + "]"
			end
			case card.card_type
			when "land", "creature", "spell", "mainboardCards" then
				if !manas.nil? then manas.each do |mana|
					case mana
					when /[0-9]/ then
						@sum_of_manacost_point_at_mainboard += (mana.to_i * card.quantity.to_i)
					when "W" then
						mwhite += card.quantity.to_i
						@sum_of_manacost_point_at_mainboard += card.quantity.to_i
					when "U" then
						mblue +=  card.quantity.to_i
						@sum_of_manacost_point_at_mainboard += card.quantity.to_i
					when "B" then
						mblack +=  card.quantity.to_i
						@sum_of_manacost_point_at_mainboard += card.quantity.to_i
					when "R" then
						mred +=  card.quantity.to_i
						@sum_of_manacost_point_at_mainboard += card.quantity.to_i
					when "G" then
						mgreen +=  card.quantity.to_i
						@sum_of_manacost_point_at_mainboard += card.quantity.to_i
					when "C" then
						mcolorless +=  card.quantity.to_i
						@sum_of_manacost_point_at_mainboard += card.quantity.to_i
					end
				end end
			when "sideboardCards" then
				if !manas.nil? then manas.each do |mana|
					case mana
					when /[0-9]/ then
						@sum_of_manacost_point_at_sideboard += (mana.to_i * card.quantity.to_i)
					when "W" then
						swhite += card.quantity.to_i
						@sum_of_manacost_point_at_sideboard += card.quantity.to_i
					when "U" then
						sblue +=  card.quantity.to_i
						@sum_of_manacost_point_at_sideboard += card.quantity.to_i
					when "B" then
						sblack +=  card.quantity.to_i
						@sum_of_manacost_point_at_sideboard += card.quantity.to_i
					when "R" then
						sred +=  card.quantity.to_i
						@sum_of_manacost_point_at_sideboard += card.quantity.to_i
					when "G" then
						sgreen +=  card.quantity.to_i
						@sum_of_manacost_point_at_sideboard += card.quantity.to_i
					when "C" then
						scolorless +=  card.quantity.to_i
						@sum_of_manacost_point_at_sideboard += card.quantity.to_i
					end
				end end
			end
		end
		@sum_of_needed_mana_at_mainboard = "W"+mwhite.to_s+"U"+mblue.to_s+"B"+mblack.to_s+"R"+mred.to_s+"G"+mgreen.to_s+"C"+mcolorless.to_s
		@sum_of_needed_mana_at_sideboard = "W"+swhite.to_s+"U"+sblue.to_s+"B"+sblack.to_s+"R"+sred.to_s+"G"+sgreen.to_s+"C"+scolorless.to_s
		@log.debug "sum of needed mana(" + @deck.deckname.to_s + ")"
		@log.debug "main is [" + @sum_of_needed_mana_at_mainboard.to_s + "]"
		@log.debug "side is [" + @sum_of_needed_mana_at_sideboard.to_s + "]"
		return [@sum_of_needed_mana_at_mainboard.to_s, @sum_of_needed_mana_at_sideboard.to_s]
	end


	def calc_sum_of_generating_mana()
		@log.info "calc_sum_of_generating_mana(" + @deck.deckname.to_s + ") start."
		#initialize each color of mainboardcards.
		mwhite = 0; mblue = 0; mblack = 0; mred = 0; mgreen =0; mcolorless = 0; manycolor = 0
		#initialize each color of sideboardcards.
		swhite = 0; sblue = 0; sblack = 0; sred = 0; sgreen =0; scolorless = 0; sanycolor = 0

		@deck.cards.each do |card|
			@log.debug "card.name[" + card.name.to_s + "]"
			@log.debug "card_type[" + card.card_type.to_s + "], card.name[" + card.name.to_s + "], card.quantity[" + card.quantity.to_s + "], manacost[" + card.manacost.to_s + "]"
			manas = decompose_generationg_mana_symbol(card.generating_mana_type)
			if manas.nil? then
				@log.debug "manas[nil]"
			else
				@log.debug "manas[" + manas.to_s + "]"
			end

			case card.card_type
			when "land", "creature", "spell", "mainboardCards" then
				if !manas.nil? then manas.each do|mana|
					case mana
					when "W" then
						mwhite += card.quantity.to_i
					when "U" then
						mblue +=  card.quantity.to_i
					when "B" then
						mblack +=  card.quantity.to_i
					when "R" then
						mred +=  card.quantity.to_i
					when "G" then
						mgreen +=  card.quantity.to_i
					when "C" then
						mcolorless +=  card.quantity.to_i
					when "A" then
						mwhite +=  card.quantity.to_i
						mblue +=  card.quantity.to_i
						mblack +=  card.quantity.to_i
						mred +=  card.quantity.to_i
						mgreen +=  card.quantity.to_i
						manycolor +=  card.quantity.to_i
					end
				end end
			when "sideboardCards" then
				if !manas.nil? then manas.each do|mana|
					case mana
					when "W" then
						swhite += card.quantity.to_i
					when "U" then
						sblue +=  card.quantity.to_i
					when "B" then
						sblack +=  card.quantity.to_i
					when "R" then
						sred +=  card.quantity.to_i
					when "G" then
						sgreen +=  card.quantity.to_i
					when "C" then
						scolorless +=  card.quantity.to_i
					when "A" then
						swhite +=  card.quantity.to_i
						sblue +=  card.quantity.to_i
						sblack +=  card.quantity.to_i
						sred +=  card.quantity.to_i
						sgreen +=  card.quantity.to_i
						sanycolor +=  card.quantity.to_i
					end
				end end
			end
		end

		@sum_of_generating_mana_at_mainboard = "W"+mwhite.to_s+"U"+mblue.to_s+"B"+mblack.to_s+"R"+mred.to_s+"G"+mgreen.to_s+"C"+mcolorless.to_s+"A"+manycolor.to_s
		@deck.sum_of_mainboard_generating_manas = @sum_of_generating_mana_at_mainboard
		@sum_of_generating_mana_at_sideboard = "W"+swhite.to_s+"U"+sblue.to_s+"B"+sblack.to_s+"R"+sred.to_s+"G"+sgreen.to_s+"C"+scolorless.to_s+"A"+sanycolor.to_s
		@deck.sum_of_sideboard_generating_manas = @sum_of_generating_mana_at_sideboard
		@log.debug "sum of generating mana(" + @deck.deckname.to_s + ")"
		@log.debug "main is [" + @sum_of_generating_mana_at_mainboard.to_s + "]"
		@log.debug "side is [" + @sum_of_generating_mana_at_sideboard.to_s + "]"
		return [@sum_of_generating_mana_at_mainboard.to_s, @sum_of_generating_mana_at_sideboard.to_s]
	end

	def convert_sum_of_mana_to_weka_format
	#output 111,0,0,47,0,7,0,3,3,21,3,14,2 %deckname
		if @deck.nil? then
			@log.error "deck is nil at convert_sum_of_mana_to_weka_format()"
		end
		@log.info "calc_sum_of_generating_mana(" + @deck.deckname.to_s + ") start."

		@log.debug "sum_of_needed_mana check[" + @sum_of_needed_mana_at_mainboard.to_s + "]"
		if !@sum_of_needed_mana_at_mainboard.match(/^W[0-9][0-9]*U[0-9][0-9]*B[0-9][0-9]*R[0-9][0-9]*G[0-9][0-9]*C[0-9][0-9]*$/) then
			@log.debug "sum_of_needed_mana wasn't set."
			calc_sum_of_needed_mana
		end

		@log.debug "sum_of_generating_mana check[" + @sum_of_generating_mana_at_mainboard.to_s + "]"
		if !@sum_of_generating_mana_at_mainboard.match(/^W[0-9][0-9]*U[0-9][0-9]*B[0-9][0-9]*R[0-9][0-9]*G[0-9][0-9]*C[0-9][0-9]*A[0-9][0-9]*$/) then
			@log.debug "sum_of_generating_mana wasn't set."
			calc_sum_of_generating_mana
		end

		@log.debug "sum_of_needed[" + @sum_of_needed_mana_at_mainboard.to_s + "]"
		needed_weka = convert_str_to_weka_format(@sum_of_needed_mana_at_mainboard)
		@log.debug "needed_weka[" + needed_weka.to_s + "]"

		@log.debug "sum_of_generating[" + @sum_of_generating_mana_at_mainboard.to_s + "]"
		generating_weka = convert_str_to_weka_format(@sum_of_generating_mana_at_mainboard)
		@log.debug "generating_weka[" + generating_weka.to_s + "]"

		return @sum_of_manacost_point_at_mainboard.to_s + "," + needed_weka.to_s + "," + generating_weka.to_s + " %" + @deck.deckname.to_s
	end

	def convert_str_to_weka_format(str)
		if str.match(/^W[0-9][0-9]*U[0-9][0-9]*B[0-9][0-9]*R[0-9][0-9]*G[0-9][0-9]*C[0-9][0-9]*$/) then
		#W[0-9]* -> WU is ok
		#W[0-9][0-9]* -> WU is ng
			str.gsub!(/^./,"").gsub!(/[A-Z]/,",")
			return str
		elsif str.match(/^W[0-9][0-9]*U[0-9][0-9]*B[0-9][0-9]*R[0-9][0-9]*G[0-9][0-9]*C[0-9][0-9]*A[0-9][0-9]*$/) then
			str.gsub!(/A[0-9][0-9]*$/,"")
			str.gsub!(/^./,"").gsub!(/[A-Z]/,",")
			return str
		end
	end
end


