## Tasks
namespace :git do
  desc 'Tag and push tag for current release'
  task :tag_current_release, :roles => :app, :only => {:primary => true} do
    if ENV['NO_TAG'].nil?
      tag = "deploy-#{environment}-#{Time.now.to_i}"
      `git tag #{tag} #{fetch(:current_revision)}`
      `git push origin #{tag}`
    end
  end
end

## Hooks
after 'deploy:migrations', 'git:tag_current_release'
after 'deploy:quick', 'git:tag_current_release'
after 'deploy:rebuild', 'git:tag_current_release'
