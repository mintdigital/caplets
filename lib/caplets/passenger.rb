set :_server, :passenger

namespace :deploy do
  namespace :passenger do
    # These are no-ops for Passenger
    task :start, :roles => :app, :except => {:no_release => true} do; end
    task :stop, :roles => :app, :except => {:no_release => true} do; end

    desc 'Restart the Passenger processes by touching tmp/restart.txt'
    task :restart, :roles => :app, :except => {:no_release => true} do
      run "touch #{current_path}/tmp/restart.txt"
    end

    desc 'Restart the Passenger process by touching tmp/restart.txt'
    task :restart, :roles => :app, :except => {:no_release => true} do
      run "touch #{current_path}/tmp/restart.txt"
    end
  end # namespace :passenger
end # namespace :deploy
