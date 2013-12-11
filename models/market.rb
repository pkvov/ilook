class Market < ActiveRecord::Base
  belongs_to :area
  has_many :goods
end
