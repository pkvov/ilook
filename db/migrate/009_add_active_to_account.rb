class AddActiveToAccount < ActiveRecord::Migration
  def self.up
    change_table :accounts do |t|
      t.boolean :actived
      t.string :active_code
      t.datetime :expire_time
    end
  end

  def self.down
    change_table :accounts do |t|
      t.remove :actived
      t.remove :active_code
      t.remove :expire_time
    end
  end
end
