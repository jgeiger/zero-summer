class CreateRaidMemberships < ActiveRecord::Migration
  def self.up
    create_table :raid_memberships do |t|
      t.integer :member_id
      t.integer :raid_id
      t.boolean :active, :default => true

      t.timestamps
    end

    add_index :raid_memberships, :raid_id
    add_index :raid_memberships, :member_id
    add_index :raid_memberships, :active

  end

  def self.down
    drop_table :raid_memberships
  end
end
