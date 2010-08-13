class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.string :name, :limit => 50
      t.string :klass, :limit => 20
      t.string :role, :limit => 20
      t.string :rank, :limit => 20

      t.timestamps
    end

    add_index :members, :klass
    add_index :members, :role
    add_index :members, :rank
    
  end

  def self.down
    drop_table :members
  end
end
