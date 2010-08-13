class CreateRaids < ActiveRecord::Migration
  def self.up
    create_table :raids do |t|
      t.string :name, :limit => 50
      t.date :event_date
      t.boolean :active, :default => false
      t.boolean :mandatory, :default => true

      t.timestamps
    end

    add_index :raids, :event_date
    add_index :raids, :active
    add_index :raids, :mandatory
  end

  def self.down
    drop_table :raids
  end
end
