class CreateMarkets < ActiveRecord::Migration
  def self.up
    create_table :markets do |t|
      t.string :name
      t.integer :area_id
      t.text :info
      t.timestamps
    end
  end

  def self.down
    drop_table :markets
  end
end
