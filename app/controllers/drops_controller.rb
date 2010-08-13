class DropsController < ApplicationController

  before_filter :admin_required
  before_filter :check_cancel, :only => [:create, :update]

  # GET /drops
  def index
    @q = params[:query]
    @page = (params[:page].to_i > 0) ? params[:page] : 1
    @sort_column = params[:sort_column] ? params[:sort_column] : "items.name"
    @sort_direction = params[:sort_direction] ? params[:sort_direction] : "ASC"

    q_front = "#{@q}%"
    cstring = "items.name LIKE ?"
    coptions = [q_front]

    conditions = [cstring, coptions].flatten
    find_drops(conditions, @sort_column, @sort_direction, @page)
    #if we have a page > the last one, redo the query turning the page into the last one
    find_drops(conditions, @sort_column, @sort_direction, @drops.total_pages) if params[:page].to_i > @drops.total_pages

    respond_to do |format|
      format.html {
      }
      format.js {
        render(:partial => "shared/drops.html.haml", :locals => {:drops => @drops})
      }
    end
  end

  def show
    @drop = Drop.find(params[:id])

    respond_to do |format|
      format.html # index.html.haml
    end
  end

  def new
    @drop = Drop.new
    @items = Item.all(:order => :name)
    @encounters = Encounter.all(:order => 'dungeon_id, boss_id, difficulty')

    respond_to do |format|
      format.html # index.html.haml
    end
  end

  def edit
    @drop = Drop.find(params[:id])
    @items = Item.all(:order => :name)
    @encounters = Encounter.all(:order => 'dungeon_id, boss_id, difficulty')

    respond_to do |format|
      format.html # index.html.haml
    end
  end

  # POST /drops
  def create
    @drop = Drop.new(params[:drop])

    respond_to do |format|
      format.html do
        if @drop.save
          flash[:notice] = "Drop was successfully created."
          redirect_to(:drops)
        else
          @items = Item.all(:order => :name)
          @encounters = Encounter.all(:order => 'dungeon_id, boss_id, difficulty')
          render(:action => "new")
        end
      end
    end
  end

  # PUT /drops/1
  def update
    @drop = Drop.find(params[:id])
    respond_to do |format|
      if @drop.update_attributes(params[:drop])
        flash[:notice] = 'Drop was successfully updated.'
        format.html { redirect_to(:drops) }
      else
        @items = Item.all(:order => :name)
        @encounters = Encounter.all(:order => 'dungeon_id, boss_id, difficulty')
        format.html { render(:action => "edit") }
      end
    end
  end

  # DELETE /drops/1
  def destroy
    @drop = Drop.find(params[:id])
    @drop.destroy

    respond_to do |format|
      format.html { redirect_to(:drops) }
    end
  end

  protected

    def find_drops(conditions, sort_column, sort_direction, page)
      @drops = Drop.page(conditions, sort_column, sort_direction, page)
    end

    def check_cancel
      redirect_to(:drops) and return if (params[:commit] == t('label.cancel'))
    end

end # Drops
