
require '../../lib/util/deck.rb'
require '../../lib/util/deck_prices.rb'


begin
	puts File.basename(__FILE__).to_s + " start."
	@log = Logger.new("../../log", 5, 10 * 1024 * 1024)
	@log.info ""
	@log.info File.basename(__FILE__).to_s + " start."
	@log.info ""


deckname = "merge_duplicated_cards"
deck = Deck.new(deckname, "for_test", "", @log)

cardnames = []
cardnames.push("Plains")
cardnames.push("Island")
cardnames.push("Swamp")
cardnames.push("Mountain")
cardnames.push("Forest")
cardnames.push("Wastes")

cardnames.push("Exquisite Firecraft")
cardnames.push("Hedron Crawler")
cardnames.push("Make a Stand")
cardnames.push("Void Shatter")
cardnames.push("Spawning Bed")
cardnames.push("Insolent Neonate")

cardnames.push("Plains")
cardnames.push("Island")
cardnames.push("Swamp")
cardnames.push("Mountain")
cardnames.push("Forest")
cardnames.push("Wastes")

cardnames.each do |cardname|
	card = Card.new(cardname,@log)
	card.quantity = '1'
	deck.cards.push(card)
end


#deck.view_deck_list
#puts "----------------"
deck.merge_duplicated_cards!
#deck.view_deck_list



rescue => e
	puts_write(e,@log)
end


@log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."

