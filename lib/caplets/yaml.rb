## Defaults
_cset :config_files, {}

## Tasks
namespace :deploy do
  namespace :yaml do
    desc "Write any defined custom YAML config files."
    task :config, :except => { :no_release => true } do
      fetch(:config_files,{}).each do |name, data|
        put YAML.dump(data), "#{fetch(:shared_path)}/config/#{name}.yml"
      end
    end
  end
end

## Hooks
after 'deploy:setup', 'deploy:yaml:config'
