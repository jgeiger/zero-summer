# This will guess the Member class
Factory.define :member do |m|
  m.sequence(:name) {|n| "bob#{n}" }
  m.klass  "Rogue"
  m.role "DPS"
  m.rank "Reserve"
end
