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
    id = ele.data("id")
    $.ajax({
        dataType: "json",
        url: "/tasks/"+id+"/update_task",
        method: 'patch',
        data: data,
        success: function(response) {
          if (response.success) {
            ele.parent().find("span.emptyList").remove();
            ele.attr("data-sequence", response.sequence);
            ele.attr("data-status", response.status);
          } else {
            alert("An error occurred, please try again.");
          }
        },
        error: function() {
          alert("An error occurred, please try again.");
        }
    });
  });

  $( "#due-list, #pending-list, #completed-list"  ).on( "sortremove", function( event, ui ) {
    if ($(this).children("li").length == 0) {
      $(this).find("h4").after("<span class='emptyList'>No tasks</span>")
    }
  })
  // $( "#completed-list" ).on( "sortupdate", function( event, ui ) {
  //   console.log("completed-list");
  //   var completed_list = {}
  //   $("ul#completed-list").children().each(function( index, element ){
  //     ele = $(element);
  //     ele.attr("data-status", "completed" );
  //     ele.attr("data-sequence", index);
  //     completed_list[ele.data("id")] = {"sequence": index}
  //   });
  //   console.log(completed_list);
  //   $.ajax({
  //       dataType: "json",
  //       url: "/tasks/update_tasks",
  //       method: 'patch',
  //       data: {
  //           list: completed_list,
  //           status: "completed"
  //       },
  //       error: function() {
  //         alert("An error occurred, please try again.");
  //       }
  //   });
  // });
  // $( "#pending-list" ).on( "sortupdate", function( event, ui ) {
  //   console.log("pending-list");
  //   var pending_list = {}
  //   $("ul#pending-list").children().each(function( index, element ){
  //     ele = $(element);
  //     ele.attr("data-status", "pending" );
  //     ele.attr("data-sequence", index);
  //     pending_list[ele.data("id")] = {"sequence": index}
  //   });
  //   console.log(pending_list);
  //   $.ajax({
  //       dataType: "json",
  //       url: "/tasks/update_tasks",
  //       method: 'patch',
  //       data: {
  //           list: pending_list,
  //           status: "pending"
  //       },
  //       error: function() {
  //         alert("An error occurred, please try again.");
  //       }
  //   });
  // });
})