ActionController::Routing::Routes.draw do |map|
  map.resources :brands,  :member => {:image=>:get} do |brand|
    brand.resources :icons
  end
  map.resources :galleries , :path_prefix=>":locale" do |gallery|
    gallery.resources :photos, :member=>{:editname=>:post,:editdesc=>:post,:default=>:get},:collection=>{:positions=>:get}
  end



  #map.resources :attachments



  map.resources :pages,  :collection=>{:admin=>:get,:positions=>:get,:cleanup_mess=>:get}, :member => {:disable=>:put, :enable => :put, :withcomments=>:put, :nocomments=>:put} do |page|
    page.resources :attachments, :collection=>{:positions=>:get}, :member => {:disable=>:put, :enable => :put}, :name_prefix => 'page_' do |attachment|
      attachment.resources :icons
      attachment.resources :attachedfiles
    end
  end

  map.resources :editor_images, :controller => 'images'


  map.resources :articles, :collection => {:admin => :get, :list=>:get,:positions=>:get}, :member => {:disable=>:put, :enable => :put,:image=>:get,:onhomepage=>:put,:offhomepage=>:put, :withcomments=>:put, :nocomments=>:put}, :path_prefix => ":locale" do |article|
    article.resources :icons
  end
  map.resources :categories,  :collection => {:admin => :get} do |categories|
    categories.resources :articles, :name_prefix => 'category_', :path_prefix => ":locale"
  end


  map.index '/', :controller => 'home',
  :action => 'index'

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'


  map.sitemap '/:locale/home/sitemap', :controller=>'home', :action=>'sitemap'
  map.dynasitemap '/dynasitemap/:attr', :controller=>'home', :action=>'sitemap',:attr=>'tinymcelinks'
  map.rss '/:locale/home/rss', :controller=>'home', :action=>'rss'


  map.deactivate_warning '/deactivate_ie_message', :controller => 'account', :action => 'deactivate_ie_message'

  map.news_index '/:locale/news/:category_permalink',
  :controller=>'articles',
  :action=>'list',
  :category_permalink=>''

  map.news_archives '/:locale/archives/:category_permalink/:year/:month',
  :controller=>'articles',
  :action=>'list',
  :filter=>'news_monthly',
  :category_permalink=>'agenda',
  :month=>Time.now.month,
  :year=>Time.now.year,
  :requirements=>{
    :year  => /\d+/,
    :month => /\d+/
  }          



  map.news '/:locale/news/:category_id/',
  :controller=>'articles',
  :action=>'list'



  # map.connect ':locale/:controller/:action/:id'
  # # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
  map.search '/:locale/home/search', :controller=>'home', :action=>'search'
  map.map '/map', :controller=>'home', :action=>'map'
  map.translate '/:locale/translate',:controller=>'translate', :action=>'index'
   map.translate_export '/translate/export',:controller=>'translate', :action=>'export'
   map.translate_alpha '/:locale/translate/:letter',:controller=>'translate', :action=>'index'
  map.destroy_transalte_key '/:locale/translate/destroy/:id',:controller=>'translate', :action=>'destroy', :method=>:delete
  map.rss_feed '/rss/xml/news.xml', :controller=>'articles', :action=>'rss'
  #map.rss_feed ':locale/rss/xml/news.xml', :controller=>'articles', :action=>'rss'  

  map.error '*url', :controller => 'home', :action => 'e404'

  # map.error ':controllername',  :controller => 'home',  :action => '404'
end
