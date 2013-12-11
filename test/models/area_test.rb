require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class AreaTest < Test::Unit::TestCase
  context "Area Model" do
    should 'construct new instance' do
      @area = Area.new
      assert_not_nil @area
    end
  end
end
