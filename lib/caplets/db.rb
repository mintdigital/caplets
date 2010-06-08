# In deploy:migrations, we use web.enable and web.disable
# so we need to make sure this has been loaded.
load 'caplets/web'

## Defaults
_cset :db_host, 'localhost'
_cset :db_adapter, 'mysql'
_cset(:db_database) { "#{fetch(:application)}_#{fetch(:environment)}" }
_cset(:db_username) { user }
_cset(:db_password) {
  Capistrano::CLI.password_prompt(
    "Please enter MySQL password for user #{fetch(:db_username)}: "
  )
}
_cset :db_encoding, 'utf8'
_cset(:db_config) {
  fetch(:db_extra).merge({
    fetch(:environment).to_s => {
      'host'     => fetch(:db_host).to_s,
      'adapter'  => fetch(:db_adapter).to_s,
      'database' => fetch(:db_database).to_s,
      'username' => fetch(:db_username).to_s,
      'password' => fetch(:db_password).to_s,
      'encoding' => fetch(:db_encoding).to_s
    }
  })
}
_cset :db_extra, {}

## Tasks
namespace :deploy do
  namespace :db do
    desc "write out database.yml"
    task :config, :roles => :app do
      put YAML.dump(fetch(:db_config)), "#{shared_path}/config/database.yml"
    end
  end

  # migrate runs on the app server (no need for the code on the DB server)
  task :migrate, :roles => :app, :only => { :primary => true } do
    rake 'db:migrate'
  end

  desc <<-DESC
  Do a deploy with migrations.

  Use this when you need to completely disable the site and run migrations.
  This will put up a maintenance page, run the migrations and completely
  restart the app server processes.
  DESC
  task :migrations do
    web.disable
    update
    migrate
    restart
    web.enable
  end
end

## Hooks
after 'deploy:setup', 'deploy:db:config'
