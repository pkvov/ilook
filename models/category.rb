class Category < ActiveRecord::Base
  has_many :goods
  has_many :name_category_dics
end
