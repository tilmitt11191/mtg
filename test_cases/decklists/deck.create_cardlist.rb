
#ruby
require '../../lib/util/deck.rb'

deckname = "EldraziStompykD09256S"

deck = Deck.new(deckname, "hareruya", "http://www.hareruyamtg.com/jp/k/kD09256S/")

deck.create_cardlist
deck.view_deck_list