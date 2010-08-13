class Absence < ActiveRecord::Base

  validates_uniqueness_of :member_id, :scope => :event_date, :message => "Member is already absent on that date."
  belongs_to :member

  class << self
    def page(conditions, sort_column, sort_direction, page=1)
      paginate(:order => "#{sort_column} #{sort_direction}, members.name ASC",
               :include => [:member],
               :conditions => conditions,
               :page => page
               )
    end
  end

end
