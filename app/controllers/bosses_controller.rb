class BossesController < ApplicationController

  before_filter :admin_required
  before_filter :check_cancel, :only => [:create, :update]

  def index
    @bosses = Boss.all

    respond_to do |format|
      format.html # index.html.haml
    end
  end

  def show
    @boss = Boss.find(params[:id])

    respond_to do |format|
      format.html # index.html.haml
    end
  end

  def new
    @boss = Boss.new

    respond_to do |format|
      format.html # index.html.haml
    end
  end

  def edit
    @boss = Boss.find(params[:id])

    respond_to do |format|
      format.html # index.html.haml
    end
  end

  # POST /bosses
  def create
    @boss = Boss.new(params[:boss])

    respond_to do |format|
      format.html do
        if @boss.save
          flash[:notice] = "Boss was successfully created."
          redirect_to(:bosses)
        else
          render(:action => "new")
        end
      end
    end
  end

  # PUT /bosses/1
  def update
    @boss = Boss.find(params[:id])
    respond_to do |format|
      if @boss.update_attributes(params[:boss])
        flash[:notice] = 'Boss was successfully updated.'
        format.html { redirect_to(:bosses) }
      else
        format.html { render(:action => "edit") }
      end
    end
  end

  # DELETE /bosses/1
  def destroy
    @boss = Boss.find(params[:id])
    @boss.destroy

    respond_to do |format|
      format.html { redirect_to(:bosses) }
    end
  end

  protected
    def check_cancel
      redirect_to(:bosses) and return if (params[:commit] == t('label.cancel'))
    end

end # Bosses
