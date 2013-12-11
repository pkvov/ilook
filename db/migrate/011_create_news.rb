class CreateNews < ActiveRecord::Migration
  def self.up
    create_table :news do |t|
      t.string :title
      t.string :source
      t.string :brief
      t.string :content_type
      t.text :content
      t.datetime :published_at
      t.timestamps
    end
  end

  def self.down
    drop_table :news
  end
end
