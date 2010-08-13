class RaidMembership < ActiveRecord::Base

  belongs_to :raid
  belongs_to :member

  validates_uniqueness_of :member_id, :scope => [:raid_id]

  def persist
    self.active = false if raid_full?
    self.save
  end

  def toggle_status
    if !active? && !raid_full?
      self.update_attributes(:active => true)
      true
    else
      self.update_attributes(:active => false)
      false
    end
  end

  def raid_full?
    raid.raid_memberships.select { |m| m.active? }.size == 26
  end

  def raid_has_loot?
    !raid.loots.empty?
  end

  def active_css
    self.active? ? '' : 'inactive'
  end

end
