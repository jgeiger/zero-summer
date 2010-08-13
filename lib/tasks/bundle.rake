namespace :bundle do
  task :all do
    RAILS_ROOT ||= ENV["RAILS_ROOT"]
    root_path    = RAILS_ROOT
    jammit_path  = Dir["#{root_path}/vendor/bundler_gems/ruby/1.8/gems/jammit-*/bin/jammit"].first
    yui_lib_path = Dir["#{root_path}/vendor/bundler_gems/ruby/1.8/gems/yui-compressor-*/lib"].first

    # Precaching assets
    `ruby -I#{yui_lib_path} #{jammit_path}`
  end
end