class CreateEncounters < ActiveRecord::Migration
  def self.up
    create_table :encounters do |t|
      t.integer :dungeon_id
      t.integer :boss_id
      t.string :difficulty, :limit => 20

      t.timestamps
    end

    add_index :encounters, :dungeon_id
    add_index :encounters, :boss_id
    add_index :encounters, :difficulty

  end

  def self.down
    drop_table :encounters
  end
end
