# This is just a collection of handy methods to use while writing tasks
module Caplets::Utils
  def rake(cmd)
    run_current [
      "RAILS_ENV=#{fetch(:environment)}",
      fetch(:bin_cmd,''),
      fetch(:rake, 'rake'),
      cmd
    ].join(' ')
  end

  def run_current(*cmds)
    run ["cd #{fetch(:current_path)}"].concat(cmds).join(' && ')
  end

  def run_multi(*cmds)
    run cmds.join(' ; ')
  end
end

Capistrano::Configuration.send :include, Caplets::Utils
