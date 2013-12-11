require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class GoodsTest < Test::Unit::TestCase
  context "Goods Model" do
    should 'construct new instance' do
      @goods = Goods.new
      assert_not_nil @goods
    end
  end
end
