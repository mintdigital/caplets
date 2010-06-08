set :_server, :mongrel

namespace :deploy do
  namespace :mongrel do
    desc "Write the cluster config."
    task :config, :roles => :app, :except => {:no_release => true} do
      config = {
        'user' => user,
        'group' => group,
        'cwd' => current_path,
        'environment' => environment,
        'port' => server_port,
        'address' => '0.0.0.0',
        'pid_file' => "#{shared_path}/tmp/pids/mongrel.pid",
        'servers' => server_processes
      }
      put YAML.dump(config), "#{shared_path}/config/cluster.yml"
    end

    desc "Start the mongrel_cluster"
    task :start, :roles => :app do
      run "cd #{current_path} && " +
        "mongrel_rails cluster::start -C #{shared_path}/config/cluster.yml --clean"
    end

    desc "Stop the mongrel_cluster"
    task :stop, :roles => :app do
      run "cd #{current_path} && " +
        "mongrel_rails cluster::stop -C #{shared_path}/config/cluster.yml --clean"
    end

    desc "Restart the mongrel_cluster"
    task :restart, :roles => :app do
      run "cd #{current_path} && " +
        "mongrel_rails cluster::restart -C #{shared_path}/config/cluster.yml --clean"
    end

    desc "Restart the mongrel_cluster, as mongrel does not support reloading"
    task :reload, :roles => :app do
      restart
    end
  end
end

## Hooks
after 'deploy:setup', 'deploy:mongrel:config'
