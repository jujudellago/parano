class AttachmentsController < ApplicationController
#  routing_navigator :on 
  # GET /attachments
  # GET /attachments.xml
  layout LAYOUT_2COLS
  before_filter :set_page
   before_filter :basic_auth, :except=>[:show, :index]
    
  cache_sweeper :attachments_sweeper, :only=>[:create, :update, :update_positions, :enable, :disable, :destroy]
  
  def set_page
      @page=Page.find(params[:page_id]) 
  end

  def index
    # @attachments = Attachment.find_all_by_page_id(@page.id)
    cleanup_empty_attachments
    @lang_attachments=Hash.new
    MENU_LOCALES.each do |key| 
      @lang_attachments[key] =Attachment.find_all_by_page_id(@page.id, :order=>'position', :include=>'icon',:conditions=>"language_code='#{key}'")
    end

    # LOCALES.each do |key, value| 
    #      @lang_attachments[key] =Attachment.find_all_by_page_id(1, :order=>'language_code asc', :include=>'icon',:conditions=>"language_code='#{key}'").group_by{|t|t.language_code}
    #    end
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @attachment.to_xml }
    end
  end
  def positions
    @language_code=params[:language_code]
    @attachments = @page.attachments.find_all_by_language_code(@language_code, :order=>'position')

  end

  def update_positions
    @language_code=params[:language_code]
    params[:attachments_container].each_index do |i|
      item = Attachment.find(params[:attachments_container][i])
     
      if item.show_what=="text" 
        item.position = i+1   
      else
        item.position = i+100
      end
      item.save
    end
    @attachments = @page.attachments.find_all_by_language_code(@language_code, :order=>'position')
    render :layout => false, :action => :positions
  end


  # GET /attachment/1
  # GET /attachment/1.xml
  def show
    @attachment = @page.attachments.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @attachment.to_xml }
    end
  end

  # GET /attachment/new
  def new
    @attachment = @page.attachments.new(:page_id=>@page.id, :language_code=>params[:language_code])
    @attachment.save
    @attachment.show_what="text"
    @attachment.linktype="url"
  end

  # GET /attachment/1;edit
  def edit
    @attachment = @page.attachments.find(params[:id])
    @icon=@attachment.icon
    @attachedfile=@attachment.attachedfile
    @edit_rights=false
    if params[:edit_rights]
        @edit_rights=true
    end
  end

  # POST /attachment
  # POST /attachment.xml
  def create
    @attachment = @page.attachments.find(params[:new_id]) #Attachment.new(params[:attachment])
    params[:attachment]['role_ids'] ||=[]
    if params[:public_page]=="public"
      params[:attachment]['role_ids']=[]
    end
     #RAILS_DEFAULT_LOGGER.error("\n create_attachment params[:position]=#{params[:position]}\n")
    if params[:position] && !params[:position].blank?
      params[:attachment]['position']=params[:position]
     # RAILS_DEFAULT_LOGGER.error("\n create_attachment params[:attachment]['position']= #{params[:attachment]['position']}\n")
    end
    
    # @page.attachments<<@attachment
    respond_to do |format|
      if @attachment.update_attributes(params[:attachment])
        cleanup_empty_attachments
        flash[:notice] = 'attachment was successfully created.'
        format.html { redirect_to page_attachments_url }
        format.xml  { head :created, :location => page_attachment_url(@attachment) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @attachment.errors.to_xml }
      end
    end
  end

  # PUT /attachment/1
  # PUT /attachment/1.xml
  def update
    @attachment = Attachment.find(params[:id])
    params[:attachment]['role_ids'] ||=[]
    if params[:public_page]=="public"
      params[:attachment]['role_ids']=[]
    end
      # RAILS_DEFAULT_LOGGER.error("\n create_attachment params[:position]=#{params[:position]}\n")
      if params[:position] && !params[:position].blank?
        params[:attachment]['position']=params[:position]
      #  RAILS_DEFAULT_LOGGER.error("\n create_attachment params[:attachment]['position']= #{params[:attachment]['position']}\n")
      end
    respond_to do |format|
      if @attachment.update_attributes(params[:attachment])
        flash[:notice] = 'attachment was successfully updated.'.t
        format.html { redirect_to page_attachments_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @attachment.errors.to_xml }
      end
    end
  end

  # DELETE /attachment/1
  # DELETE /attachment/1.xml
  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy
    flash[:notice] = 'attachment was successfully destroyed.'.t
    respond_to do |format|
      format.html { redirect_to page_attachments_url }
      format.xml  { head :ok }
    end
  end
  
  
  def disable
    @attachment = Attachment.find(params[:id])
     if @attachment.update_attribute(:enabled, false)
       flash[:notice] = "Attachment disabled".t
     else
       flash[:error] = "There was a problem disabling this attachment.".t
     end
      respond_to do |format|
         format.html { redirect_to page_attachments_url }
         format.js  
       end
   end

   def enable
     @attachment = Attachment.find(params[:id])
      if @attachment.update_attribute(:enabled,true)
        flash[:notice] = "Attachment enabled".t
      else
        flash[:error] = "There was a problem enabling this attachment.".t
      end
       respond_to do |format|
          format.html { redirect_to page_attachments_url }
          format.js  
        end

    end


  protected
  def cleanup_empty_attachments
    @cleanup= Attachment.find(:all, :conditions=>'name is null AND url  is null AND legend is null AND enabled is null AND position is null AND show_what is null AND linktype is null')
    @cleanup.each do |attachment|
      attachment.destroy
    end
  end
end
