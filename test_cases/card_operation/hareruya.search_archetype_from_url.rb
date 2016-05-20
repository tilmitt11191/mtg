
#ruby

require "logger"
require '../../lib/util/store.rb'

puts File.basename(__FILE__).to_s + " start."
log = Logger.new("../../log", 5, 10 * 1024 * 1024)
log.info ""
log.info File.basename(__FILE__).to_s + " start."
log.info ""

url = "http://www.hareruyamtg.com/jp/k/kD08241S/"
hareruya = Hareruya.new()
log.debug "try get_archetype_from_url(" + url.to_s + ")"
archetype = hareruya.get_archetype_from_url(url)
if archetype == "BG_Control" then
	puts "[ok]hareruya.search_archetype_from_url got BG_Control."
else
	puts "[ng]hareruya.search_archetype_from_url.rb"
end

log.info File.basename(__FILE__).to_s + " finished."