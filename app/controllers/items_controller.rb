class ItemsController < ApplicationController

  before_filter :admin_required, :except => [:index, :show]
  before_filter :check_cancel, :only => [:create, :update]

  # GET /items
  def index
    @q = params[:query]
    @page = (params[:page].to_i > 0) ? params[:page] : 1
    @sort_column = params[:sort_column] ? params[:sort_column] : "items.name"
    @sort_direction = params[:sort_direction] ? params[:sort_direction] : "ASC"

    q_front = "#{@q}%"
    cstring = "items.name LIKE ?"
    coptions = [q_front]

    conditions = [cstring, coptions].flatten
    find_items(conditions, @sort_column, @sort_direction, @page)
    #if we have a page > the last one, redo the query turning the page into the last one
    find_items(conditions, @sort_column, @sort_direction, @items.total_pages) if params[:page].to_i > @items.total_pages

    respond_to do |format|
      format.html {
      }
      format.js {
        render(:partial => "items.html.haml", :locals => {:items => @items})
      }
    end
  end

  def show
    @item = Item.find(params[:id])

    respond_to do |format|
      format.html # index.html.haml
    end
  end

  def new
    @item = Item.new(:quality => 4)

    respond_to do |format|
      format.html # index.html.haml
    end
  end

  def edit
    @item = Item.find(params[:id])

    respond_to do |format|
      format.html # index.html.haml
    end
  end

  # POST /items
  def create
    @item = Item.new(params[:item])

    respond_to do |format|
      format.html do
        if @item.save
          flash[:notice] = "Item was successfully created."
          redirect_to(:items)
        else
          render(:action => "new")
        end
      end
    end
  end

  # PUT /items/1
  def update
    @item = Item.find(params[:id])
    respond_to do |format|
      if @item.update_attributes(params[:item])
        flash[:notice] = 'Item was successfully updated.'
        format.html { redirect_to(:items) }
      else
        format.html { render(:action => "edit") }
      end
    end
  end

  # DELETE /items/1
  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to(:items) }
    end
  end

  protected

    def find_items(conditions, sort_column, sort_direction, page)
      @items = Item.page(conditions, sort_column, sort_direction, page)
    end

    def check_cancel
      redirect_to(:items) and return if (params[:commit] == t('label.cancel'))
    end

end # Items
