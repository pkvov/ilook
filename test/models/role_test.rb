require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class RoleTest < Test::Unit::TestCase
  context "Role Model" do
    should 'construct new instance' do
      @role = Role.new
      assert_not_nil @role
    end
  end
end
