set :_server, :passenger

namespace :deploy do
  namespace :passenger do
    # These are no-ops for Passenger
    task :start, :roles => :app, :except => {:no_release => true} do; end
    task :stop, :roles => :app, :except => {:no_release => true} do; end

    [:restart, :reload].each do |action|
      desc 'Restart the Passenger processes by touching tmp/restart.txt'
      task action, :roles => :app, :except => {:no_release => true} do
        run "touch #{current_path}/tmp/restart.txt"
      end
    end
  end # namespace :passenger
end # namespace :deploy
