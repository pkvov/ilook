class AddIndexToGoods < ActiveRecord::Migration
  def self.up
    add_index(:goods, [:name, :market_id, :date], :unique => true)
    add_index(:goods, [:market_id, :category_id, :date])
  end

  def self.down
    remove_index :goods, :column => [:name, :market_id, :date]
    remove_index :goods, :column => [:market_id, :category_id, :date]
  end
end
