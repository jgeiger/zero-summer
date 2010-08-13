class Boss < ActiveRecord::Base

  has_many :encounters

  validates_presence_of :name

  class << self
    def construct(id, name)
      if !b = Boss.first(:conditions => {:id => id})
        b = Boss.new(:name => name.gsub("\\",""))
        b.id = id
        b.save
      end
      b
    end
  end

end
