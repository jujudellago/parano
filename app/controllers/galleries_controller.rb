class GalleriesController < ApplicationController
  # GET /galleries
  # GET /galleries.xml
  layout LAYOUT_2COLS
  before_filter :basic_auth, :except=>[:show, :list, :index ]
    in_place_edit_for :gallery, :name

  def index
    @galleries = Gallery.find(:all,:order=>'created_at DESC')

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @galleries.to_xml }
    end
  end

  # GET /galleries/1
  # GET /galleries/1.xml
  def show
    @gallery = Gallery.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @gallery.to_xml }
    end
  end

  # GET /galleries/new
  def new
    @gallery = Gallery.new
  end

  # GET /galleries/1;edit
  def edit
    @gallery = Gallery.find(params[:id])
  end

  # POST /galleries
  # POST /galleries.xml
  def create
    @gallery = Gallery.new(params[:gallery])

    respond_to do |format|
      if @gallery.save
        flash[:notice] = 'Gallery was successfully created.'[:gallery_success_created]
        format.html { redirect_to galleries_url }
        format.xml  { head :created, :location => galleries_url }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @gallery.errors.to_xml }
      end
    end
  end

  # PUT /galleries/1
  # PUT /galleries/1.xml
  def update
    @gallery = Gallery.find(params[:id])

    respond_to do |format|
      if @gallery.update_attributes(params[:gallery])
        flash[:notice] = 'Gallery was successfully updated.'[:gallery_success_updated]
        format.html { redirect_to galleries_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @gallery.errors.to_xml }
      end
    end
  end

  # DELETE /galleries/1
  # DELETE /galleries/1.xml
  def destroy
    @gallery = Gallery.find(params[:id])
    @gallery.destroy

    respond_to do |format|
      format.html { redirect_to galleries_url }
      format.xml  { head :ok }
    end
  end
end
