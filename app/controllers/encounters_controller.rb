class EncountersController < ApplicationController

  before_filter :admin_required
  before_filter :check_cancel, :only => [:create, :update]

  def index
    @encounters = Encounter.all

    respond_to do |format|
      format.html # index.html.haml
    end
  end

  def show
    @encounter = Encounter.find(params[:id])

    respond_to do |format|
      format.html # index.html.haml
    end
  end

  def new
    @encounter = Encounter.new
    @bosses = Boss.all
    @dungeons = Dungeon.all

    respond_to do |format|
      format.html # index.html.haml
    end
  end

  def load_items
    encounter = Encounter.find(params[:id])
    array = []
    encounter.drops.each do |drop|
      array << {:optionDisplay => drop.item.name, :optionValue => drop.item.id}
    end
    array.to_json
  end

  def edit
    @encounter = Encounter.find(params[:id])
    @dungeons = Dungeon.all
    @bosses = Boss.all

    respond_to do |format|
      format.html # index.html.haml
    end
  end

  # POST /encounters
  def create
    @encounter = Encounter.new(params[:encounter])

    respond_to do |format|
      format.html do
        if @encounter.save
          flash[:notice] = "Encounter was successfully created."
          redirect_to(:encounters)
        else
          @dungeons = Dungeon.all
          @bosses = Boss.all
          render(:action => "new")
        end
      end
    end
  end

  # PUT /encounters/1
  def update
    @encounter = Encounter.find(params[:id])
    respond_to do |format|
      if @encounter.update_attributes(params[:encounter])
        flash[:notice] = 'Encounter was successfully updated.'
        format.html { redirect_to(:encounters) }
      else
        format.html { render(:action => "edit") }
      end
    end
  end

  # DELETE /encounters/1
  def destroy
    @encounter = Encounter.find(params[:id])
    @encounter.destroy

    respond_to do |format|
      format.html { redirect_to(:encounters) }
    end
  end

  protected
    def check_cancel
      redirect_to(:encounters) and return if (params[:commit] == t('label.cancel'))
    end

end # Encounters
