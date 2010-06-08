## Defaults
_cset(:memcached_servers) do
  if roles[:memcached].servers.any?
    unless roles[:memcached].servers.all? {|s| s.options[:private_ip] }
      abort "Set :private_ip for all :memcached servers or "+
            "set :memcached_servers explicitly."
    end
    roles[:memcached].servers.map {|s| s.options[:private_ip] + ":11211" }
  else
    %w[localhost:11211]
  end
end

## Tasks
namespace :deploy do
  namespace :memcached do
    desc "Generate the memcached.yml in the shared directory"
    task :config, :roles => :app do
      config = {
        environment => {
          'servers' => fetch(:memcached_servers)
        }
      }
      put YAML.dump(config), "#{shared_path}/config/memcached.yml"
    end
  end
end

## Hooks
after 'deploy:setup', 'deploy:memcached:config'
