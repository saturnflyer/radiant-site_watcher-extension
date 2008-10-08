class AddIgnore < ActiveRecord::Migration
  def self.up
    add_column :page_requests, :ignore, :boolean, :default => false
  end
  def self.down
    remove_column :page_requests, :ignore
  end
end