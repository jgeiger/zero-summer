ActionController::Routing::Routes.draw do |map|

  Jammit::Routes.draw(map)

  map.resources :dungeons, :bosses, :absences, :drops, :items

  map.resources :encounters,
    :member => {:load_items => :get}

  map.resources :loots,
    :collection => {
      :updated_dungeon => :post,
      :updated_difficulty => :post,
      :updated_boss => :post,
     }

  map.resources :raids,
    :member => { :activate => :get},
    :collection => { :import => :post }

  map.resources :members,
    :collection => { :raid_attending => :get },
    :member => { :merge => :put }

  map.resources :raid_memberships,
                :member => { :toggle_status => :post,
                             :delete => :post
                           }

  map.devise_for :users
  map.resources :users

  map.root :controller => "pages", :action => "home"

end
