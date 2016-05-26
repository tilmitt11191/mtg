
require	"logger"
require '../../lib/util/deck.rb'

class Deck_prices
	@log
	@decks
	
	@decknames #array of str
	@prices #array of str
	@dates #array of str
	@paths #array of str
	
	def initialize(log)
		@log = log
		@log.info "Deck_prices initialize"
		
		@decknames = []
		@prices = []
		@dates = []
		@paths = []
	end
	
	def add(deck)
		@log.debug "Deck_prices add(deck " + deck.deckname.to_s + ")"
		@decknames.push(deck.deckname)
		@prices.push(deck.price)
		@dates.push(deck.date)
		@paths.push(deck.path)
	end
	
	def read(filename)
		#BG Con,82610,2016-05-08T11:18:37+09:00,http://www.hareruyamtg.com/jp/k/kD08697S/
		@log.debug "Deck_prices read(" + filename.to_s + ")"
		File.open(filename, "r:sjis").each do |line|
			(deckname,price,date,path) = line.split(",")
			@log.debug "read " + deckname.to_s
			@decknames.push(deckname)
			@prices.push(price)
			@dates.push(date)
			@paths.push(path)
		end
	end
	
	def write(filename)
		@log.debug "Deck_prices write(" + filename.to_s + ")"
		File.open(filename, "w:sjis") do |file|
			for i in 0..@decknames.size-1 do
				file.puts @decknames[i].to_s + "," + @prices[i].to_s + "," + @dates[i].to_s + "," + @paths[i].to_s
			end
		end
	end
end
