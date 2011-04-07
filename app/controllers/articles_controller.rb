class ArticlesController < ApplicationController
  # GET /articles
  # GET /articles.xml
  layout LAYOUT_2COLS
  # routing_navigator :on 
  before_filter :basic_auth, :except=>[:show, :list]
    
  cache_sweeper :articles_sweeper, :only=>[:create, :update,  :enable, :disable, :update_ajax, :destroy,:withcomments,:nocomments]

  def set_category
    if params[:category_id]
      @category=Category.find(params[:category_id]) 
      @category_id=@category.id
    end
  end

  def positions
    @language_code=params[:language_code]
    @category=Category.find(:first, :conditions=>'homepage=1')
    @articles =  @category.articles.find_all_by_language_code(@language_code, :order=>'position')

  end

  def update_positions
    @language_code=params[:language_code]
    params[:articles_container].each_index do |i|
      item = Article.find(params[:articles_container][i])
      item.position = i+1   
      item.save
    end
    @category=Category.find(:first, :conditions=>'homepage=1')
    @articles =  @category.articles.find_all_by_language_code(@language_code, :order=>'position')
    render :layout => false, :action => :positions
  end


  def rss   
    sql='category_id in (2,3,4,5)'
   # sql='category_id = 2'
    if params[:locale]
      sql<<" and language_code='#{params[:locale]}'"
    end
    @articles = Article.find_all_by_published(true, :order=>'published_at desc',:conditions=>sql) 
    headers["content-Type"]="application/rss+xml"
    render :layout => false
    # respond_to do |wants|
    #       wants.xml  { render :xml => @articles.to_xml }
    #       wants.rss  { render :action => 'rss.rxml', :layout => false }
    # #     format.rss  { render :action => "#{template_name}.rxml", :layout => false }
    #       wants.atom { render :action => 'atom.rxml', :layout => false }
    #     end
  end



  def index
    @homepage_list=false
    order='created_at desc'
    sql_conditions=" id>0"

    if @category_id=params[:category_id]
      @category=Category.find(@category_id)
      if @category.homepage
        @homepage_list=true
        order=" position"
      elsif @category.agenda
        order="event_date desc, position"
      end
      @articles=@category.articles.paginate  :page=> params[:page],  :order=>order,  :conditions => sql_conditions
    else
      @articles=Article.paginate  :page=> params[:page],  :order=>order,  :conditions => sql_conditions
    end
    @use_ajax_table=true
    respond_to do |format|
      format.html # index.html.erb
      format.js do
        render :update do |page|
          page.replace_html 'articles_table', :partial => "articles_list"
        end
      end
    end

    # respond_to do |format|
    #   format.html # index.rhtml
    #   format.xml  { render :xml => @articles.to_xml }
    # end
  end

  def list
    if params[:category_permalink]
      @category=Category.find_by_permalink(params[:category_permalink]) 
    end
    if @category.nil?
      @category=Category.find_by_homepage(true)
    end
    order='published_at desc'
    conditions=" id>0 and published=true"
    if params[:filter] && params[:filter]=='news_monthly'
        conditions=["month(articles.published_at)=? and year(articles.published_at)=?",params[:month],params[:year]]
    end

    @articles=Article.paginate(:all,:page => params[:page],:conditions=>conditions,:order=>order)
  
    render :layout=>LAYOUT_MAIN
  end




  # GET /articles/1
  # GET /articles/1.xml
  def show

    used_layout=LAYOUT_MAIN
    @print_page=false
    if params[:print]
      used_layout="print"  
      @print_page=true
    end

    @article = Article.find(params[:id])
    if @article.published
      @display_date=@article.published_at.loc("%d. %B %Y")
     #if @article.category.agenda
     #  @display_date=@article.event_date.loc("%d. %B %Y")
     #end
    else
      @display_date="Not published yet".t
    end
    render :layout=>used_layout
  end

  # GET /articles/new
  def new
    #set_category
    @article = Article.new(:category_id=>params[:category_id])
  end

  def image
    @article = Article.find(params[:id])
    #    @icon= @article.build_icon 
    @icon=@article.icon
  end


  # GET /articles/1;edit
  def edit
    @article = Article.find(params[:id])
    @icon=@article.icon
  end

  # POST /articles
  # POST /articles.xml
  def create
    @article = Article.new(params[:article])    
    respond_to do |format|
      if @article.save
        flash[:notice] = 'Article was successfully created.'.t
        format.html { redirect_to image_article_path(@article) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    @article = Article.find(params[:id])
    respond_to do |format|
      if @article.update_attributes(params[:article])
        flash[:notice] = 'Article was successfully updated.'.t
        format.html { redirect_to articles_url(:category_id=>@article.category_id) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors.to_xml }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url }
      format.xml  { head :ok }
      format.js  
    end
  end


  def disable
    @article = Article.find(params[:id])
    if @article.update_attribute(:published, false)
      flash[:notice] = "Article disabled".t
    else
      flash[:error] = "There was a problem disabling this article.".t
    end
    respond_to do |format|
      format.html { redirect_to articles_url }
      format.js  
    end
  end

  def enable
    @article = Article.find(params[:id])
    if @article.update_attributes({:published=>true,:published_at=>Time.now})
      #@article.published_at = Time.now 

      flash[:notice] = "Article enabled".t
    else
      flash[:error] = "There was a problem enabling this article.".t
    end
    respond_to do |format|
      format.html { redirect_to articles_url }
      format.js  
    end
  end


  def withcomments
    @article = Article.find(params[:id])
    if @article.update_attribute(:with_comments, true)
      #@article.published_at = Time.now 

      flash[:notice] = "Added comments to the article".t
    else
      flash[:error] = "There was a problem adding commments for this article.".t
    end
    respond_to do |format|
      format.html { redirect_to articles_url }
      format.js  
    end
  end
  def nocomments
    @article = Article.find(params[:id])
    if @article.update_attribute(:with_comments, false)
      flash[:notice] = "Removed comments to the article".t
    else
      flash[:error] = "There was a problem removing commments for this article.".t
    end
    respond_to do |format|
      format.html { redirect_to articles_url }
      format.js  
    end
  end



end
