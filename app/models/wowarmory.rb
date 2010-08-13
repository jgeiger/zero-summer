class Wowarmory
  include HTTParty
  base_uri 'www.wowarmory.com'
  headers 'User-Agent' => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'
  format :xml

  DUNGEONS = {'ulduar' => {
                'name' => 'Ulduar',
                'bosses' => {
                  '0' => "Trash",
                  '32871' => "Algalon the Observer",
                  '33288' => "Yogg-Saron",
                  '33271' => "General Vezax",
                  '194957' => "Mimiron - Cache of Innovation",
                  '194331' => "Freya - Freya's Gift",
                  '194312' => "Thorim - Cache of Storms",
                  '194308' => "Hodir - Cache of Winter",
                  '33515' => "Auriaya",
                  '195046' => "Kologarn - Cache of Living Stone",
                  '32867' => "Steelbreaker",
                  '33293' => "XT-002 Deconstructor",
                  '33118' => "Ignis the Furnace Master",
                  '33186' => "Razorscale",
                  '33113' => "Flame Leviathan"
                }
              },
              'trialofthecrusader10' => {
                'name' => 'Trial of the Crusader (10)',
                'bosses' => {
                  '0' => "Trash",
                  '34797' => "Icehow(10)",
                  '34780' => "Lord Jaraxxus(10)",
                  '195631' => "Champion's Cache(10)",
                  '34497' => "Fjola Lightbane(10)",
                  '34496' => "Eydis Darkbane(10)",
                  '34564' => "Anub'arak(10)",
                  '195669' => "Argent Crusade Tribute Chest(10)"
                }
               },
              'trialofthecrusader25' => {
                'name' => 'Trial of the Crusader (25)',
                'bosses' => {
                  '0' => "Trash",
                  '35447' => "Icehowl(25)",
                  '35216' => "Lord Jaraxxus(25)",
                  '195633' => "Champion's Cache(25)",
                  '35350' => "Fjola Lightbane(25)",
                  '35347' => "Eydis Darkbane(25)",
                  '34566' => "Anub'arak(25)",
                  '195665' => "Argent Crusade Tribute Chest(25)"
                }
               },
               'onyxiaslair' => {
                 'name' => 'Onyxia',
                 'bosses' => {
                   '10184' => "Onyxia"
                 }
                },
                'vaultarchavon' => {
                  'name' => 'Vault of Archavon',
                  'bosses' => {
                    '31125' => "Archavon the Stone Watcher",
                    '33993' => "Emalon the Storm Watcher",
                    '35013' => "Koralon the Flame Watcher",
                    '38433' => "Toravon the Ice Watcher"
                  }
                },
              'icecrowncitadel10' => {
                'name' => 'Icecrown Citadel (10)',
                'bosses' => {
                  '0' => "Trash(10)",
                  '36612' => "Lord Marrowgar(10)",
                  '36855' => "Lady Deathwhisper(10)",
                  '202178' => "Gunship Armory(10)",
                  '37813' => "Deathbringer Saurfang(10)",
                  '36626' => "Festergut(10)",
                  '36627' => "Rotface(10)",
                  '36678' => "Professor Putricide(10)",
                  '37970' => "Prince Valanar(10)",
                  '37955' => "Blood-Queen Lana'thel(10)",
                  '201959' => "Cache of the Dreamwalker(10)",
                  '36853' => "Sindragosa(10)",
                  '36597' => "The Lich King(10)"
                }

              },
              'icecrowncitadel25' => {
                'name' => 'Icecrown Citadel (25)',
                'bosses' => {
                  '0' => "Trash(25)",
                  '37957' => "Lord Marrowgar(25)",
                  '38106' => "Lady Deathwhisper(25)",
                  '202180' => "Gunship Armory(25)",
                  '38582' => "Deathbringer Saurfang(25)",
                  '37504' => "Festergut(25)",
                  '38390' => "Rotface(25)",
                  '38431' => "Professor Putricide(25)",
                  '38401' => "Prince Valanar(25)",
                  '38434' => "Blood-Queen Lana'thel(25)",
                  '202339' => "Cache of the Dreamwalker(25)",
                  '38265' => "Sindragosa(25)",
                  '39166' => "The Lich King(25)"
                }
              }
             }

  class << self
    def item(item_id)
      parameters = {
        "i" => item_id
      }
      result = Wowarmory.post("/item-info.xml", :body => parameters)
      result['page']['itemInfo']['item']
    end

    def items(dungeon, boss_id="all", difficulty="all")
      parameters = {
        "advOptName" => "none",
        "fl[advOpt]" => "none",
        "fl[andor]" => "and",
        "fl[boss]" => boss_id,
        "fl[difficulty]" => difficulty,
        "fl[dungeon]" => dungeon,
        "fl[rqrMax]" => "",
        "fl[rqrMin]" => "",
        "fl[rrt]" => "all",
        "fl[source]" => "dungeon",
        "fl[usbleBy]" => "all",
        "fl[type]" => "all",
        "searchType" => "items"
      }

      begin
        result = Wowarmory.post("/search.xml", :body => parameters)
      rescue REXML::ParseException
        puts "Failed xml on #{boss_id}"
        sleep(1)
        retry
      end until result['page']['armorySearch'] #incase of 503 errors, retry it
      items = result['page']['armorySearch']['searchResults']['items']
      items ? items['item'] : []
    end

    def load_items
      DUNGEONS.keys.each do |dungeon|
        Dungeon.construct(dungeon, DUNGEONS[dungeon])
      end
    end
  end

end

