# encoding: UTF-8
#ruby

require '../../lib/util/utils.rb'
require '../../lib/util/deck.rb'
require '../../lib/site/wisdomGuild.rb'

begin
	puts File.basename(__FILE__).to_s + " start."
	@log = Logger.new("../../log")
	@log.info ""
	@log.info File.basename(__FILE__).to_s + " start."
	@log.info ""
	
	packname='Kaladesh'
	short='KLD'
	num_of_cards = 249
	#packname='EldritchMoom'
	#short='EMN'
	#num_of_cards = 205
	#packname='Shadows over Innistrad'
	#short='SOI'
	#num_of_cards = 270
	
	outputfilename = "../../data_for_analysis/cardlistlist_of_#{short}.csv"
	
	cardlist = Deck.new(packname, 'file', outputfilename, @log)
	database = WisdomGuild.new(@log)
	
	for number in 1..num_of_cards
		card = database.get_card_from_url "http://whisper.wisdom-guild.net/card/#{short}#{convert_number_to_triple_digits number}/"
		cardlist.cards.push card if !card.nil?
	end
		cardlist.create_deckfile(outputfilename, 'name,rarity,color,manacost,cardtype,powertoughness,oracle,price,price.date', 'card_only')
	
rescue => e
	write_error_to_log(e,@log)
end


@log.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."
