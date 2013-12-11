class CreateGoods < ActiveRecord::Migration
  def self.up
    create_table :goods do |t|
      t.string :name
      t.integer :category_id
      t.integer :market_id
      t.datetime  :date
      t.decimal :high, :precision => 6, :scale => 2
      t.decimal :low,  :precision => 6, :scale => 2
      t.integer :unit_id
      t.timestamps
    end
  end

  def self.down
    drop_table :goods
  end
end
