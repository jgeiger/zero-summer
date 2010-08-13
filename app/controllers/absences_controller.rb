class AbsencesController < ApplicationController

  before_filter :admin_required, :except => [:index, :show]
  before_filter :check_cancel, :only => [:create, :update]

  def index
    @q = params[:query]
    page = (params[:page].to_i > 0) ? params[:page] : 1
    @sort_column = params[:sort_column] ? params[:sort_column] : "event_date"
    @sort_direction = params[:sort_direction] ? params[:sort_direction] : "DESC"

    q_front = "#{@q}%"
    cstring = "members.name LIKE ? OR DATE_FORMAT(event_date, '%m/%d/%Y') LIKE ?"

    conditions = [cstring, q_front, q_front]
    find_absences(conditions, @sort_column, @sort_direction, page)
    #if we have a page > the last one, redo the query turning the page into the last one
    find_absences(conditions, @sort_column, @sort_direction, @absences.total_pages) if params[:page].to_i > @absences.total_pages

    respond_to do |format|
      format.html {
        @absence = Absence.new(:event_date => Date.today.to_s(:us))
        @active_members = Member.active
      }
      format.js {
        render(:partial => "absences.html.haml", :locals => {:absences => @absences})
      }
    end
  end

  def show
    @absence = Absence.find(params[:id])

    respond_to do |format|
      format.html # index.html.haml
    end
  end

  def new
    @absence = Absence.new(:event_date => Date.today.to_s(:us))
    @active_members = Member.active

    respond_to do |format|
      format.html # index.html.haml
    end
  end

  def edit
    @absence = Absence.find(params[:id])
    @active_members = Member.active

    respond_to do |format|
      format.html # index.html.haml
    end
  end

  # POST /absences
  def create
    @absence = Absence.new(params[:absence])
    respond_to do |format|
      format.js do
        if @absence.save
          @absences = find_absences('', 'event_date', 'DESC', 1)
        else
          render(:json => {'status' => 'failed'})
        end
      end
    end
  end

  # PUT /absences/1
  def update
    @absence = Absence.find(params[:id])
    respond_to do |format|
      if @absence.update_attributes(params[:absence])
        flash[:notice] = 'Absence was successfully updated.'
        format.html { redirect_to(:absences) }
      else
        @active_members = Member.active
        format.html { render(:action => "edit") }
      end
    end
  end

  # DELETE /absences/1
  def destroy
    @absence = Absence.find(params[:id])

    respond_to do |format|
      format.js do
        if @absence.destroy
          render(:json => {'status' => 'success'})
        else
          render(:json => {'status' => 'failure'})
        end
      end

      format.html do
        @absence.destroy
        redirect_to(:absences)
      end
    end
  end

  protected

    def find_absences(conditions, sort_column, sort_direction, page)
      @absences = Absence.page(conditions, sort_column, sort_direction, page)
    end

    def check_cancel
      redirect_to(:absences) and return if (params[:commit] == t('label.cancel'))
    end

end # Absences
