
#ruby
require	"logger"
require '../../lib/util/card.rb'

class Mana_analyzer
	@log
	
	def initialize()
		@log = Logger.new("../../log")
		@log.info "Mana_analyzer.initialize"
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

		when "damageLand","SOItapinLand","KTKtapinLand","BFZMishraLand" then
			@log.debug "major land"
			@generating_mana_type = extract_mana_from_major_land(card)
			return @generating_mana_type
		
		when "anyColorLandtypeA" then
			@log.debug "any color land"
			@generating_mana_type = extract_mana_from_any_color_land(card)
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
		#if card.oracle == "W" || card.oracle == "U" || card.oracle == "B" || card.oracle == "R" || card.oracle == "G" then #basic land
		#	@log.debug "cardtype is basicLand. analyze_cardtype finished."
		#	return "basicLand"
		#end

		# damage land
		# Caves of Koilos
			#{T}: Add {C} to your mana pool.{T}: Add {W} or {B} to your mana pool. Caves of Koilos deals 1 damage to you.
		if card.oracle.lines.size == 2 &&
			card.oracle.lines[1].match("Add {.+} to your mana pool.+deals 1 damage to you") then
				@log.debug "cardtype is damageLand. analyze_cardtype finished."
				return "damageLand"
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

end


