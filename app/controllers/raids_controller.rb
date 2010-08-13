class RaidsController < ApplicationController

  before_filter :admin_required, :except => [:index, :show]
  before_filter :check_cancel, :only => [:create, :update]

  # GET /raids
  def index
    @q = params[:query]
    @page = (params[:page].to_i > 0) ? params[:page] : 1

    q_front = "#{@q}%"
    cstring = "DATE_FORMAT(event_date, '%m/%d/%Y') LIKE ?"

    conditions = [cstring, q_front]
    find_raids(conditions, @page)
    #if we have a page > the last one, redo the query turning the page into the last one
    find_raids(conditions, @raids.total_pages) if params[:page].to_i > @raids.total_pages

    respond_to do |format|
      format.html {
      }
      format.js {
        render(:partial => "raids/raids.html.haml", :locals => {:raids => @raids})
      }
    end
  end

  def show
    @raid = Raid.find(params[:id])
    @member = Member.new
    members = Member.active
    @available_raiders = members - @raid.members.sort { |x,y| x.name <=> y.name }
    @raid_membership = RaidMembership.new

    @active_memberships = @raid.active_memberships.size-1
    @total_memberships = @raid.raid_memberships.size-1

    @raiders = @raid.raid_memberships.inject({'tank' => [], 'dps' => [], 'healer' => [], 'bank' => []}) do |hash, rm|
      hash[rm.member.role.downcase] << rm
      hash
    end

    @raid_members = @raid.raid_memberships.sort { |x,y| x.member.name <=> y.member.name }.inject([]) {|a, rm| a << rm.member if rm.active?; a}

    @dungeons = Dungeon.all
    difficulty = @dungeons.first.encounters.first.difficulty
    boss_id = @dungeons.first.encounters.first.boss_id
    @difficulties, @bosses, @drops = Loot.get_data(@dungeons.first.id, difficulty, boss_id)
    @loot = Loot.new(:drop => @drops.first)

    respond_to do |format|
      format.html # index.html.haml
    end
  end

  def new
    @raid = Raid.new(:event_date => Date.today.to_s(:us))

    respond_to do |format|
      format.html # index.html.haml
    end
  end

  def edit
    @raid = Raid.find(params[:id])

    respond_to do |format|
      format.html # index.html.haml
    end
  end

  def create
    @raid = Raid.new(params[:raid])

    respond_to do |format|
      format.html do
        if @raid.save
          @raid.persist
          flash[:notice] = "Raid was successfully created."
          redirect_to(@raid)
        else
          flash[:error] = "Raid failed to be created"
          render(:action => "new")
        end
      end
    end
  end

  def import
    url = params['url']
    if /combat\/\d+$/.match(url)
      Raid.build(url)
      flash[:notice] = "Raid has been imported from #{url}"
      redirect_to(:raids)
    else
      @raid = Raid.new(:event_date => Date.today.to_s(:us))
      flash[:error] = "The provided URL is invalid."
      render :new
    end
  end

  def activate
    @raids = Raid.all
    @raid = Raid.find(params[:id])
    @raid.activate
    redirect_to(:raids)
  end

  # PUT /raids/1
  def update
    @raid = Raid.find(params[:id])

    respond_to do |format|
      if @raid.update_attributes(params[:raid])
        flash[:notice] = 'Raid was successfully updated.'
        format.html { redirect_to(:raids) }
      else
        format.html { render(:action => "edit") }
      end
    end
  end

  # DELETE /raids/1
  def destroy
    @raid = Raid.find(params[:id])
    @raid.destroy

    respond_to do |format|
      format.html { redirect_to(:raids) }
    end
  end

  protected

    def find_raids(conditions, page)
      @raids = Raid.page(conditions, page)
    end

    def check_cancel
      redirect_to(:raids) and return if (params[:commit] == t('label.cancel'))
    end

end # Raids
