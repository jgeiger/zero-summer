class CreateDungeons < ActiveRecord::Migration
  def self.up
    create_table :dungeons do |t|
      t.string :name, :limit => 100
      t.string :token, :limit => 50

      t.timestamps
    end

    add_index :dungeons, :token
  end

  def self.down
    drop_table :dungeons
  end
end
