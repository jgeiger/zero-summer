namespace :update do
  desc "Update the item data"
  task(:items, :needs => :environment) do
    Wowarmory.load_items
  end
end
