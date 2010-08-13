class Wowhead
  include HTTParty
  format :html
  
  attr_accessor :wowhead_type, :id
  
  def initialize(wowhead_type, id)
    @wowhead_type = wowhead_type
    @id = id
  end
  
  def html
    @html ||= Wowhead.get("http://www.wowhead.com/?#{wowhead_type}=#{id}")
  end

=begin
   0. 46016 #id
   1. 3 #quality
   2. Abaddon #name
   3. t:1,ti:33288,n:'Yogg-Saron', #sourcemore match
   4. 1 #source type
   5. 33288 #source id
   6. Yogg-Saron #source name
   7. 4273 #source dungeon
   8. ,dd:1 #difficulty match
   9. 1 #difficulty

   0. 46340
   1. 3
   2. Adamant Handguards
   3.
   4.
   5.
   6.
   7. 4273
   8. ,dd:1
   9. 1
=end

  def drops
    drop_regex = /\{id:(\d+),name:'(\d)(.+?)',.+?sourcemore:\[\{(t:(\d+),ti:(\d+),n:'(.+?)',)?z:(\d+)(,dd:?(\d?))?/
    a = html.scan(drop_regex)
  end

  #<title>Naxxramas - Dungeon - World of Warcraft</title>
  def title
    title_regex = /<title>(.+?) -.+<\/title>/
    html.scan(title_regex).flatten.first
  end

end

