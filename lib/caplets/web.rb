namespace :deploy do
  namespace :web do
    desc 'Enable maintenance mode'
    task :disable, :roles => :web do
      try_sudo "touch #{fetch(:current_release)}/public/SHOW_MAINTENANCE_PAGE"
    end

    desc 'Disable maintenance mode'
    task :enable, :roles => :web do
      try_sudo "rm -f #{fetch(:current_release)}/public/SHOW_MAINTENANCE_PAGE"
    end
  end
end
