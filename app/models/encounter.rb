class Encounter < ActiveRecord::Base

  DIFFICULTIES = ['normal', 'heroic']

  has_many :drops
  has_many :loots, :through => :drops

  belongs_to :boss
  belongs_to :dungeon

  validates_uniqueness_of :boss_id, :scope => [:dungeon_id, :difficulty]

  validates_presence_of :boss_id
  validates_presence_of :dungeon_id
  validates_presence_of :difficulty


  class << self
    def construct(dungeon_id, boss_id, difficulty)
      if !e = Encounter.first(:conditions => ["boss_id = ? AND dungeon_id = ? AND difficulty = ?", boss_id, dungeon_id, difficulty])
        e = Encounter.new(:boss_id => boss_id, :dungeon_id => dungeon_id, :difficulty => difficulty)
        e.save
      end
      e
    end
  end

  def dungeonname
    "#{self.dungeon.name}:#{self.difficulty}"
  end

  def name
    "#{self.dungeon.name}:#{self.difficulty} - #{self.boss.name}"
  end

end
