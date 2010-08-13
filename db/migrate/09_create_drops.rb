class CreateDrops < ActiveRecord::Migration
  def self.up
    create_table :drops do |t|
      t.integer :encounter_id
      t.integer :item_id

      t.timestamps
    end

    add_index :drops, :item_id
    add_index :drops, :encounter_id
  end

  def self.down
    drop_table :drops
  end
end
