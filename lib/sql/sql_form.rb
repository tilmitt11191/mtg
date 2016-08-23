# encoding: UTF-8
#ruby
require 'active_record'
require '../../lib/util/card.rb'

class Card_for_db < ActiveRecord::Base
	self.table_name = 'cards'
	validates_presence_of :name, :color, :cardtype, :oracle, :illustrator, :rarity, :cardset
	# :manacost, :manacost_point, :price, :date, :store_url, :powertoughness, :generating_mana_type,
	
	def initialize card,log
		log.info "Card_for_db.initialize(#{card.name}) start."
		super(name:card.name,
			price: card.price,
			date: card.date,
			store_url: card.store_url,
			generating_mana_type: card.generating_mana_type,
			manacost: card.manacost,
			color: card.color,
			manacost_point: card.manacost_point,
			cardtype: card.cardtype,
			oracle: card.oracle,
			powertoughness: card.powertoughness,
			illustrator: card.illustrator,
			rarity: card.rarity,
			cardset: card.cardset)
	end
	
	def to_s
		"{name=>#{name}, price=>#{price}, date=>#{date}, store_url=>#{store_url}, generating_mana_type=>#{generating_mana_type}, manacost=>#{manacost}, color=>#{color}, manacost_point=>#{manacost_point}, cardtype=>#{cardtype}, oracle=>#{oracle}, powertoughness=>#{powertoughness}, illustrator=>#{illustrator}, rarity=>#{rarity}, cardset=>#{cardset}"
	end
	
	def select name
		@log.info "#{__method__}(#{name}) start."
	end
end