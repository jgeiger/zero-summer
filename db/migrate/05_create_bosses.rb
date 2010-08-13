class CreateBosses < ActiveRecord::Migration
  def self.up
    create_table :bosses do |t|
      t.string :name, :limit => 100

      t.timestamps
    end
  end

  def self.down
    drop_table :bosses
  end
end
