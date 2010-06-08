task :logs, :roles => :app do
  stream "tail -n 0 -f #{shared_path}/log/*.log"
end
