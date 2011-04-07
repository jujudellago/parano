

#set :svn, '/home/jujudell/bin/svn'
#set :scm_command, '/home/jujudell/bin/svn'
#set :local_scm_command, :default
#set :scm, :subversion

#set :deploy_via, :checkout
#set :repository,  "http://OpenSVN.csie.org/paranoshop"
#set :svn_username, "jujudell"
#set :svn_password, "kristina"

set :scm, :git
set :branch, "master"


set :deploy_to, "/home/jujudell/apps/parano"
set :application, "parano.yabo-sites.com"


role :web, "jujudell@174.122.37.162"
role :app, "jujudell@174.122.37.162"
role :db,  "jujudell@174.122.37.162", :primary => true


default_run_options[:pty] = true 

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :use_sudo, false
set :keep_releases, 4


#set :scm_command, "/usr/bin/git"
#set :local_scm_command, "/usr/local/bin/git"


set :branch, "master"
set :repository, "git@github.com:jujudellago/parano.git"
set :deploy_via, :remote_cache



set :domain, "yabo-sites.com"

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
namespace :deploy do
 task :start do ; end
 task :stop do ; end
 task :restart, :roles => :app, :except => { :no_release => true } do
   run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
 end
end



namespace :rake do
  task :show_tasks do
    run("cd #{deploy_to}/current; /usr/bin/rake -T")
  end
end


desc "migrate database"
task :migrate_db, :roles => [:app] do
  run("cd #{deploy_to}/current;  rake db:migrate RAILS_ENV=production")
end