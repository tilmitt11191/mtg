
#ruby

STDOUT.sync = true

require "logger"

require '../../lib/util/archetype_selector.rb'
require '../../lib/util/store.rb'

puts File.basename(__FILE__).to_s + " start."
@log = Logger.new("../../log", 5, 10 * 1024 * 1024)
@log.info ""
@log.info File.basename(__FILE__).to_s + " start."
@log.info ""

@log.level = Logger::DEBUG

Dir::glob("../../decks/hareruya_auto/*.csv").each do |filename|
end


puts File.basename(__FILE__).to_s + " finished."
@log.info File.basename(__FILE__).to_s + " finished."
