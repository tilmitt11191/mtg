
#ruby

STDOUT.sync = true

require "logger"

require '../../lib/util/deck.rb'
require '../../lib/util/store.rb'

puts File.basename(__FILE__).to_s + " start."
@log = Logger.new("../../log", 5, 10 * 1024 * 1024)
@log.info ""
@log.info File.basename(__FILE__).to_s + " start."
@log.info ""

@log.level = Logger::DEBUG

Dir::glob("../../decks/hareruya_auto/*.csv").each do |filename|
	puts filename
end


@log.info File.basename(__FILE__).to_s + " finished."
