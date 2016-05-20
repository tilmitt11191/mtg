
require '../../lib/util/util.rb'
require '../../lib/util/deck.rb'

puts "test_cases/deck.create_deckfile.rb start"

deckname = "BG Con JF"
deck = Deck.new(deckname, "hareruya", "http://www.hareruyamtg.com/jp/k/kD08246S/")
deck.read_deckfile("../../decks/BGConJF.csv", "card_type,name,quantity,price,store_url,price.date,generating_mana_type", "with_price")

## set info
hareruya = Hareruya.new()
hareruya.convert_all_cardname_from_jp_to_eng(deck)

#with_info
deck.create_deckfile("../../test_cases/decklists/test_BGConJF.csv", "card_type,name,quantity,price,store_url,price.date", "with_info")
#diff("../../decks/BGConJF.csv", "../../test_cases/decklists/test_BGConJF.csv") #TODO
