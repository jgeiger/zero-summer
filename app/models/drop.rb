class Drop < ActiveRecord::Base

  belongs_to :encounter
  belongs_to :item

  has_many :loots, :order => 'created_at DESC'

  validates_uniqueness_of :item_id, :scope => :encounter_id

  validates_presence_of :encounter_id
  validates_presence_of :item_id

  class << self

    def page(conditions, sort_column, sort_direction, page=1)
      paginate(:order => "#{sort_column} #{sort_direction}",
               :include => [:item],
               :conditions => conditions,
               :page => page
               )
    end

    def construct(encounter_id, item_id)
      if !d = Drop.first(:conditions => {:encounter_id => encounter_id, :item_id => item_id })
        d = Drop.new(:encounter_id => encounter_id, :item_id  => item_id)
        d.save
      end
    end
  end

  def name
    item.name
  end

  def fullname
    "#{self.encounter.fullname} - #{self.item.name}"
  end

end
