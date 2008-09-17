class CreatePageRequests < ActiveRecord::Migration
  def self.up
    create_table :page_requests, :force => true do |t|
      t.string :url, :limit => 255, :unique => true
      t.boolean :virtual, :default => false
      t.integer :count_created, :default => 0
      t.timestamps
    end
    execute "UPDATE page_requests SET count_created = 0;"
  end
  def self.down
    drop_table :page_requests
  end
end