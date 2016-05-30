
#ruby

STDOUT.sync = true

require 'logger'

require '../../lib/util/archetype_selector.rb'
require '../../lib/util/store.rb'


begin
	puts File.basename(__FILE__).to_s + ' start.'
	@log = Logger.new('../../log', 5, 10 * 1024 * 1024)
	@log.info ''
	@log.info File.basename(__FILE__).to_s + ' start.'
	@log.info ''

	@log.level = Logger::DEBUG

	deckname = 'test_BGConJF.csv'
	filename = "../../test_cases/decklists/output/#{deckname}"
	archetype_selector = Archetype_selector.new(@log)
	store = Hareruya.new(@log)

	deck1 = Deck.new(deckname, 'file', filename, @log)
	deck1.id = 'kD08246S' #http://www.hareruyamtg.com/jp/k/kD08246S/
	deck1.path = "../../test_cases/decklists/output/#{deckname}"
	deck1.store = store
	deck2 = Deck.new(deckname, 'file', filename, @log)
	deck1.read_deckfile(filename,'card_type,name,quantity,price,store_url,price.date', 'with_info')
	#deck.archetype = archetype_selector.select_archetype do store.select_archetype(deck) end
	#deck.archetype = archetype_selector.select_archetype do store.select_archetype(deck) end
	deck1.archetype = archetype_selector.select_archetype_of deck1, by:'store'
	
	#deck2.archetype = archetype_selector.select_archetype_of deck2, by:'method' do puts "aaa" end
	
	#deck.view_deck_list
	#Dir::glob("../../decks/hareruya_auto/*.csv").each do |filename|
	#end


rescue => e
	puts_write(e,@log)
end


@log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."


