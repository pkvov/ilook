class ChangeFieldToGoods < ActiveRecord::Migration
  def self.up
    change_column :goods, :high, :decimal, :precision => 10, :scale => 3
    change_column :goods, :low, :decimal, :precision => 10, :scale => 3
  end

  def self.down
    change_column :goods, :high, :decimal, :precision =>  6, :scale => 2
    change_column :goods, :low, :decimal, :precision => 6, :scale => 2
  end
end
