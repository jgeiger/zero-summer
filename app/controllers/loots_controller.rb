class LootsController < ApplicationController

  before_filter :admin_required, :except => [:index, :show]
  before_filter :check_cancel, :only => [:create, :update]

  # GET /items
  def index
    @q = params[:query]
    @page = (params[:page].to_i > 0) ? params[:page] : 1
    @sort_column = params[:sort_column] ? params[:sort_column] : "raids.event_date"
    @sort_direction = params[:sort_direction] ? params[:sort_direction] : "DESC"

    q_front = "#{@q}%"
    cstring = "items.name LIKE ? OR members.name LIKE ?"
    coptions = [q_front, q_front]

    conditions = [cstring, coptions].flatten
    find_loots(conditions, @sort_column, @sort_direction, @page)
    #if we have a page > the last one, redo the query turning the page into the last one
    find_loots(conditions, @sort_column, @sort_direction, @loots.total_pages) if params[:page].to_i > @loots.total_pages

    respond_to do |format|
      format.html {
      }
      format.js {
        render(:partial => "loots.html.haml", :locals => {:loots => @loots, :skip_paginate => false})
      }
    end
  end

  def show
    @loot = Loot.find(params[:id])

    respond_to do |format|
      format.html # index.html.haml
    end
  end

  def new
    @raid = Raid.first(:conditions => {:active => true})
    if !@raid
      flash[:warning] = "Cannot create loot since there is no active raid!"
      redirect_to(:loots) and return false
    end

    @dungeons = Dungeon.all
    difficulty = @dungeons.first.encounters.first.difficulty
    boss_id = @dungeons.first.encounters.first.boss_id

    @difficulties, @bosses, @drops = Loot.get_data(@dungeons.first.id, difficulty, boss_id)

    @loot = Loot.new(:drop => @drops.first)

    respond_to do |format|
      format.html # index.html.haml
    end
  end

  def edit
    @loot = Loot.find(params[:id])

    @raid = @loot.raid

    @raid_members = @raid.raid_memberships.sort { |x,y| x.member.name <=> y.member.name }.inject([]) {|a, rm| a << rm.member if rm.active?; a}

    @dungeons = Dungeon.all
    dungeon_id = @loot.drop.encounter.dungeon_id
    difficulty = @loot.drop.encounter.difficulty
    boss_id = @loot.drop.encounter.boss_id
    @difficulties, @bosses, @drops = Loot.get_data(dungeon_id, difficulty, boss_id)

    respond_to do |format|
      format.html # index.html.haml
    end
  end

  # POST /loots
  def create
    @loot = Loot.new(params[:loot])

    respond_to do |format|
      format.js do
        @loot.persist
        @loots = @loot.raid.reload.loots
        render(:partial => "raids/loots.html.haml", :locals => {:loots => @loots})
      end

      format.html do
        if @loot.persist
          flash[:notice] = "Loot was successfully created."
          redirect_to(@loot.raid)
        else
          message[:error] = "Loot failed to be created"
          render :new
        end
      end
    end
  end

  # PUT /loots/1
  def update
    @loot = Loot.find(params[:id])
    respond_to do |format|
      if @loot.update_attributes(params[:loot])
        flash[:notice] = 'Loot was successfully updated.'
        format.html { redirect_to(:loots) }
      else
        @drops = Drop.all
        @raid = @loot.raid
        @items = @drops.inject([]) do |a, drop|
          a << drop.item
          a
        end
        format.html { render(:action => "edit") }
      end
    end
  end

  # DELETE /loots/1
  def destroy
    @loot = Loot.find(params[:id])

    respond_to do |format|
      format.js do
        if @loot.destroy
          render(:json => {'status' => 'success'})
        else
          render(:json => {'status' => 'failure'})
        end
      end

      format.html do
        @loot.destroy
        redirect_to(:loots)
      end
    end
  end

  def updated_dungeon
    dungeon = Dungeon.find(params[:dungeon_id])
    encounters = dungeon.encounters
    difficulties = encounters.map(&:difficulty).uniq
    difficulties = difficulties.inject([]) do |a, t|
      a << {:optionDisplay => t, :optionValue => t}
    end

    render(:json => difficulties)
  end

  def updated_difficulty
    dungeon = Dungeon.find(params[:dungeon_id])
    difficulty = params[:difficulty]
    encounters = dungeon.encounters.select {|e| e.difficulty == difficulty }
    boss_id = encounters.first.boss_id
    difficulties, bosses, drops = Loot.get_data(dungeon.id, difficulty, boss_id)
    bosses = bosses.map do |boss|
      {:optionDisplay => boss.name, :optionValue => boss.id}
    end

    render(:json => bosses)
  end

  def updated_boss
    dungeon_id = params[:dungeon_id]
    difficulty = params[:difficulty]
    boss_id = params[:boss_id].to_i
    difficulties, bosses, drops = Loot.get_data(dungeon_id, difficulty, boss_id)
    drops = drops.map do |drop|
      {:optionDisplay => drop.item.name, :optionValue => drop.id}
    end

    render(:json => drops)
  end

  protected

    def find_loots(conditions, sort_column, sort_direction, page)
      @loots = Loot.page(conditions, sort_column, sort_direction, page)
    end

    def check_cancel
      redirect_to(:loots) and return if (params[:commit] == t('label.cancel'))
    end

end # Loots
