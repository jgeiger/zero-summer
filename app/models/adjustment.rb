class Adjustment < ActiveRecord::Base

  belongs_to :member
  belongs_to :loot

  class << self
    def for_loot(member, loot, amount=-26)
      adjustment = Adjustment.new(:member => member, :loot => loot, :amount => amount)
      adjustment.save
    end

    def from_loot(member, loot, amount=1)
      adjustment = Adjustment.new(:member => member, :loot => loot, :amount => amount)
      adjustment.save
    end
  end

end
