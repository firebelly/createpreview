#config/deploy/staging.rb
server "#{fb_staging_server}", :app, :web, :db, :primary => true
set :rails_env, "staging"
default_environment["RAILS_ENV"] = "#{rails_env}"