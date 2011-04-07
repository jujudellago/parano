class PhotosController < ApplicationController
  layout LAYOUT_2COLS
  before_filter :set_gallery
  before_filter :basic_auth, :except=>[:show, :list,:index]
    
  def set_gallery
    @gallery=Gallery.find(params[:gallery_id])
  end
  # GET /photos
  # GET /photos.xml
  
   def update_positions
     params[:photos_list].each_index do |i|
       item = @gallery.photos.find(params[:photos_list][i])
       item.position = i+1
       item.save
     end
     @photos = @gallery.photos.find(:all,:order=>'position')
     render :layout => false, :action => :index
   end
  
  def index
    @photos = @gallery.photos.find(:all,:order=>'position')
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @photos.to_xml }
    end
  end

  # GET /photos/1
  # GET /photos/1.xml
  def show
    @photo = Photo.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @photo.to_xml }
    end
  end

  # GET /photos/new
  def new
    @photo = @gallery.photos.new
  end

  # GET /photos/1;edit
  def edit
    @photo = @gallery.photos.find(params[:id])
  end

  # POST /photos
  # POST /photos.xml
  # def create
  #    @photo = Photo.new(params[:photo])
  #    @gallery.photos<<@photo
  #    respond_to do |format|
  #      if @photo.save
  #        flash[:notice] = 'Photo was successfully created.'
  #        format.html { redirect_to gallery_photos_url(@gallery) }
  #        format.xml  { head :created, :location => gallery_photos_url(@gallery) }
  #        format.js do
  #          responds_to_parent do
  #            render :update do |page|
  #                page << "alert('yes I can!!')"
  #              # page.insert_html :bottom, "photos_list", :partial => '/photos/photo', :locals => { :photo => @photo} 
  #              #              page.visual_effect :highlight, "photo_#{@photo.id}" 
  #            end
  #          end
  #        end
  #      else
  #        format.html { render :action => "new" }
  #        format.xml  { render :xml => @photo.errors.to_xml }
  #        format.js do
  #          responds_to_parent do
  #            render :update do |page|
  #              # update the page with an error message
  #            end
  #          end          
  #        end
  #      end
  #    end
  #  end
 
  def create
    @photo = Photo.new(params[:photo])
    @gallery.photos<<@photo
    if @photo.save
      # if @gallery.default_photo_id.nil? || @gallery.photos.size==1
      #   @gallery.default_photo_id=@photo.id
      #   @gallery.save
      # end
      flash[:notice] = 'Photo was successfully created.' 
      responds_to_parent do
        render :update do |page|
          #page << "alert('yes I can!!')"
          page.insert_html :bottom, "photos_list", :partial => '/photos/photo', :locals => { :photo => @photo} 
          page.visual_effect :highlight, "photo_#{@photo.id}" 
          page['photo_form_container'].toggle
          page['fu_form'].reset
        end
      end
    else
      format.html { render :action => "new" }
      format.xml  { render :xml => @photo.errors.to_xml }
      format.js do
        responds_to_parent do
          render :update do |page|
            # update the page with an error message
          end
        end          
      end
    end
  end

  def default
     @photo = Photo.find(params[:id])
     @gallery=Gallery.find(params[:gallery_id])
     @gallery.default_photo_id=@photo.id
     if @gallery.save
       flash[:notice] = 'Photo was successfully defined as default.'
       redirect_to gallery_photos_url(@gallery)
     end
  end

  def editname
    @photo = Photo.find(params[:id])
     @photo.name=params[:value]
    if @photo.save
      render :text => @photo.name
    end
  end
  def editdesc
    @photo = Photo.find(params[:id])
     @photo.legend=params[:value]
    if @photo.save
      render :text => @photo.legend
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
    @photo = Photo.find(params[:id])
    @photo.destroy
    if @gallery.default_photo_id==params[:id]
      @gallery.default_photo_id=nil
      @gallery.save    
    end
    
    flash[:notice] = 'Photo was successfully destroyed.'
    respond_to do |format|
      format.html { redirect_to gallery_photos_url(@gallery) }
       format.js
      format.xml  { head :ok }
    end
  end
end
