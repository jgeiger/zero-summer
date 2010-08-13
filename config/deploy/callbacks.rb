namespace :deploy do

  desc "expand the gems"
  task :gems, :roles => :web, :except => { :no_release => true } do
    run "cd #{current_path}; bundle install --deployment --local --without test development cucumber"
  end

  desc 'Bundle and minify the JS and CSS files'
  task :precache_assets, :roles => :app do
    root_path = File.expand_path(File.dirname(__FILE__) + '/../..')
    assets_path = "#{root_path}/public/assets"
    run_locally "#{root_path}/vendor/bin/jammit"
    top.upload assets_path, "#{current_path}/public", :via => :scp, :recursive => true
  end

end
