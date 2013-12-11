require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class MarketTest < Test::Unit::TestCase
  context "Market Model" do
    should 'construct new instance' do
      @market = Market.new
      assert_not_nil @market
    end
  end
end
