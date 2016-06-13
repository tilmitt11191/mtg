
#ruby
require "logger"

require '../../lib/util/deck.rb'
require '../../lib/util/store.rb'
require '../../lib/util/mana_analyzer.rb'

puts File.basename(__FILE__).to_s + " start."
log = Logger.new("../../log", 5, 10 * 1024 * 1024)
log.info ""
log.info File.basename(__FILE__).to_s + " start."
log.info ""

log.level = Logger::INFO


#### access to hareruya and create deck files.
##
log.info "access to hareruya and create deck files."
hareruya = Hareruya.new(log)


#### create weka attributes
filename = "../../data_for_analysis/hareruya1.arff"
File.open(filename, "w:sjis") do |file|
	file.puts "@relation mana_analysis

@attribute sum numeric %111
@attribute n_w numeric %0
@attribute n_u numeric %0
@attribute n_b numeric %47
@attribute n_r numeric %0
@attribute n_g numeric% 7
@attribute n_c numeric% 0

@attribute g_w numeric %3
@attribute g_u numeric %3
@attribute g_b numeric %21
@attribute g_r numeric %3
@attribute g_g numeric %14
@attribute g_c numeric %2

@data
"
	file.close
end


#### read deck files and write weka data.
File.open(filename, "a:sjis") do |file|
	Dir::glob("../../decks/hareruya_auto/*.csv").each do |filename|
		log.debug "filename[" + filename.to_s + "]"
		deck = hareruya.read_deckfile(filename, "card_type,cardname,quantity,manacost,generating_mana_type,price,store_url,price.date", "with_info")
		mana_analyzer = Mana_analyzer.new(deck, log)
		weka_line = mana_analyzer.convert_sum_of_mana_to_weka_format()
		log.debug "weka_line[" + weka_line.to_s + "]"
		file.puts weka_line
	end
	file.close
end

=begin
@attribute sum_of_manacost_point_at_mainboard numeric %111
@attribute needed_white_mana_at_mainboard numeric %0
@attribute needed_blue_mana_at_mainboard numeric %0
@attribute needed_black_mana_at_mainboard numeric %47
@attribute needed_red_mana_at_mainboard numeric %0
@attribute needed_green_mana_at_mainboard numeric% 7
@attribute needed_colorless_mana_at_mainboard numeric% 0

@attribute generating_white_mana_at_mainboard numeric %3
@attribute generating_blue_mana_at_mainboard numeric %3
@attribute generating_black_mana_at_mainboard numeric %21
@attribute generating_red_mana_at_mainboard numeric %3
@attribute generating_green_mana_at_mainboard numeric %14
@attribute generating_colorless_mana_at_mainboard numeric %2
=end
