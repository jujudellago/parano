load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'config/deploy'

# ========================
#     For FCGI Apps
# ========================
# NB: running the following :start task will delete your main public_html directory.
# So don't use these commands if you have existing sites in here.

namespace :deploy do

  task :start, :roles => :app do
    run "rm -rf /home/#{user}/public_html/parano ;ln -s #{current_path}/public /home/#{user}/public_html/parano"
  end

  task :restart, :roles => :app do
   # run "cd #{current_path} && killall -9 dispatch.fcgi"
    run "cd #{current_path} && chmod 755 #{chmod755}"
  end

end