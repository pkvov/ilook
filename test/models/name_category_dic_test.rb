require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class NameCategoryDicTest < Test::Unit::TestCase
  context "NameCategoryDic Model" do
    should 'construct new instance' do
      @name_category_dic = NameCategoryDic.new
      assert_not_nil @name_category_dic
    end
  end
end
