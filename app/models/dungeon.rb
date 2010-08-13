class Dungeon < ActiveRecord::Base

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :encounters

  class << self

    def page(conditions, page=1)
      paginate(:order => :name,
               :conditions => conditions,
               :page => page
               )
    end

    def construct(id, hash)
      if !d = Dungeon.first(:conditions => {:id => id})
        d = Dungeon.new(:name => hash['name'])
        d.id = id
        d.save
        logger.debug("CONSTRUCT DUNGEON: #{d.name}")
      end
      hash['bosses'].each do |boss_id, boss_name|
        if boss_id != "0"
          Encounter::DIFFICULTIES.each do |difficulty|
            d.build(boss_id, difficulty, boss_name)
            logger.debug("CONSTRUCT ENCOUNTER: #{difficulty}--#{boss_name}")
          end
        end
      end
    end
  end

  def build(boss_id, difficulty, boss_name)
    Wowarmory.items(self.id, boss_id, difficulty).each do |item|
      i = Item.construct(item)
      boss = Boss.construct(boss_id, boss_name)
      encounter = Encounter.construct(self.id, boss_id, difficulty)
      Drop.construct(encounter.id, item['id'])
      logger.debug("CONSTRUCT DROP: #{i.name}--#{boss_name}--#{difficulty}")
    end
  end

end
