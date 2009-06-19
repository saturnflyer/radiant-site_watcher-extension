class CreateNotFoundRequests < ActiveRecord::Migration
  def self.up
    create_table :not_found_requests do |t|
      t.string :url, :limit => 500, :unique => true
      t.integer :count_created, :default => 0
      t.timestamps
    end
    add_index :not_found_requests, :url, :unique => true
    add_index :page_requests, :url, :unique => true
  end

  def self.down
    remove_index :page_requests, :column => :url
    remove_index :not_found_requests, :column => :url
    drop_table :not_found_requests
  end
end
