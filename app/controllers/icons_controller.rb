class IconsController < ApplicationController
  layout LAYOUT_2COLS
 
  before_filter :basic_auth, :except=>[:show, :index]
  before_filter :set_datas, :except=> :index
  def set_datas
    @page=Page.find(params[:page_id]) if params[:page_id]
    @attachment=Attachment.find(params[:attachment_id]) if params[:attachment_id]
    @article=Article.find(params[:article_id]) if params[:article_id]
    @brand=Brand.find(params[:brand_id]) if params[:brand_id]
  end
  # GET /photos
  # GET /photos.xml
  def index
    @icons = Icon.find(:all, :conditions=>'thumbnail is null')
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @icons.to_xml }
    end
  end

  # GET /photos/1
  # GET /photos/1.xml
  def show
    @icon = Icon.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @icon.to_xml }
    end
  end

  # GET /photos/new
  def new
    @icon = @attachment.icon.new
  end

  # GET /photos/1;edit
  def edit
    @icon = @attachment.icon.find(params[:id])
  end

 
  def create
    @icon = Icon.new(params[:icon])
    @attachment.icon=@icon if @attachment
    @article.icon=@icon if @article
    @brand.icon=@icon if @brand
    if @icon.save
      flash[:notice] = 'Icon was successfully created.' 
      responds_to_parent do
        render :update do |page|
          #page << "alert('yes I can!!')"
          if @attachment
            page.replace_html  "icons_list", :partial => '/attachments/icon', :locals => { :icon => @icon} 
            page.replace_html  "link_image", :partial => '/attachments/link_image', :locals => { :icon => @icon} 
          elsif @article
             page.replace_html  "icons_list", :partial => '/articles/icon', :locals => { :icon => @icon} 
          elsif @brand
             page.replace_html  "icons_list", :partial => '/brands/icon', :locals => { :icon => @icon} 
          end
          
          page['icons_form'].hide
          page.visual_effect :highlight, "attachedfile_icon" 
          page['fu_form'].reset
        end
      end
    else
      format.html { render :action => "new" }
      format.xml  { render :xml => @icon.errors.to_xml }
      format.js do
        responds_to_parent do
          render :update do |page|
            # update the page with an error message
          end
        end          
      end
    end
  end


  # PUT /photos/1
  # PUT /photos/1.xml
  def update
    @photo = Photo.find(params[:id])

    respond_to do |format|
      if @photo.update_attributes(params[:photo])
        flash[:notice] = 'Photo was successfully updated.'
        format.html { redirect_to gallery_photos_url(@gallery) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @photo.errors.to_xml }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.xml
  def destroy
    @icon = Icon.find(params[:id])
    @icon.destroy
    flash[:notice] = 'Photo was successfully destroyed.'
    respond_to do |format|
      format.html { redirect_to attachment_url(@attachment) }
       format.js 
      format.xml  { head :ok }
    end
  end
end
