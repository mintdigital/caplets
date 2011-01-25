set :bundle_roles, [:app]
set :bundle_exclude, %w[development test]
set :bundle_to, 'vendor/bundled_gems'
set :bin_cmd, 'bundle exec'

warn "**************************************************************"
warn "[DEPRECATED] caplets/bundle is deprecated."
warn "`require bundler/capistrano` and use 'bundle:install' instead."
warn 'See http://gembundler.com/deploying.html for more information.'
warn "**************************************************************"

## Tasks
namespace :deploy do
  namespace :bundle do
    desc "Install gems from Gemfile"
    task :install, :roles => lambda { fetch(:bundle_roles) },
                   :except => {:no_release => true} do

      without = fetch(:bundle_exclude).map{|g| "--without #{g}"}.join(' ')
      run_current "bundle check || bundle install #{fetch(:bundle_to)} #{without}"
    end
  end
end

## Hooks
after 'deploy:update_code', 'deploy:bundle:install'
