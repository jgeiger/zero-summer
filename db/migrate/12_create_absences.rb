class CreateAbsences < ActiveRecord::Migration
  def self.up
    create_table :absences do |t|
      t.integer :member_id
      t.date :event_date

      t.timestamps
    end

    add_index :absences, :member_id
    add_index :absences, :event_date

  end

  def self.down
    drop_table :absences
  end
end
