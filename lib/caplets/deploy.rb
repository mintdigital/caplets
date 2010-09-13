# A lot of this taken from GitHub's deployment:
# http://github.com/blog/470-deployment-script-spring-cleaning

# Overwrite cap defaults
set :use_sudo, false
set :deploy_via, :git # not used
set :shared_children, %w[] # not relevant
set(:rails_env) { environment } ## some built-in tasks use :rails_env
default_run_options[:pty] = true

# Setup basics
_cset :user, 'deploy'
_cset(:group) { user }
_cset :environment, 'production'
_cset :required_children, %w[config log public tmp/pids]

# Server basics
_cset :server_processes, 2
_cset :server_port, 8000

# Use one directory for everything
set(:current_path)    { fetch(:deploy_to)    }
set(:latest_release)  { fetch(:current_path) }
set(:release_path)    { fetch(:current_path) }
set(:current_release) { fetch(:current_path) }
set(:shared_path)     { fetch(:current_path) }

# Behold, the power of git
set(:current_revision) {
  capture("cd #{current_path}; git rev-parse --short HEAD").strip
}
set(:latest_revision)   {
  capture("cd #{current_path}; git rev-parse --short HEAD").strip
}
set(:previous_revision) {
  capture("cd #{current_path}; git rev-parse --short HEAD@{1}").strip
}

###########
## Tasks ##
###########

namespace :deploy do
  [:default, :cleanup, :symlink].each do |t|
    task t do
      abort "Task disabled by caplets."
    end
  end
  [:enable, :disable].each do |t|
    namespace :web do
      task t do
        abort "Task disabled by caplets. Load 'caplets/web' to re-enable."
      end
    end
  end

  desc "Setup a Git-based deploy"
  task :setup, :except => {:no_release => true} do
    run "if [ -d #{fetch(:current_path)}/.git ] ; "+
        "then cd #{fetch(:current_path)} && #{try_sudo} git fetch ; "+
        "else #{try_sudo} git clone #{fetch(:repository)} #{fetch(:current_path)} ; "+
        "fi && "+
        "mkdir -p " + fetch(:required_children,[]).
                        map {|dir| "#{fetch(:current_path)}/#{dir}" }.
                        join(' ')
    )
  end

  desc <<-DESC
  Do a zero-downtime deploy.

  Use this when you have small code changes that you want to go out with
  minimal impact. This does not put up the maintanance page nor run migrations,
  and  will tell your app servers to 'reload' in-place instead of restarting
  completely if they support it.
  DESC
  task :quick do
    update
    reload
  end

  task :update do
    update_code
  end

  desc "Update the deployed code from git"
  task :update_code, :except => { :no_release => true } do
    run_multi "cd #{fetch(:current_path)}",
      "git fetch origin",
      "git reset --hard #{fetch(:branch)}"
    finalize_update
  end

  # Just timestamps, please
  task :finalize_update, :except => { :no_release => true } do
  if fetch(:normalize_asset_timestamps, false)
    stamp = Time.now.utc.strftime("%Y%m%d%H%M.%S")
    asset_paths = %w(images stylesheets javascripts).map {|p|
      "#{latest_release}/public/#{p}"
    }.join(" ")
    run "find #{asset_paths} -exec touch -t #{stamp} {} ';'; true",
      :env => { "TZ" => "UTC" }
  end
end

  %w[start stop restart reload].each do |taskname|
    desc "#{taskname.capitalize} the application server(s)"
    task taskname, :roles => :app, :except => {:no_release => true} do
      deploy.send(fetch(:_server)).send(taskname)
    end
  end

  namespace :rollback do
    task :code do
      abort "Task disabled by caplets"
    end

    desc <<-DESC
    [internal] Rollback repo.

    Moves the repo back one release by checking out HEAD@{1}
    DESC
    task :repo, :except => { :no_release => true } do
      set :branch, "HEAD@{1}"
      deploy.update_code
    end

    desc <<-DESC
      [internal] Rewrite git reflog.
      This makes HEAD@{1} continue to point at the next previous release.
    DESC
    task :cleanup, :except => { :no_release => true } do
      run_multi "cd #{fetch(:current_path)}",
        'git reflog delete --rewrite HEAD@{1}',
        'git reflog delete --rewrite HEAD@{1}'
    end

    desc "Rolls back to the previously deployed version."
    task :default do
      rollback.repo
      rollback.cleanup
      deploy.reload
    end
  end

end
