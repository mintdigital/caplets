module Caplets::SSH
  def ssh_to_server(opts={})
    servers = []
    selected_role = opts[:role] ? opts[:role].to_sym : nil
    task_roles = selected_role ? {selected_role => roles[selected_role]} :
                                 roles.sort_by(&:to_s)

    # Convert from an array of roles (i.e., servers grouped by role) to an
    # array of server data hashes (i.e., roles grouped by server)
    task_roles.each do |role_name, role|
      role.servers.each do |role_server|
        role_server_data = servers.detect { |s| s[:host] == role_server.host }
        if role_server_data
          role_server_data[:role_names] << role_name
        else
          servers << {:host => role_server.host, :role_names => [role_name]}
        end
      end
    end

    # Prompt for a server if needed
    if servers.size > 1
      env_desc = "#{fetch(:environment)} #{selected_role}".strip
      puts "\nWhich #{env_desc} server?"
      servers.each_with_index do |server, i|
        server_desc = server[:host].dup
        unless selected_role
          server_desc << " (#{server[:role_names].join(', ')})"
        end
        puts "  #{(i+1).to_s.rjust(2)}. #{server_desc}"
      end
      input = Capistrano::CLI.ui.
        ask('>  ', Integer) { |q| q.in = 1..servers.size }
      host = servers[input - 1][:host]
    else
      host = servers.first[:host]
    end

    cmd = %|ssh -t #{fetch(:user)}@#{host} "cd #{fetch(:current_path)}; bash"|
    puts "Connecting to #{host}..."
    exec(cmd)
  end
end
Capistrano::Configuration.send :include, Caplets::SSH

namespace :ssh do
  desc 'SSH into any configured server'
  task(:default) { ssh_to_server } # Usage: `cap production ssh`, etc.

  [:app, :web].each do |role|
    desc "SSH into any configured #{role} server"
    task(role.to_sym) { ssh_to_server(:role => role) }
  end
end
