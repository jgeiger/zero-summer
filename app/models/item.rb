class Item < ActiveRecord::Base

  QUALITY = {6 => "artifact", 5 => "legendary", 4 => "epic", 3 => "rare", 1 => "common"}

  validates_presence_of :name

  has_many :drops

  class << self

    def page(conditions, sort_column, sort_direction, page=1)
      paginate(:order => "#{sort_column} #{sort_direction}",
               :joins => [:drops],
               :conditions => conditions,
               :group => 'items.id',
               :page => page
               )
    end

    def construct(item)
      id = item['id']
      quality = item['rarity'] || item['quality']
      name = item['name']
      difficulty = item['filter'].second['difficulty']
      name = name.gsub("\\","")<<" (h)" if difficulty == "h"
      if !i = Item.first(:conditions => {:id => id})
        i = Item.new(:name => name, :quality => quality)
        i.id = id
        i.save!
      else
        i.name = name
        i.save!
      end
      i
    end

  end #of self

  def bosses
    b = drops.map {|d| d.encounter.boss.name}
    b.uniq
  end

  def loots
    l = []
    drops.each do |drop|
      drop.loots.each do |loot|
        l << loot
      end
    end
    l.uniq
  end

end
