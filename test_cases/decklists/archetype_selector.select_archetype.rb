
#ruby

STDOUT.sync = true

require 'logger'

require '../../lib/util/archetype_selector.rb'
require '../../lib/util/store.rb'

puts File.basename(__FILE__).to_s + ' start.'
@log = Logger.new('../../log', 5, 10 * 1024 * 1024)
@log.info ''
@log.info File.basename(__FILE__).to_s + ' start.'
@log.info ''

@log.level = Logger::DEBUG

deckname = 'test_BGConJF.csv'
filename = "../../test_cases/decklists/output/#{deckname}"
puts filename
archetype_selector = Archetype_selector.new(@log)

deck = Deck.new(deckname, 'file', filename, @log)
deck.read_deckfile(filename,'card_type,name,quantity,price,store_url,price.date', 'with_info')
deck.archetype = archetype_selector.select_archetype(deck)

#deck.view_deck_list
#Dir::glob("../../decks/hareruya_auto/*.csv").each do |filename|
#end


puts File.basename(__FILE__).to_s + ' finished.'
@log.info File.basename(__FILE__).to_s + ' finished.'
