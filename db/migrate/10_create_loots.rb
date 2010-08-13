class CreateLoots < ActiveRecord::Migration
  def self.up
    create_table :loots do |t|
      t.string :status, :limit => 20
      t.integer :member_id
      t.integer :raid_id
      t.integer :drop_id

      t.timestamps
    end

    add_index :loots, :status
    add_index :loots, :member_id
    add_index :loots, :raid_id
    add_index :loots, :drop_id

  end

  def self.down
    drop_table :loots
  end
end
