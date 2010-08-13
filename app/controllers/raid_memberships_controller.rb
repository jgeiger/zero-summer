class RaidMembershipsController < ApplicationController

  def index
    redirect_to(:raids)
  end

  def create
    @raid_membership = RaidMembership.new(params[:raid_membership])

    respond_to do |format|
      format.js do
        @raid_membership.persist
        @raid_membership.reload
        @raiders = @raid_membership.raid.raid_memberships.reload.inject({'tank' => [], 'dps' => [], 'healer' => [], 'bank' => []}) do |hash, rm|
          hash[rm.member.role.downcase] << rm
          hash
        end

        @active_memberships = @raid_membership.reload.raid.active_memberships.size-1
        @total_memberships = @raid_membership.reload.raid.raid_memberships.size-1

        members = Member.active
        available_raiders = members - @raid_membership.raid.members.sort { |x,y| x.name <=> y.name }
        @available_raiders_options = available_raiders.inject("") {|s, r| s << "<option value='#{r.id}'>#{r.name}</option>"; s}
        @loot_members_options = @raid_membership.raid.raid_memberships.sort { |x,y| x.member.name <=> y.member.name }.inject("") {|s, rm| s << "<option value='#{rm.member.id}'>#{rm.member.name}</option>" if rm.active?; s}
      end

      format.html do
        if @raid_membership.persist
          flash[:notice] = "Raid Membership was successfully created"
          redirect_to(@raid_membership.raid)
        else
          flash[:error] = "Raid Membership failed to be created"
          redirect_to(@raid_membership.raid)
        end
      end
    end
  end

  def toggle_status
    @raid_membership = RaidMembership.find(params[:id])
    @raid_membership.toggle_status
    @raid_membership.reload
    respond_to do |format|
      format.js do
        active_memberships = @raid_membership.raid.active_memberships.size-1
        loot_members_options = @raid_membership.raid.raid_memberships.sort { |x,y| x.member.name <=> y.member.name }.inject("") {|s, rm| s << "<option value='#{rm.member.id}'>#{rm.member.name}</option>" if rm.active?; s}
        render(:json => {'active' => @raid_membership.active?, 'active_memberships' => active_memberships, 'loot_members_options' => loot_members_options})
      end
    end
  end

  def delete
    @raid_membership = RaidMembership.find(params[:id])
    @raid = @raid_membership.raid

    if @raid.loots.empty?
      @raid_membership.destroy
    end

    @raid.reload
    @active_memberships = @raid.active_memberships.size-1
    @total_memberships = @raid.raid_memberships.size-1

    @raiders = @raid.raid_memberships.reload.inject({'tank' => [], 'dps' => [], 'healer' => [], 'bank' => []}) do |hash, rm|
      hash[rm.member.role.downcase] << rm
      hash
    end

    members = Member.active
    @available_raiders = members - @raid.members.sort { |x,y| x.name <=> y.name }
    @available_raiders_options = @available_raiders.inject("") {|s, r| s << "<option value='#{r.id}'>#{r.name}</option>"; s}
    @loot_members_options = @raid_membership.raid.raid_memberships.sort { |x,y| x.member.name <=> y.member.name }.inject("") {|s, rm| s << "<option value='#{rm.member.id}'>#{rm.member.name}</option>" if rm.active?; s}

    respond_to do |format|
      format.js do
      end
    end
  end

end # RaidMemberships
