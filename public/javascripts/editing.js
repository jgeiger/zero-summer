$(document).ready(function() {

  $('#member-table tbody td.rank').editable(function(value, settings) { 
      member_id = $(this).parent().attr('member');
      $.post("/members/"+member_id, { 'member[rank]': value, '_method': 'put'} );
      return(value);
   }, { 
    data   : "{'Officer':'Officer','Vanguard':'Vanguard','Elite':'Elite','Reserve':'Reserve','Applicant':'Applicant','Inactive':'Inactive','Departed':'Departed'}",
    type   : 'select',
    submit : 'OK'
  });

  $('#member-table tbody td.role').editable(function(value, settings) { 
      member_id = $(this).parent().attr('member');
      $.post("/members/"+member_id, { 'member[role]': value, '_method': 'put'} );
      return(value);
    }, { 
    data   : "{'DPS':'DPS','Tank':'Tank','Healer':'Healer'}",
    type   : 'select',
    submit : 'OK'
  });

});

