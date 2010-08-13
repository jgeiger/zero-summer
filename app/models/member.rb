class Member < ActiveRecord::Base

  KLASSES = {"dkt" => "Death Knight", "drd" => "Druid", "hnt" => "Hunter", "mag" => "Mage", "pal" => "Paladin", "pri" => "Priest", "rog" => "Rogue", "sha" => "Shaman", "wrl" => "Warlock", "war" => "Warrior", "bnk" => "Bank"}
  ROLES = ["DPS", "Tank", "Healer", "Bank"]
  RANKS = ["Officer", "Vanguard", "Elite", "Reserve", "Applicant", 'Inactive', 'Departed']

  attr_accessor :raid_id

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :raid_memberships, :dependent => :destroy
  has_many :raids, :through => :raid_memberships

  has_many :loots
  has_many :adjustments
  has_many :absences, :dependent => :destroy

  attr_accessor :other_id

  class << self
    def active
      Member.all(:order => :name, :conditions => ["rank != ? AND rank != ?", 'Departed', 'Inactive'])
    end

    def default_raiders
      Member.all(:select => :id, :conditions => ["rank NOT IN ("+["Reserve", "Applicant", "Inactive", "Departed"].to_in_query_string+")"])
    end

    def raid_attending(conditions, sort_column, sort_direction, since=8)
      secondary_sort = sort_column == "tuesday_percent" ? "thursday_percent" : "tuesday_percent"
      recent = since.weeks.ago.to_date
      select = "members.*, ROUND((COUNT(DISTINCT r.id)/(SELECT COUNT(*) AS field_1 FROM raids rtu WHERE rtu.mandatory = 1 AND rtu.event_date > '#{recent}' AND dayname(rtu.event_date) = 'Tuesday'))*100, 2) AS tuesday_percent, ROUND((COUNT(DISTINCT r2.id)/(SELECT COUNT(*) AS field_1 FROM raids rth WHERE rth.mandatory = 1 AND rth.event_date > '#{recent}' AND dayname(rth.event_date) = 'Thursday'))*100, 2) AS thursday_percent"
      select << ", ROUND((COUNT(DISTINCT r3.id)/(SELECT COUNT(*) AS field_1 FROM raids rt WHERE rt.mandatory = 1 AND rt.event_date >= MIN(r3.event_date)))*100, 2) AS total_percent, ROUND((COUNT(DISTINCT r4.id)/(SELECT COUNT(*) AS field_1 FROM raids rr WHERE rr.mandatory = 1 AND rr.event_date > '#{recent}'))*100, 2) AS recent_percent, (SELECT count(*) AS field_1 FROM raids rc WHERE rc.mandatory = 1 AND rc.event_date > '#{recent}') AS raid_count"
      joins = "LEFT JOIN raid_memberships AS rm ON members.id = rm.member_id LEFT JOIN raids AS r ON rm.raid_id = r.id AND r.event_date > '#{recent}' AND r.mandatory = 1 AND dayname(r.event_date) = 'Tuesday' LEFT JOIN raids AS r2 ON rm.raid_id = r2.id AND r2.event_date > '#{recent}' AND r2.mandatory = 1 AND dayname(r2.event_date) = 'Thursday'"
      joins << " LEFT JOIN raids AS r3 ON rm.raid_id = r3.id AND r3.mandatory = 1 LEFT JOIN raids AS r4 ON rm.raid_id = r4.id AND r4.event_date > '#{recent}' AND r4.mandatory = 1"
      order = "#{sort_column} #{sort_direction}, #{secondary_sort} DESC, members.name ASC"
      find(:all,
               :select => select,
               :joins => joins,
               :conditions => conditions,
               :group => 'members.id',
               :order => order
               )
    end

    def page(conditions, sort_column, sort_direction, page=1)
      order = "#{sort_column} #{sort_direction}"
      paginate(
               :conditions => conditions,
               :order => order,
               :page => page
               )
    end

    def build(url)
      Wowmeter.new(url).members.each do |member|
        Member.construct(member[0], member[1], member[2], member[3])
      end
    end

    def construct(name, kl, dps, damage)
      if !m = Member.first(:conditions => ["name = ?", name])
        if dps.to_i > 50
          if damage.to_f > 10
            role = "Tank"
          else
            role = "DPS"
          end
        else
          role = "Healer"
        end
        m = Member.new(:name => name, :klass => KLASSES[kl], :role => role)
        m.save
      end
      m
    end
  end #of self

  def deleteable?
    self.adjustments.empty? && self.loots.empty?
  end

  def merge(other_id)
    other = Member.find(other_id)

    other.adjustments.each do |a|
      a.member_id = self.id
      a.save
    end

    other.loots.each do |l|
      l.member_id = self.id
      l.save
    end

    other.raid_memberships.each do |rm|
      member_ids = rm.raid.raid_memberships.map(&:member_id)
      if member_ids.include?(self.id)
        rm.destroy
      else
        rm.member_id = self.id
        rm.save
      end
    end

    other.destroy
  end

  def bank?
    id == 0
  end

  def css_class
    klass.gsub(" ","-").downcase
  end

  def points
    adjustments.any? ? adjustments.sum(:amount) : 0
  end

end
