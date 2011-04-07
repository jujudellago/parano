# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
ENV['GEM_PATH'] = '/home/jujudell/ruby/gems:/usr/lib/ruby/gems/1.8'

ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.0.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use (only works if using vendor/rails).
  # To use Rails without a database, you must remove the Active Record framework
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_parano_session',
    :secret      => '6c69492344d2727e1a2866542d7d1206160882a561959080af58af488d4f9d3ea695defd0dfd5cdb8cb753283aa53ec4958166b5ff4db3e3dda9c9445352a4d3'
  }
  config.load_paths << "#{RAILS_ROOT}/app/sweepers"
  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
end

unless '1.9'.respond_to?(:force_encoding)
  String.class_eval do
    begin
      remove_method :chars
    rescue NameError
      # OK
    end
  end
end

DEFAULT_ATTACHMENT_OPTIONS = { :storage => :file_system, 
  :processor   => "Rmagick" }
  LAYOUT_CONFIG=YAML.load_file("#{RAILS_ROOT}/config/yc_config.yml")['layout']                               
  LAYOUT_MAIN=LAYOUT_CONFIG['layout_main']                     
  LAYOUT_2COLS=LAYOUT_CONFIG['layout_2cols']   
  SITE_TITLE=LAYOUT_CONFIG['site_title']
  SITE_SUB_TITLE=LAYOUT_CONFIG['site_sub_title']
  CSS_PACKAGE=LAYOUT_CONFIG['css_package']
  HTML_ALLOWED_TAGS="a href, b, br, p, i, em, strong, ul, li, ol, table, tr, td, th,tbody, embed,param, img src, object, hr, h1, h2, h3, h4, h5, img src alt border title"



  SERVER_CONFIG=YAML.load_file("#{RAILS_ROOT}/config/yc_config.yml")['server_'+RAILS_ENV]   
  SERVER_URL=SERVER_CONFIG['server_url']
  ADMINEMAIL=SERVER_CONFIG['admin_email']
  BASEPUBLIC_DIR="/"+SERVER_CONFIG['base_public_dir']
  COMMENTEMAIL=SERVER_CONFIG['comment_email']
  WEBSNAPR_KEY=SERVER_CONFIG['websnapr_key'] 
  GOOGLE_SEARCH_API_KEY = SERVER_CONFIG['google_search_key']

  CMS_ICONS ={
    'edit'=>'/images/icons/kate.png',
    'pencil'=>'/images/icons/pencil.png',
    'password'=>'/images/icons/password.png',
    'code'=>'/images/icons/konsole.png',
    'delete'=>'/images/icons/cancel.png',
    'add_child'=>'/images/icons/window_list.png',
    'updown'=>'/images/icons/updownarrow.png',
    'cfmd'=>'/images/icons/ledgreen.png',
    'clx'=>'/images/icons/ledred.png',
    'image_new'=>'/images/icons/image_new.gif',
    'attach'=>'/images/icons/attach.png',
    'attach_new'=>'/images/icons/new_attach.png',
    'print'=>'/images/icons/print.gif',
    'visible'=>'/images/icons/icon_visible.gif',
    'comment'=>'/images/icons/comment.gif',
    'no-comment'=>'/images/icons/no-comment.gif'
  }          
