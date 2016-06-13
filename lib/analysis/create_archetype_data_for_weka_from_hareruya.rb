
#ruby
require "logger"

require '../../lib/util/deck.rb'
require '../../lib/util/store.rb'
require '../../lib/util/archetype_selector.rb'

begin
	puts File.basename(__FILE__).to_s + " start."
	log = Logger.new("../../log")
	log.info ""
	log.info File.basename(__FILE__).to_s + " start."
	log.info ""

	log.level = Logger::DEBUG


	#### access to hareruya and create deck files.
	##
	log.info "access to hareruya and create deck files."
	hareruya = Hareruya.new(log)


	#### create weka attributes
	filename = "../../data_for_analysis/hareruya1_archetypes.arff"
	str = ""
	for i in 0..75
		str = str.to_s + "card" + i.to_s + "\n"
	end	
	File.open(filename, "w:sjis") do |file|
		file.puts "@archetype_prediction
@archetype
@data
"
		file.close
	end

	archetype_selector = Archetype_selector.new(log)


	#### read deck files and write weka data.
	File.open(filename, "a:sjis") do |file|
		Dir::glob("../../decks/hareruya_auto/*.csv").each do |filename|
			log.debug "filename[" + filename.to_s + "]"
			puts "#{filename} start."
			if !filename.include?("decklist.csv") then
				deck = hareruya.read_deckfile(filename, "card_type,cardname,quantity,manacost,generating_mana_type,price,store_url,price.date", "with_info")
				*,deck.id = filename.split('_')
				deck.store = hareruya
				deck.archetype = archetype_selector.select_archetype_of deck, by:'store'
				weka_line = deck.archetype.to_s + "," + archetype_selector.create_explanatory_variable(deck).to_s
				log.debug "weka_line[" + weka_line.to_s + "]"
				file.puts weka_line
			end
		end
		file.close
	end

rescue => e
	puts_write(e,log)
end


log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."


