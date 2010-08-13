class Raid < ActiveRecord::Base

  MANDATORY = [["Yes", 1], ["No", 0]]

  attr :url

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :event_date

  has_many :raid_memberships, :order => :created_at, :dependent => :destroy
  has_many :members, :through => :raid_memberships, :order => :name

  has_many :loots, :order => 'created_at DESC', :dependent => :destroy
  has_many :active_memberships, :class_name => "RaidMembership", :conditions => {:active => true}

  class << self

    def page(conditions, page=1)
      paginate(:order => 'event_date DESC',
               :conditions => conditions,
               :page => page
               )
    end

    def construct(name, event_date)
      if !r = Raid.first(:conditions => ["event_date = ?", event_date])
        r = Raid.new(:name => name, :event_date => event_date)
        r.save
      end
      r
    end

    def build(url)
      wowmeter = Wowmeter.new(url)
      name, event_date = wowmeter.raid
      r = Raid.construct(name, event_date)
      members = wowmeter.members
      members.each do |member|
        m = Member.construct(member[0], member[1], member[2], member[3])
        if !rm = RaidMembership.first(:conditions => ["member_id = ? AND raid_id = ?", m.id, r.id])
          rm = RaidMembership.new(:raid => r, :member => m)
          rm.persist
        end
      end
    end
  end #of self

  def persist
    transaction do |txn|
      self.save
      Member.default_raiders.each do |member|
        self.raid_memberships.create(:member_id => member.id)
      end
    end
    self.activate
  end

  def activate
    transaction do |tx|
      Raid.update_all(:active => false)
      self.update_attribute(:active, true)
    end
  end

end
