button_pressed = false
jQuery(window).mousedown (event) ->
  button_pressed = true

jQuery(window).mouseup (event) ->
  button_pressed = false

jQuery.fn.business_card = ->
  jQuery(this).hover ((event) ->
    return  if button_pressed == true
    append = "<p id=\"business-card\">ASDFADFAF</p>"
    jQuery("body").append append

    if jQuery(window).width() < event.clientX + 390
      clientX = event.clientX - 360 - 30
    else
      clientX = event.clientX + 30

    if jQuery(window).height() < event.clientY + 370
      clientY = event.pageY - 360 + 10
    else
      clientY = event.pageY - 10

    jQuery("#business-card").css("top", clientY + "px").css("left", clientX + "px").fadeIn "fast"
  ), (e) ->
    jQuery("#business-card").remove()

  jQuery(this).mousedown (event) ->
    jQuery("#business-card").remove()

  jQuery(this).mouseup (event) ->
    jQuery("#business-card").remove()

  jQuery(this).mousemove (event) ->
    if jQuery(window).width() < event.clientX + 390
      clientX = event.clientX - 360 - 30
    else
      clientX = event.clientX + 30
    if jQuery(window).height() < event.clientY + 370
      clientY = event.pageY - 360 + 10
    else
      clientY = event.pageY - 10
    jQuery("#business-card").css("top", clientY + "px").css "left", clientX + "px"