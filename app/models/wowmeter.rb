class Wowmeter
  include HTTParty
  format :html
  
  attr_accessor :url
  
  def initialize(url)
    @url = url
  end
  
  def html
    @html ||= Wowmeter.get(url)
  end

=begin
0. Jati #name
1. pri #class
2. 8 #dps time
3. 1.99 # damage taken
=end

  def members
    member_regex = /\"actorname\": \"(\w+?)\".+?\"classtype\":\s\"(\w+?)\".+?\"dpstimepercent\":\s"(\d+?)\".+?\"damagetakenpercent\"\s:\s(.+?)\s,/
    members = html.scan(member_regex)
    cleaned = []
    members.inject([]) do |a, member|
      a << member if Member::KLASSES.include?(member[1])
      a
    end
  end

  def raid
    raid_regex = /combatdatetime.+?<span class="lite">(.+?)<\/span>/
    a = html.scan(raid_regex)
    ["Ulduar", Date.parse(Time.parse(a.flatten!.first).to_s)]
  end

end

