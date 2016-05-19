
#ruby
require "logger"

require '../../lib/util/deck.rb'
require '../../lib/util/store.rb'

log = Logger.new("../../log", 5, 10 * 1024 * 1024)
log.info ""
log.info "read-operate-write-deckfiles start."
log.info ""

deckname = "BG_Con_JF"
hareruya = Hareruya.new

#### read deck
#from file
deck = hareruya.read_deckfile("../../decks/" + deckname.to_s + ".csv", "card_type,cardname,quantity,manacost,generating_mana_type,price,store_url,price.date", "with_info")

#from web
#deck = Deck.new(deckname.to_s, "hareruya", "http://www.hareruyamtg.com/jp/k/kD08241S/")
#deck.create_cardlist("full")

#### operate deck
hareruya.convert_all_cardname_from_jp_to_eng(deck)
deck.get_sum_of_generationg_manas
deck.get_contents
#calculate price of each_card_type,
#such as land,creatures,spells,MainboardCards,sideboardCards
#using card.price already set.
deck.calc_price_of_each_card_type
#calculate total price of this deck.
deck.calc_price_of_all_deck

#### write deck
deck.view_deck_list
#deck.create_deckfile("../../decks/" + deckname.to_s + ".csv", "card_type,name,quantity,manacost,generating_mana_type,price,store_url,price.date", "with_info")

