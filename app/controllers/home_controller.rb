class HomeController < ApplicationController
  helper 'pages'
  layout LAYOUT_MAIN
  def e404
  end
  def index
    sql_params=" published=1"
    #@category=Category.find_by_homepage(true)
    
    @articles=Article.find(:all, :conditions=>sql_params,:order=>'published_at desc', :limit=>1)
    render :layout=> LAYOUT_2COLS
    
  end

  def search
    @query = params[:query]
    # @total, @items = Page.full_text_search(@query, :page => (params[:page]||1))          
    # @pages = pages_for(@total)

    articles = Article.find_id_by_contents(@query)
    pages = Page.find_id_by_contents(@query)
    @matches = (articles + pages).sort_by {|match| match[:score] }
    @hits=0
    @found_articles=Array.new
    @found_pages=Array.new
    if @matches.size>0
      @matches.each do |item| 
        # RAILS_DEFAULT_LOGGER.error("\n search:  #{item.inspect} session[:current_user_roles]=#{session[:current_user_roles]} \n")
        if item[:model] && item[:model]=="Page" 
          page=Page.find(item[:id])
          if page.can_be_viewed(session[:current_user_roles])  
            @found_pages<<page
            @hits=@hits+1
          end 
        else 
          article=Article.find(item[:id])
          if article.can_be_viewed(session[:current_user_roles])
            @found_articles<<article
            @hits=@hits+1
          end
        end  
      end
    end
  end
  def rss
    
  end
  
  
  
  def sitemap
    
    @pages = Page.find_all_by_parent_id('0',:order=>'position') 
    @tinymcelinks=false
    if params[:attr] && params[:attr]=='tinymcelinks'
      @tinymcelinks=true
       render :layout=> 'popup'
    end
  
  end
  
end
