# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  FLASH_NOTICE_KEYS = [:success, :notice, :warning, :failure, :invalid]

  def admin_only(&block)
    if !current_user.blank? && current_user.admin?
      block.call
    end
  end

  def login_logout
    if user_signed_in?
      link_to(t('link.dashboard'), user_url(current_user))+" - "+link_to(t('link.sign-out'), destroy_user_session_url, :confirm => t('confirm.areyousure'))
    else
      link_to(t('link.sign-in'), new_user_session_url)+" - "+link_to(t('link.sign-up'), new_user_url)
    end
  end

  def flash_messages
    return unless messages = flash.keys.select{|k| FLASH_NOTICE_KEYS.include?(k)}
    formatted_messages = messages.map do |type|
      content_tag :div, :class => type.to_s do
        message_for_item(flash[type], flash["#{type}_item".to_sym])
      end
    end
    flash.clear
    formatted_messages.join
  end

  def render_errors(item, header=false)
    unless header
      render(:partial => 'shared/form_errors', :locals => { :record => item }) if item
    else
      render(:partial => 'shared/form_error_header', :locals => { :record => item }) if item
    end
  end

  def message_for_item(message, item = nil)
    if item.is_a?(Array)
      message % link_to(*item)
    else
      message % item
    end
  end

  # Only need this helper once, it will provide an interface to convert a block into a partial.
    # 1. Capture is a Rails helper which will 'capture' the output of a block into a variable
    # 2. Merge the 'body' variable into our options hash
    # 3. Render the partial with the given options hash. Just like calling the partial directly.
  def block_to_partial(partial_name, options = {}, &block)
    options.merge!(:body => capture(&block))
    concat(render(:partial => partial_name, :locals => options))
  end

  # Create as many of these as you like, each should call a different partial
    # 1. Render 'shared/rounded_box' partial with the given options and block content
  def rounded_box(css_class, options = {}, &block)
    block_to_partial('shared/rounded_box', options.merge(:css_class => css_class), &block)
  end

  def page_title(title)
    "<div class='page-title'>#{title}</div>"
  end

  def item_link(item)
    if admin?
      link_to(item.name, item_url(item), :rel => "item=#{item.id}", :class => "item qc-#{Item::QUALITY[item.quality]}")
    else
      link_to(item.name, "#", :rel => "item=#{item.id}", :class => "item qc-#{Item::QUALITY[item.quality]}")
    end
  end

  def drop_link(drop)
    if admin?
      link_to(drop.fullname, admin? ? drop_url(drop) : "#", :rel => "item=#{drop.item.id}", :class => "item qc-#{Item::QUALITY[drop.item.quality]}")
    else
      "<span rel='item=#{drop.item.id}' class='item qc-#{Item::QUALITY[drop.item.quality]}'>"+drop.fullname+"</span>"
    end
  end

  def boss_link(boss)
    if admin?
      link_to(boss.name, admin? ? boss_url(boss) : "#", :rel => "npc=#{boss.id}")
    else
      "<span rel='npc=#{boss.id}'>"+boss.name+"</span>"
    end
  end

  def encounter_link(encounter)
    if admin?
      link_to(encounter.name, encounter_url(encounter))
    else
      encounter.name
    end
  end

  def dungeon_link(encounter)
    if admin?
      link_to(encounter.dungeonname, dungeon_url(encounter.dungeon))
    else
      encounter.dungeonname
    end
  end

  def toggle_membership(membership)
    return if membership.member_id == 0 # can't deactivate the bank
    return if !membership.raid.active? # can't deactivate if not active raid
    return if !admin?
    membership.raid_has_loot? ? "toggle-membership" : "delete-membership"
  end

  def sort_links(klass, column, controller_action=nil)
    up_arrow = "icons/blue_arrow_up.png"
    down_arrow = "icons/blue_arrow_down.png"
    if @sort_column == column
      if @sort_direction == "ASC"
        up_arrow = "icons/green_arrow_up.png"
      else
        down_arrow = "icons/green_arrow_down.png"
      end
    end

    link = klass.name.tableize

    if controller_action
      link = controller_action + "_" + link
    end

    link_to(image_tag(up_arrow, :title => "asc"), eval("#{link}_url(:sort_column => column, :sort_direction => 'ASC')"), :class => "sort-link", :sort_column => "#{column}", :sort_direction => 'ASC' )+" "+
    link_to(image_tag(down_arrow, :title => "desc"), eval("#{link}_url(:sort_column => column, :sort_direction => 'DESC')"), :class => "sort-link", :sort_column => "#{column}", :sort_direction => 'DESC')
  end

end
