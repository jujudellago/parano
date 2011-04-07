set :application, "parano"


#set :svn, '/home/jujudell/bin/svn'
set :scm_command, '/home/jujudell/bin/svn'
set :local_scm_command, :default
set :scm, :subversion

set :deploy_via, :checkout
set :repository,  "http://OpenSVN.csie.org/paranoshop"
set :svn_username, "jujudell"
set :svn_password, "kristina"

set :domain, "jujudellago.com"
#set :deploy_to, "/home/jujudell/apps/#{application}"
#set :applicationdir, "/home/jujudell/apps/#{application}"
set :deploy_to, "/home/jujudell/etc/rails_apps/#{application}"
set :applicationdir, "/home/jujudell/etc/rails_apps/#{application}"

set :chmod755, "app config db lib public vendor script script/* public/disp*"  	# Some files that will need proper permissions

ssh_options[:keys] = %w(~/.ssh/id_dsa ~/.ssh/id_rsa)
# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:


# If you aren't using Subversion to manage your source code, specify
# your SCM below:




set :user, 'jujudell'
set :runner, 'jujudell'
set :use_sudo, false

# puts "The application name is #{application}"
# puts "The user is #{user}"
# run <<-EOF
#   echo $PATH
# EOF


role :app, domain
role :web, domain
role :db,  domain, :primary => true


task :update_config, :roles=>[:app] do
  run "cp -Rf #{shared_path}/config/* #{release_path}/config/"
end

after 'deploy:update_code', :update_config
task :after_update_code, :roles => [:app] do
  run <<-EOF
    ln -s #{shared_path}/public/photos #{latest_release}/public/photos && rm -Rf #{latest_release}/public/uploaded_images && ln -s #{shared_path}/public/uploaded_images #{latest_release}/public/uploaded_images && ln -s #{shared_path}/vendor/rails #{latest_release}/vendor/rails && cd #{latest_release} &&  rake asset:packager:build_all
  EOF
end

#    ln -s #{shared_path}/public/photos #{latest_release}/public/photos && rm -Rf #{latest_release}/public/uploaded_images && ln -s #{shared_path}/public/uploaded_images #{latest_release}/public/uploaded_images && ln -s #{shared_path}/vendor/rails #{latest_release}/vendor/rails && cd #{latest_release} &&  rake asset:packager:build_all


##########
# Bluehost specific
# (since you can't restart the web server on shared servers
# redefine deploy:start, deploy:stop, and deploy:restart to do nothing
##########
namespace :deploy do
  task :restart do
    # run "mongrel_rails cluster::restart -C #{mongrel_config}"
  end

  task :start do
    # run "mongrel_rails cluster::start -C #{mongrel_config}"
  end

  task :stop do
    # run "mongrel_rails cluster::stop -C #{mongrel_config}"
  end
end