
#ruby
require '../../lib/util/deck.rb'
require '../../lib/util/store.rb'

deckname = "WBConkD09283S"
deck = Deck.new(deckname, "hareruya", "http://www.hareruyamtg.com/jp/k/kD09283S/")
deck.read_deckfile("../../test_cases/decklists/WBConkD09283S.csv", "card_type,name,quantity,price,store_url,price.date,generating_mana_type", "with_info")
hareruya = Hareruya.new()
hareruya.convert_all_cardname_from_jp_to_eng(deck)

mo = MagicOnline.new
mo.create_card_list(deck, "../../test_cases/decklists/WBConkD09283S.txt")
