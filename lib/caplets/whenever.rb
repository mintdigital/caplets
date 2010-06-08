# Uses the whenever gem to update the server's crontab, using a combination
# of role and environment to pick which crontab to use.
#
# Put per-server crontabs inside whenever/{environment}.{role}.rb
#
namespace :deploy do
  namespace :whenever do
    def update_cmd_for(role)
      load_file = "config/whenever/#{fetch(:environment)}.#{role}.rb"
      [ "cd #{fetch(:current_path)} &&",
        "if [ -f #{load_file} ] ; then",
          "#{fetch(:bin_cmd)} whenever",
          "--update-crontab #{fetch(:application)}.#{fetch(:environment)}.#{role}",
          "--load-file #{load_file}",
          "--set environment=#{fetch(:environment)}",
        "; fi"
      ].join(' ')
    end

    desc "Update the crontab files by running 'whenever'"
    task :update, :except => { :no_release => true } do
      parallel do |session|
        roles.keys.each do |role|
          session.when "in?(#{role.inspect})", update_cmd_for(role)
        end
      end
    end

  end
end

after "deploy:update", "deploy:whenever:update"
