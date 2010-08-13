class MembersController < ApplicationController

  before_filter :admin_required, :except => [:index, :show, :raid_attending]
  before_filter :check_cancel, :only => [:create, :update]

  # GET /members
  def index
    @q = params[:query]
    @page = (params[:page].to_i > 0) ? params[:page] : 1
    @sort_column = params[:sort_column] ? params[:sort_column] : "name"
    @sort_direction = params[:sort_direction] ? params[:sort_direction] : "ASC"

    q_front = "#{@q}%"
    cstring = "members.name LIKE ?"
    coptions = [q_front]

    if !admin?
      cstring << " AND members.rank != ? AND members.rank != ?"
      coptions << ['Departed', 'Inactive']
    end

    conditions = [cstring, coptions].flatten
    find_members(conditions, @sort_column, @sort_direction, @page)
    #if we have a page > the last one, redo the query turning the page into the last one
    find_members(conditions, @sort_column, @sort_direction, @members.total_pages) if params[:page].to_i > @members.total_pages

    respond_to do |format|
      format.html {
        @adjustment_sum = Adjustment.sum(:amount)
      }
      format.js {
        render(:partial => "members/members.html.haml", :locals => {:members => @members})
      }
    end
  end

  # GET /raid_attending/
  def raid_attending
    @q = params[:query]
    @since = params[:since] || 8
    @sort_column = params[:sort_column] ? params[:sort_column] : "recent_percent"
    @sort_direction = params[:sort_direction] ? params[:sort_direction] : "DESC"

    q_front = "#{@q}%"
    cstring = "members.name LIKE ?"
    coptions = [q_front]

    if !admin?
      cstring << " AND members.rank != ? AND members.rank != ?"
      coptions << ['Departed', 'Inactive']
    end

    conditions = [cstring, coptions].flatten

    @members = Member.raid_attending(conditions, @sort_column, @sort_direction, @since.to_i)

    @members.delete_if {|member| member.recent_percent.to_f < 1.0}

    respond_to do |format|
      format.html {
      }
      format.js {
        render(:partial => "members/raid_attending_members.html.haml", :locals => {:members => @members})
      }
    end
  end

  # GET /members/1
  def show
    @member = Member.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /members/new
  def new
    @member = Member.new
    respond_to do |format|
      format.html
    end
  end

  # GET /members/1/edit
  def edit
    @member = Member.find(params[:id])
    @other_members = Member.all(:order => [:name])-[@member]
  end

  # POST /members
  def create
    @member = Member.new(params[:member])

    respond_to do |format|
      format.js do
        @member.save
        @raid = Raid.find(params[:member][:raid_id])
        members = Member.active
        @available_raiders = members - @raid.members.sort { |x,y| x.name <=> y.name }
      end

      format.html do
        if @member.save
          flash[:notice] = "Member was successfully created."
          redirect_to(:members)
        else
          flash[:error] = "Member failed to be created"
          render(:action => "new")
        end
      end
    end
  end

  def merge
    @member = Member.find(params[:id])
    other_id = params['member']['other_id']
    @member.merge(other_id)
    flash[:notice] = "Member has been merged."
    redirect_to(@member)
  end

  # PUT /members/1
  def update
    @member = Member.find(params[:id])
    respond_to do |format|
      if @member.update_attributes(params[:member])
        flash[:notice] = 'Members was successfully updated.'
        format.html { redirect_to(:members) }
      else
        format.html { render(:action => "edit") }
      end
    end
  end

  # DELETE /members/1
  def destroy
    @member = Member.find(params[:id])
    @member.destroy

    respond_to do |format|
      format.html { redirect_to(:members) }
    end
  end

  protected

    def find_members(conditions, sort_column, sort_direction, page)
      @members = Member.page(conditions, sort_column, sort_direction, page)
    end

    def check_cancel
      redirect_to(:members) and return if (params[:commit] == t('label.cancel'))
    end

end
