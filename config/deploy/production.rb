#config/deploy/production.rb
server "ip/domain", :app, :web, :db, :primary => true #
set :rails_env, "production"
default_environment["RAILS_ENV"] = "#{rails_env}"
set :rvm_type, :user # we assume that rvm is set at the user level