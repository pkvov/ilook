class CreateNameCategoryDics < ActiveRecord::Migration
  def self.up
    create_table :name_category_dics do |t|
      t.string :name
      t.integer :category_id
      t.timestamps
    end
  end

  def self.down
    drop_table :name_category_dics
  end
end
