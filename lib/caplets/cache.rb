## Defaults
_cset :cache_dir, 'cache'

## Tasks
namespace :deploy do
  namespace :cache do
    task :clear, :roles => :app, :only => { :primary => true } do
      run "find #{fetch(:current_path)}/public/#{fetch(:cache_dir)} -type f -delete"
    end
  end
end
