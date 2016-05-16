
require '../../lib/util/deck.rb'

#deckname = "4cMonitorCombo"
#deck = Deck.new(deckname, "hareruya", "http://www.hareruyamtg.com/jp/k/kD09281S/")
#deck.create_cardlist_simple
#deck.view_deck_list
#deck.create_deckfile("../../decks/" + deckname.to_s + "_mana.csv")


deckname = "WUB Con"
deck = Deck.new(deckname, "hareruya", "http://www.hareruyamtg.com/jp/k/kD09252S/")
#deck.create_cardlist_simple
#deck.read_deckfile("../../decks/" + deckname.to_s + "_mana.csv", "type,name,quantity")
deck.read_deckfile_simple("../../decks/" + deckname.to_s + ".csv")
deck.get_contents
#deck.view_deck_list
deck.create_deckfile("../../decks/" + deckname.to_s + "_mana.csv", "card_type,name,quantity,generating_mana_type", "with_info")

#export to mtg/decks/***_mana.csv
#right end column means mana type
