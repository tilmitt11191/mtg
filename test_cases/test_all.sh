
cd `dirname $0`
cd workspace
ruby ../utils/utils_test.rb
ruby ../utils/card_test.rb
ruby ../utils/deck_test.rb
ruby ../utils/web_test.rb

ruby ../site/channelfireball_test.rb
ruby ../site/hareruya_test.rb
ruby ../site/mtgotraders_test.rb
ruby ../site/smds_test.rb
ruby ../site/wisdomGuild_test.rb

