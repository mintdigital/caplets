set :_server, :unicorn

namespace :deploy do
  namespace :unicorn do

    def start_cmd
      fetch(:bin_cmd,'') +
      " #{fetch(:_unicorn_cmd,'unicorn')} -D" +
      " -c config/unicorn.rb" +
      " -E #{fetch(:environment)}"
    end

    def stop_cmd(signal='QUIT', pid='unicorn.pid')
      pid = "tmp/pids/#{pid}"
      "if [ -f #{pid} ] ; then kill -#{signal} $(cat #{pid}) ; fi"
    end

    def wait_for_pid(pid, to_disappear=false)
     "while [ #{'!' unless to_disappear} -f tmp/pids/#{pid} ] ; do sleep 1; done"
    end

    desc "Write the unicorn config to the shared directory."
    task :config, :roles => :app, :except => {:no_release => true} do
      config = File.read(__FILE__).split(/^__END__$/, 2)[1]
      put ERB.new(config,nil,'-').result(binding.dup),
        fetch(:current_path) + '/config/unicorn.rb'
    end

    desc "Start the unicorn master and workers."
    task :start, :roles => :app, :except => {:no_release => true} do
      run_current start_cmd
    end

    desc "Stop the unicorn master and workers."
    task :stop, :roles => :app, :except => {:no_release => true} do
      run_current stop_cmd
    end

    desc "Restart the unicorn master and workers."
    task :restart, :roles => :app, :except => {:no_release => true} do
      run_current stop_cmd,
                  wait_for_pid('unicorn.pid', :to_disappear),
                  start_cmd,
                  wait_for_pid('unicorn.pid'),
                  'sleep 5' # app start-up
    end

    desc "Reload the unicorn master and workers with zero downtime."
    task :reload, :roles => :app, :except => {:no_release => true} do
      run_current stop_cmd('USR2'),
                  wait_for_pid('unicorn.pid.oldbin'),
                  wait_for_pid('unicorn.pid'),
                  'sleep 5', # app start-up
                  stop_cmd('QUIT', 'unicorn.pid.oldbin')
    end
  end
end

## Hooks
after 'deploy:setup', 'deploy:unicorn:config'

__END__
pid '<%= fetch(:current_path) %>/tmp/pids/unicorn.pid'

working_directory "<%= fetch(:current_path) %>"

worker_processes <%= fetch(:server_processes, 4) %>

# Pre-load for fast worker forks and COW-friendliness
preload_app <%= fetch(:preload_app, true) %>

timeout <%= fetch(:server_timeout, 60) %>

listen '0.0.0.0:<%= fetch(:server_port, 8000) %>'

stderr_path "<%= current_path %>/log/unicorn.log"
stdout_path "<%= current_path %>/log/unicorn.log"

# http://www.rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

<%= fetch(:_unicorn_ar_config,'') %>
<%= fetch(:unicorn_extra_config,'') %>
