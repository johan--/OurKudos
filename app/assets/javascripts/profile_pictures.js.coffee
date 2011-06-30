jQuery ->
  user_id = jQuery("form#order_pictures_form #user_id").val()

  jQuery("ul.sortable").sortable 
    axis: "y"
    dropOnEmpty: false
    cursor: "hand"
    items: "li"
    opacity: 0.4
    scroll: true
    update: ->
      jQuery.ajax
        type: "get"
        data: jQuery("ul.sortable").sortable("serialize")
        dataType: "script"
        complete: (request) ->
          jQuery("ul.sortable").effect "highlight"
        
        url: "/users/" + user_id + "/profile_pictures/order.js?order=" + jQuery.map(jQuery("ul.sortable").children(), (element, item) -> jQuery(element).text()).join(",")