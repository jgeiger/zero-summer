class CreateAdjustments < ActiveRecord::Migration
  def self.up
    create_table :adjustments do |t|
      t.integer :amount
      t.integer :member_id
      t.integer :loot_id

      t.timestamps
    end

    add_index :adjustments, :loot_id
    add_index :adjustments, :member_id

  end

  def self.down
    drop_table :adjustments
  end
end
