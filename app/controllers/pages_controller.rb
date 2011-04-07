class PagesController < ApplicationController


  #routing_navigator :except => [:show]
  require 'csv'
  require 'iconv' 
  before_filter :basic_auth, :except=>[:show]
  layout LAYOUT_2COLS
  #caches_page :show
  cache_sweeper :pages_sweeper, :only=>[:create, :update, :update_positions, :enable, :disable, :update_ajax, :destroy,:withcomments,:nocomments]

  def index
    @pages = Page.find_all_by_parent_id('0',:order=>'position')
    render :action => 'admin'
  end
  def admin
    @pages = Page.find_all_by_parent_id('0',:order=>'position')
  end
  def positions
    @homepage=Page.find(1)
    @parent_id=params[:parent_id]
    @parent=Page.find( @parent_id)
    @pages = Page.find_all_by_parent_id(@parent_id, :conditions=>"id>1",:order=>'position')

  end

  def update_positions
    @parent_id=params[:parent_id]
    @parent=Page.find( @parent_id)
    params[:pages_container].each_index do |i|
      item = Page.find(params[:pages_container][i])
      item.position = i+1
      item.save
    end
    @pages = Page.find_all_by_parent_id(@parent_id, :conditions=>"id>1",:order=>'position')
    render :layout => false, :action => :positions
  end

  def show
    used_layout=LAYOUT_MAIN
    @print_page=false
    if params[:print]
      used_layout="print"  
      @print_page=true
    end


    #RAILS_DEFAULT_LOGGER.error("\n redirect_back_or_default step 0 session current_user_roles#{session[:current_user_roles]}\n")
    @hide_ie_message=true
    @page = Page.find(params[:id].to_i)
    @parent=@page
    unless @page.parent_id==0
      @parent=@page.parent
    end
    render :layout=>used_layout
  end
  def test

  end
  def new
    @page = Page.new
  end

  def update_ajax
    @page = Page.find(params[:id].to_i)
    @page.body = params[:value]
    @page.save!
    flash.now[:notice] = "Page updated"
    render :text => params[:value]
  end

  def create

    @page = Page.new(params[:page])
    @parent_id=0
    if @page.parent
      @parent=@page.parent
      @parent_id=@parent.id
    end
    page_values=params[:page]
    @page.save!
    flash.now[:notice] = 'Page saved'.t
    respond_to do |format|
      format.html { 
        #   RAILS_DEFAULT_LOGGER.error("\n create_page respond HTML\n")
        redirect_to :action => 'admin' 
      }
      format.js  
    end
      # rescue ActiveRecord::RecordInvalid
      #     RAILS_DEFAULT_LOGGER.error("\n create_page respond HTML rescue error !\n")
      #    render :action => 'new'
    
  end

  def edit
    @page = Page.find(params[:id].to_i)
    @parent=@page
    unless @page.parent_id==0
      @parent=@page.parent
    end

  end




  def update
    @page = Page.find(params[:id].to_i)

    language_values=params[:page]
    @page.attributes=language_values

    if @page.save!
      #RAILS_DEFAULT_LOGGER.error("\n update_page  @page.save !\n")
      flash[:notice] = "Page updated".t
    else
      flash[:error] = "Page NOT updated".t
    end
    redirect_to :action => 'admin'
  rescue
    flash[:error] = "An error occured".t
    render :action => 'edit'
  end



  def destroy
    @page = Page.find(params[:id].to_i)
    @parent_id=0
    if @page.parent
      @parent=@page.parent
      @parent_id=@parent.id
    end
    if @page.destroy
      flash[:notice] = "Page deleted"
    else
      flash[:error] = "There was a problem deleting the page"
    end
    respond_to do |format|
      format.html {  redirect_to :action => 'admin' }
      format.js  
    end
  end




  def disable
    @page = Page.find(params[:id].to_i)
    @parent_id=0
    if @page.parent
      @parent=@page.parent
      @parent_id=@parent.id
    end
    if @page.update_attribute(:enabled, false)
      flash[:notice] = "Page disabled".t
    else
      flash[:error] = "There was a problem disabling this page.".t
    end
    respond_to do |format|
      format.html { redirect_to :action => 'admin' }
      format.js  
    end
  end

  def enable
    @page = Page.find(params[:id].to_i)
    @parent_id=0
    if @page.parent
      @parent=@page.parent
      @parent_id=@parent.id
    end
    if @page.update_attribute(:enabled, true)
      flash[:notice] = "Page enabled"[:user_enabled]
    else
      flash[:error] = "There was a problem enabling this page."[:problem_to_enable]
    end
    respond_to do |format|
      format.html { redirect_to :action => 'admin' }
      format.js  
    end
  end

  def withcomments
    @page = Page.find(params[:id].to_i)
    @parent_id=0
    if @page.parent
      @parent=@page.parent
      @parent_id=@parent.id
    end
    if @page.update_attribute(:with_comments, true)
      flash[:notice] = "Added comments to the page".t
    else
      flash[:error] = "There was a problem adding comments to this page.".t
    end
    respond_to do |format|
      format.html { redirect_to :action => 'admin' }
      format.js  
    end
  end

  def nocomments
    @page = Page.find(params[:id].to_i)
    @parent_id=0
    if @page.parent
      @parent=@page.parent
      @parent_id=@parent.id
    end
    if @page.update_attribute(:with_comments, false)
      flash[:notice] = "Removed comments to the page".t
    else
      flash[:error] = "There was a problem removing comments to this page.".t
    end
    respond_to do |format|
      format.html { redirect_to :action => 'admin' }
      format.js  
    end
  end

  # def export_dummy
  #     content_type = if request.user_agent =~ /windows/i
  #       'application/vnd.ms-excel'
  #     else
  #       'text/csv; charset=iso-8859-1;  header=present'
  #     end
  # 
  #     CSV::Writer.generate(output = "") do |csv|
  #       csv << ["id",   "title",    "title_de",       "title_en",   "permalink",    "body",      "body_de",       "body_en",    "keywords","description","keywords_de",  "description_de","keywords_en", "description_en","created_at", "updated_at","parent_id", "position","enabled","attachments_count" ]
  #       Tpage.find(:all).each do |page|
  #        csv << [page.id,   page.title,    page.title_de,       page.title_en,   page.permalink,    page.body,      page.body_de,       page.body_en,    page.keywords,page.description,page.keywords_de,  page.description_de,page.keywords_en, page.description_en,page.created_at, page.updated_at,page.parent_id, page.position,page.enabled,page.attachments_count ]
  #        
  #       end
  #     end
  #     c = Iconv.new('ISO-8859-1','UTF-8')
  #     send_data(c.iconv(output), 
  #     :type => content_type, 
  #     :filename => "pages.csv")
  #   end

  def export
    content_type = if request.user_agent =~ /windows/i
      'application/vnd.ms-excel'
    else
      'text/csv; charset=iso-8859-1;  header=present'
    end
    CSV::Writer.generate(output = "") do |csv|
      ar=[]
      for page in Page.content_columns 
        ar<<page.human_name 
      end
      csv << ar
      Page.find(:all).each do |page|
        ac=[]
        for column in Page.content_columns
          ac<<page.send(column.name) 
        end
        csv << ac
      end
    end
    c = Iconv.new('ISO-8859-1','UTF-8')
    send_data(c.iconv(output), 
    :type => content_type, 
    :filename => "pages.csv")
  end

  def show_all
    @pages=Page.find(:all)
  end


end
