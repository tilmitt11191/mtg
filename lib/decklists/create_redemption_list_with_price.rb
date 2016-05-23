
#ruby
require "logger"
require '../../lib/util/utils.rb'
require '../../lib/util/card.rb'
require '../../lib/util/store.rb'
require '../../lib/util/price_manager.rb'

#get the relevant and highest prices of each card at wishlist.
#the wishlists had created by magic online, which format is
	#Card Name,Quantity,ID #,Rarity,Set,Collector #,Premium,
	#"Display of Dominance",1,56220,Uncommon,DTK,182/264,No
	#"Conifer Strider",1,55900,Common,DTK,179/264,No
	#"Sprinting Warbrute",1,56336,Common,DTK,157/264,No
#the prices are given by Mtgotraders
	#http://www.mtgotraders.com/store/index.html

begin
	puts File.basename(__FILE__).to_s + " start."
	log = Logger.new("../../log", 5, 10 * 1024 * 1024)
	log.info ""
	log.info File.basename(__FILE__).to_s + " start."
	log.info ""


	wishlist_names=[]
	#wishlist_names.push("lists/Redemption_KTK_simple.csv")
#	wishlist_names.push("lists/Redemption_KTK.csv")
#	wishlist_names.push("lists/Redemption_FRF.csv")
	wishlist_names.push("lists/Redemption_DTK.csv")
#	wishlist_names.push("lists/Redemption_SOI.csv")

	store = Mtgotraders.new(log)

	cards=[]
	price_managers={}


	wishlist_names.each do |wishlist_name|
		puts wishlist_name.to_s + " start."
		File.open(wishlist_name, 'r').each do |line|
			if (line.split("\"").size != 1) && #except head line or blank line
				(quantity = line.split("\"")[2].split(',').size == 7) then

				card = Wish_card.new(line, log)
				price_manager = Price_manager.new(card, log)
				store.get_prices(price_manager, relevant:true, highest:true, lowest:false)

				cards.push(card)
				price_managers[:"#{card.name}"] = price_manager
			end
		end

		File.open(wishlist_name.to_s + ".processed.csv", "w:sjis") do |file|
			file.puts "Card Name,Quantity,ID #,Rarity,Set,Collector #,Premium,relevant,highest"

			cards.each do |card|
				contents = card.get_line
				contents.chomp!
				log.debug contents.to_s + "," + price_managers[:"#{card.name}"].relevant_price.to_s + "," + price_managers[:"#{card.name}"].highest_price.to_s
				file.puts contents.to_s + "," + price_managers[:"#{card.name}"].relevant_price.to_s + "," + price_managers[:"#{card.name}"].highest_price.to_s
			end
		end
		puts wishlist_name.to_s + " finished."
	end


rescue => e
	puts_write(e,log)
end


log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."

