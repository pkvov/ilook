class Goods < ActiveRecord::Base
  belongs_to :category
  belongs_to :market
  belongs_to :unit

  def self.change_name_category(name, category_id)
    #change name_category_dic
    dic_item = NameCategoryDic.find_or_create_by_name(name)
    dic_item.category_id = category_id
    dic_item.save
    #update current goods
    Goods.update_all("category_id = #{category_id}", "name = '#{name}'")
  end

end
