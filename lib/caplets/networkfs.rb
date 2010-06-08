# loading this file will modify your deploy for use with a networked filesystem
# Mostly, this means you can define paths that will get symlinked to the FS

## Defaults
_cset :networkfs_path, '/srv/share'
_cset :networkfs_resources, []

## Tasks
namespace :deploy do
  namespace :networkfs do
    desc "Create the application's directory on the network FS"
    task :setup, :roles => :app, :only => {:primary => true} do
      try_sudo "mkdir -p #{fetch(:networkfs_path)}/#{fetch(:application)}"
    end

    desc "Symlink networkfs_resources to the network FS"
    task :symlink, :roles => [:app, :web] do
      cmds = fetch(:networkfs_resources, []).map do |resource|
        "ln -nfs" +
          " #{fetch(:networkfs_path)}/#{fetch(:application)}/#{resource}" +
          " #{fetch(:release_path)}/#{resource}"
      end
      try_sudo cmds.join(" && ")
    end
  end
end

## Hooks
after 'deploy:setup', 'deploy:networkfs:setup'
after 'deploy:setup', 'deploy:networkfs:symlink'
