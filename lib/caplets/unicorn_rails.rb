set :_server, :unicorn
set :_unicorn_cmd, 'unicorn_rails'
set :_unicorn_ar_config, <<-CONF
before_fork do |server, worker|
  # master process doesn't need a connection
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  # workers need to connect individually
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
CONF

load 'caplets/unicorn'
