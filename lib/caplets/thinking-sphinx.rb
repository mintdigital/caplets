# We require web:enable and web:disable for the rebuild task
load 'caplets/web'

## Defaults
_cset(:sphinx_address) {
  roles[:sphinx].servers.detect {|s| s.options[:primary] }.options[:private_ip] ||
  '127.0.0.1'
}
_cset(:sphinx_max_matches) { 1000 }

## Tasks
namespace :deploy do
  desc <<-DESC
  Do a deploy with migrations and a sphinx rebuild.

  Use this when you need to completely rebuild the sphinx index on deploy,
  for instance if you have changed the index definitions. This task puts up
  the maintenance page, runs migrations, rebuilds the sphinx index and restarts
  the app server processes.
  DESC
  task :rebuild do
    web.disable
    update
    migrate
    ts.rebuild
    restart
    web.enable
  end

  namespace :sphinx do
    desc "Generate the sphinx.yml file in the shared directory"
    task :config, :roles => [:app, :sphinx] do
      config = {
        fetch(:environment) => {
          'address' => fetch(:sphinx_address),
          'max_matches' => fetch(:sphinx_max_matches)
        }
      }
      put YAML.dump(config), "#{shared_path}/config/sphinx.yml"
    end
  end

  namespace :ts do
    desc "Generate the Thinking Sphinx config file"
    task :config, :roles => [:app, :sphinx] do
     rake 'ts:configure'
    end

    desc "Generate fresh index files for real-time indices"
    task :config, :roles => [:app, :sphinx] do
     rake 'ts:generate'
    end

    desc "Rebuild Thinking Sphinx config and indexes and restart Sphinx"
    task :rebuild, :roles => :sphinx do
      rake 'ts:rebuild'
    end

    desc "Run a Sphinx index via Thinking Sphinx"
    task :index, :roles => :sphinx do
      rake 'ts:in'
    end

    desc "Start Sphinx searchd via Thinking Sphinx"
    task :start, :roles => :sphinx do
      rake 'ts:start'
    end

    desc "Restart Sphinx searchd via Thinking Sphinx"
    task :start, :roles => :sphinx do
      rake 'ts:restart'
    end

    desc "Stop Sphinx searchd via Thinking Sphinx"
    task :stop, :roles => :sphinx do
      rake 'ts:stop'
    end
  end
end

## Hooks
after 'deploy:setup', 'deploy:sphinx:config'
