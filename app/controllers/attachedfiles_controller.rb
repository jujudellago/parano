class AttachedfilesController < ApplicationController

   before_filter :basic_auth, :except=>[:show, :index]
   
  before_filter :set_datas
    layout LAYOUT_MAIN
  def set_datas
    @page=Page.find(params[:page_id])
    @attachment=Attachment.find(params[:attachment_id])
  end
  # GET /photos
  # GET /photos.xml
  def index
    @attachedfiles = @attachment.attachedfiles.find(:all)
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @attachedfiles.to_xml }
    end
  end

  # GET /photos/1
  # GET /photos/1.xml
  def show
    @attachedfile = Attachedfile.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @attachedfile.to_xml }
    end
  end

  # GET /photos/new
  def new
    @attachedfile = @attachment.attachedfile.new
  end

  # GET /photos/1;edit
  def edit
    @attachedfile = @attachment.attachedfile.find(params[:id])
  end

 
  def create
    @attachedfile = Attachedfile.new(params[:attachedfile])
    @attachment.attachedfile=@attachedfile
    if @attachedfile.save
      flash[:notice] = 'attachedfile was successfully created.' 
      responds_to_parent do
        render :update do |page|
         # page << "alert('yes I can!!')"
          page.replace_html  "link_file", :partial => '/attachments/attachedfile', :locals => { :attachedfile => @attachedfile} 
          page['attachedfiles_form'].toggle
          page.visual_effect :highlight, "link_file" 
          page['fu_file_form'].reset
          #page.replace_html  "upload_file_form_div",:partial => '/attachments/upload_file_form'
        end
      end
    else
      format.html { render :action => "new" }
      format.xml  { render :xml => @attachedfile.errors.to_xml }
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
    @attachedfile = Attachedfile.find(params[:id])
    @attachedfile.destroy
    flash[:notice] = 'Photo was successfully destroyed.'
    respond_to do |format|
      format.html { redirect_to attachment_url(@attachment) }
       format.js 
      format.xml  { head :ok }
    end
  end
end
