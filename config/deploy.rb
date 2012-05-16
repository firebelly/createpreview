# config/deploy.rb
require "bundler/capistrano" # adds bundler support to capistrano

set :application, "createpreview"

require "capify-fb/base" # handles default configuration including multisite setup
require "capify-fb/db" # handles creation of database.yml file during setup.
require "capify-fb/rvm" # handles rvm setup & bundler install (if necessary), rvmrc creation, gemset standardization
require "capify-fb/backup" # handles backup gem config, addition to cron, and running.
require "capify-fb/unicorn" # handles unicorn.rb setup, start, stop, restart
require "capify-fb/nginx" # handles nginx restart
require "capify-fb/sync" # sync assets and db between stages. sync:down pulls from server sync:up pushes to server

# handles s3 credentials outside of repository and appends to config/application.rb file
# set :use_s3, true
# require "capify-fb/s3"

# Which folders to sync.
# Remember to run sync:setup before deploying.
# set :sync_directories, ["public/assets", "public/galleries"]
# how many backups to hold
# set :sync_backups, 3

### 
# Below are all defaults set by capify-fb.
# You can override the settings by uncommenting the lines below 
# or you can use them in stage specific situations by updating the stage file in the config/deploy directory
# or you can override them on the command line using the -s key=value.
#
# Note {} deliminate a block for lazy loading which can be helpful if a variable is not available yet.
###

# User details
# set :user, "deployer"
# set :group, "staff"

# Shared Folders
# Folders shared between releases (DEFAULTS: tmp, log, public/system)
# set :shared_children, %w(tmp log public/system) # only change this if you know what you are doing.
# Add additional folders to be shared.  
# NOTE: If folders are added after deploy:setup is run, deploy:setup must be rerun before using these shared folders.
# set :add_shared_children, %w(public/images)
  
# Application details
# set :use_sudo, false
  
# SCM # settings
# set (:deploy_to) { "/var/www/#{application}" }
# set :scm, "git"
# set(:repository) { "git@github.com:firebelly/#{application}.git" }
# set :branch, "master"
# set :deploy_via, "remoteache"
# set :migrate_target, :current
  
# db # settings
# set(:db_user) { "#{application}" }
# set :db_adapter, "mysql2"
# set :db_host, "localhost"
# set :db_encoding, "utf8"
# set :db_timeout, 5000
# set :db_port, 3306
# set(:db_database) { "#{application}_#{stage}" }
# set :db_template_dir, "capify-fb/templates"
# set :db_skip_# setup, false

# rvm # settings
# set :rvm_type, :system
# set(:rvm_ruby_string) { "ruby-1.9.2@#{application}" }
# set :force_rvmrc, false # force recreation of the rvmrc file and/or install a different ruby/rubygem.

# unicorn # settings
# set :unicorn, true
# set :unicorn_setup, true
# set :unicorn_binary, "/usr/bin/unicorn"

# nginx # settings.
# set :nginx_restart, true
# set(:nginx_script) { "/home/#{user}/bin/restart_nginx" }