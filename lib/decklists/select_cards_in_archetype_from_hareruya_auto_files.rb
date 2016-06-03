
#ruby

STDOUT.sync = true

require 'optparse'
opt = OptionParser.new
options = {}
# option parser
options[:files] = '../../decks/hareruya_auto/*.csv'
options[:archetype] = 'WB_Control'

opt.banner = " \
	Usage: #{File.basename($0)} [options]\
	"

opt.on('-h','--help','show help') { print opt.help; exit }
opt.on('-f files', '--files', 'PATH and Filesnames. Default value is ../../decks/hareruya_auto/*.csv',\
			String){|v| options[:files] = v}
opt.on('-a archetype', '--archetype', 'Specify archetype. Default value is WB_Control',\
			String){|v| options[:archetype] = v}

opt.permute!( ARGV )




require "logger"

require '../../lib/util/archetype_selector.rb'
require '../../lib/util/deck.rb'

puts File.basename(__FILE__).to_s + " start."
@log = Logger.new("../../log", 5, 10 * 1024 * 1024)
@log.info ""
@log.info File.basename(__FILE__).to_s + " start."
@log.info ""

@log.level = Logger::DEBUG

deck_num = 0 #number of decks
deckname = options[:archetype]
selected = Deck.new(deckname, "selected_cards", "options[:files]", @log)
Dir::glob(options[:files]).each do |filename|
	if filename.include?(options[:archetype]) then
		@log.debug "filename.include(#{options[:archetype]})[#{filename}]"
		deck_num += 1
		deck = Deck.new(deckname, "selected_cards", "options[:files]", @log)
		deck.read_deckfile(filename,'card_type,name,quantity,price,store_url,price.date', 'with_info')
		@log.debug "deck[#{deck_num}].cards.size[#{deck.cards.size}]"
		selected.cards += deck.cards
		@log.debug "selected.cards.size[#{selected.cards.size}]"
	end
end

selected.merge_duplicated_cards!

selected.cards.each do |card|
	card.quantity = (card.quantity.to_f / deck_num.to_f).round(2)
end
selected.create_deckfile("../../test_cases/workspace/#{options[:archetype]}.csv", "card_type,name,quantity,manacost,generating_mana_type,price,store_url,price.date", 'with_info')

puts File.basename(__FILE__).to_s + " finished."
@log.info File.basename(__FILE__).to_s + " finished."
