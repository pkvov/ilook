require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class UnitTest < Test::Unit::TestCase
  context "Unit Model" do
    should 'construct new instance' do
      @unit = Unit.new
      assert_not_nil @unit
    end
  end
end
