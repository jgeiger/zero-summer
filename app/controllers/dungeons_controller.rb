class DungeonsController < ApplicationController

  before_filter :admin_required
  before_filter :check_cancel, :only => [:create, :update]

  # GET /dungeons
  def index
    @q = params[:query]
    @page = (params[:page].to_i > 0) ? params[:page] : 1

    q_front = "#{@q}%"
    cstring = "name LIKE ?"
    coptions = [q_front]

    conditions = [cstring, coptions].flatten
    find_dungeons(conditions, @page)
    #if we have a page > the last one, redo the query turning the page into the last one
    find_dungeons(conditions, @dungeons.total_pages) if params[:page].to_i > @dungeons.total_pages

    respond_to do |format|
      format.html {
      }
      format.js {
        render(:partial => "dungeons/dungeons.html.haml", :locals => {:dungeons => @dungeons})
      }
    end
  end

  def show
    @dungeon = Dungeon.find(params[:id])

    respond_to do |format|
      format.html # index.html.haml
    end
  end

  def new
    @dungeon = Dungeon.new

    respond_to do |format|
      format.html # index.html.haml
    end
  end

  def edit
    @dungeon = Dungeon.find(params[:id])

    respond_to do |format|
      format.html # index.html.haml
    end
  end

  # POST /dungeons
  def create
    @dungeon = Dungeon.new(params[:dungeon])

    respond_to do |format|
      format.html do
        if @dungeon.save
          @dungeon.set_title
          @dungeon.save
          @dungeon.build
          flash[:notice] = "Dungeon was successfully created."
          redirect_to(:dungeons)
        else
          render(:action => "new")
        end
      end
    end
  end

  # PUT /dungeons/1
  def update
    @dungeon = Dungeon.find(params[:id])
    respond_to do |format|
      if @dungeon.update_attributes(params[:dungeon])
        flash[:notice] = 'Dungeon was successfully updated.'
        format.html { redirect_to(:dungeons) }
      else
        format.html { render(:action => "edit") }
      end
    end
  end

  # DELETE /dungeons/1
  def destroy
    @dungeon = Dungeon.find(params[:id])
    @dungeon.destroy

    respond_to do |format|
      format.html { redirect_to(:dungeons) }
    end
  end

  protected

    def find_dungeons(conditions, page)
      @dungeons = Dungeon.page(conditions, page)
    end

    def check_cancel
      redirect_to(:dungeons) and return if (params[:commit] == t('label.cancel'))
    end

end # Dungeons
