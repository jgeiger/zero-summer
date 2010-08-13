class Loot < ActiveRecord::Base

  STATUSES = ["Assigned", "Offspec", "Random", "Shard", "BoE", "DKP"]

  attr_accessor :dungeon_id
  attr_accessor :difficulty
  attr_accessor :boss_id

  validates_presence_of :member_id
  validates_presence_of :raid_id
  validates_presence_of :drop_id

  has_many :adjustments, :dependent => :destroy

  belongs_to :member
  belongs_to :raid
  belongs_to :drop

  class << self

    def page(conditions, sort_column, sort_direction, page=1)
      paginate(:order => "#{sort_column} #{sort_direction}, loots.created_at DESC",
               :include => [{:drop => :item}, :member, :raid],
               :conditions => conditions,
               :page => page
               )
    end

    def get_data(dungeon_id, difficulty, boss_id)
      dungeon = Dungeon.find(dungeon_id)
      difficulties = dungeon.encounters.map(&:difficulty).uniq

      difficulties = difficulties.inject([]) do |a, t|
        a << [t, t]
      end

      bosses = dungeon.encounters.inject([]) do |a, encounter|
        a << encounter.boss if encounter.difficulty == difficulty
        a
      end.sort { |x,y| x.name <=> y.name }

      boss = Boss.find(boss_id)
      drops = boss.encounters.inject([]) do |a, encounter|
        a << encounter.drops.sort { |x,y| x.item.name <=> y.item.name } if encounter.difficulty == difficulty
        a
      end.flatten
      [difficulties, bosses, drops]
    end
  end #of self

  def persist
    transaction do |txn|
      self.save
      if self.dkp?
        raid.raid_memberships.each do |membership|
          if !membership.member.bank? && membership.active
            Adjustment.from_loot(membership.member, self)
          end
        end
        bank_adjustment = (27-raid.raid_memberships.size)
        Adjustment.from_loot(Member.first(:conditions => {:id => 0}), self, bank_adjustment)
        Adjustment.for_loot(member, self)
      end
    end
  end

  def dkp?
    self.status == "DKP"
  end

end
