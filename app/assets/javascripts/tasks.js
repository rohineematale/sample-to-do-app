// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready(function(){
  $( "#due-list, #pending-list, #completed-list" ).sortable({
    connectWith: ".connectedSortable",
    revert: true
  });

  $( "#due-list" ).sortable({
    connectWith: "#completed-list"
  });

  $( "#due-list, #pending-list, #completed-list"  ).on( "sortstop", function( event, ui ) {
    ele = ui.item
    data = {}
    prev_status = ele.data("status")
    new_status = ele.parent().data("type")
    if (prev_status != new_status) {
      data['status'] = new_status
    }
    data['prev_sequence'] = ele.prev().data("sequence")
    data['next_sequence'] = ele.next().data("sequence")
    url = "/tasks/"+ele.data("id")+"/update_task"
    send_update_tasks(ele, url, data)
  });

  $( "#due-list, #pending-list, #completed-list"  ).on( "sortremove", function( event, ui ) {
    if ($(this).children("li").length == 0) {
      $(this).find("h5").after("<span class='emptyList'>No tasks</span>")
    }
  })
})

function send_update_tasks(ele, url, data) {
  $.ajax({
    dataType: "json",
    url: url,
    method: 'patch',
    data: data,
    success: function(response) {
      ajax_response_handler(response, ele)
    },
    error: function() {
      alert("An error occurred, please try again.");
    }
  });
}

function ajax_response_handler(response, ele) {
  if (response.success) {
    ele.parent().find("span.emptyList").remove();
    ele.find("small.due_date").html(response.due_date);
    ele.attr("data-sequence", response.sequence);
    ele.attr("data-status", response.status);
  } else {
    alert("An error occurred, please try again.");
  }
}