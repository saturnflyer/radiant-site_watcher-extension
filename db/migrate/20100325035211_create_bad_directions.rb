class CreateBadDirections < ActiveRecord::Migration
  def self.up
    create_table :bad_directions do |t|
      t.integer :bad_referrer_id
      t.integer :not_found_request_id

      t.timestamps
    end
  end

  def self.down
    drop_table :bad_directions
  end
end
