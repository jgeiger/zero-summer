// Common JavaScript code across your application goes here.

$.postJSON = function(url, data, callback) {
	$.post(url, data, callback, "json");
};

// function to send the jQuery form object via AJAX
jQuery.fn.submitWithAjax = function() {
  this.submit(function() {
    // be sure to add the '.js' part so that it knows this is format:js
    $.post(this.action + '.js', $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

function filter_submit() {
  var m = {};
  m._method = "get";
  if ($("#query").length > 0) {
    m.query = $("#query").val();
  }

  if ($("#page").length > 0) {
    m.page = $("#page").val();
  }

  if ($("#since").length > 0) {
    m.since = $("#since").val();
  }

  if ($("#sort_column").length > 0) {
    m.sort_column = $("#sort_column").val();
  }

  if ($("#sort_direction").length > 0) {
    m.sort_direction = $("#sort_direction").val();
  }

  $("#dataTable").load(window.location.pathname+ '.js', m);
  return false;
}

$(function() {

  $('#loading').ajaxStart(function() {
    $(this).show();
  });

  $('#loading').ajaxStop(function() {
    $(this).hide();
  });

  // dynamically load the items based on query filter
  $("#query").bind("keyup", filter_submit);
  $("#since").bind("change", filter_submit);

  $(".pagination a").live("click", function(){
    $.get($(this).attr('href'), {}, function(data){
      $("#dataTable").html(data);
    }, 'script');
    return false;
  });

  $(".sort-link").live("click", function(){
    $("#sort_column").val($(this).attr('sort_column'));
    $("#sort_direction").val($(this).attr('sort_direction'));
    $("#page").val(1);
    filter_submit();
    return false;
  });

  $("tr td a.delete-link").live("click", function(){
    if (confirm('Are you sure?')) {
      var link_row = $(this).parents('tr:eq(0)');
      $.postJSON($(this).attr('href'), {'_method':'delete'}, function(result){
        if (result['status'] == "success") {
          link_row.fadeOut();
        } else {
          alert('Unable to delete!');
        }
      });
    }
    return false;
  });


  $(".datepicker").datepicker();

  $(".toggle-membership").live("click", function(){
    membership = $(this);
    var raid_membership_id = membership.attr('raid_membership_id');

    $.postJSON("/raid_memberships/"+raid_membership_id+"/toggle_status", {}, function(data){
      $('#loot_member_id').find('option').remove();
      $('#loot_member_id').append(data['loot_members_options']);
      $(".active-memberships").text(data['active_memberships']);
      if (data['active']) {
        membership.removeClass("inactive");
      } else {
        membership.addClass("inactive");
      }
    });
    return false;
  });

  $(".delete-membership").live("click", function(){
    var raid_membership_id = $(this).attr('raid_membership_id');
    $.post("/raid_memberships/"+raid_membership_id+"/delete", {}, null, "script");
    return false;
  });

  $('.confirm').click(function() {
    var answer = confirm('Are you sure?');
    return answer;
  });

  $(".available-raider").live("click", function(){
    var member_id = $(this).attr('member_id');
    var raid_id = $(this).attr('raid_id');
    $(this).remove();
    $.post("/raid_memberships", { 'raid_membership[member_id]': member_id, 'raid_membership[raid_id]' : raid_id }, null, "script");
    return false;
  });

  $('.loot-row .confirm').click(function() {
    row = $(this).parent().parent(".loot-row")
	  id = row.attr('loot_id');
    $.post("/loots/"+id+"/destroy", function(data){
      row.fadeOut();
      return false;
    })
  });

	$(".toggle").click(function(){
	  id = $(this).attr('toggle_id');
    $(this).hide();
    $(id).show();
	})

  $("#loot-form select#loot_dungeon_id").change(function(){
    $.postJSON("/loots/updated_dungeon", {'dungeon_id':$(this).val()}, function(j){
      var options = '';
      for (var i = 0; i < j.length; i++) {
        options += '<option value="' + j[i].optionValue + '">' + j[i].optionDisplay + '</option>';
      }
      $("#loot-form select#loot_difficulty").html(options);
      $("#loot-form select#loot_difficulty").change();
    })
  })

  $("#loot-form select#loot_difficulty").change(function(){
    $.postJSON("/loots/updated_difficulty", {'dungeon_id':$("#loot-form select#loot_dungeon_id").val(), 'difficulty':$(this).val()}, function(j){
      var options = '';
      for (var i = 0; i < j.length; i++) {
        options += '<option value="' + j[i].optionValue + '">' + j[i].optionDisplay + '</option>';
      }
      $("#loot-form select#loot_boss_id").html(options);
      $("#loot-form select#loot_boss_id").change();
    })
  })

  $("#loot-form select#loot_boss_id").change(function(){
    $.postJSON("/loots/updated_boss", {'dungeon_id':$("#loot-form select#loot_dungeon_id").val(), 'difficulty':$("#loot-form select#loot_difficulty").val(), 'boss_id':$(this).val()}, function(j){
      var options = '';
      for (var i = 0; i < j.length; i++) {
        options += '<option value="' + j[i].optionValue + '">' + j[i].optionDisplay + '</option>';
      }
      $("#loot-form select#loot_drop_id").html(options);
    })
  })

  $("#remote-raider").submit(function(){
    $.post("/members", $(this).serialize(), null, "script")
    return false;
  })

  $("#loots #loot-form").submit(function(){
    $.post(this.action, $(this).serialize(), function(data){
      $("#loot-list").html(data);
      loot_datatable();
      }, "script");
    return false;
  })

  $("#new_raid_membership").submit(function(){
    $.post(this.action, $(this).serialize(), null, "script");
    return false;
  })

  $("#new_absence").submit(function(){
    $.post(this.action, $(this).serialize(), null, "script");
    return false;
  })

  // once the page has completely loaded, make forms with the class "remote" submit via AJAX
  $("form.remote").submitWithAjax();

	$('#adjustment-table').dataTable({
    "bPaginate": false,
    "sDom": '<"top"f>t<"clear">',
		"aaSorting": [[ 1, "desc" ]],
		"aoColumns": [
      null,
      { "sType": "html" },
      { "sType": "date" },
      { "sType": "html" },
      { "sType": "html" },
      { "sType": "numeric" }
		]});

	$('#boss-table').dataTable({
    "bPaginate": false,
    "sDom": '<"top"f>t<"clear">',
		"aaSorting": [[ 0, "asc" ]],
		"aoColumns": [
      { "sType": "html" }
		]});

	$('#encounter-table').dataTable({
    "bPaginate": false,
    "sDom": '<"top"f>t<"clear">',
		"aaSorting": [[ 0, "asc" ]],
		"aoColumns": [
      { "sType": "html" },
      { "sType": "html" }
		]});

});

