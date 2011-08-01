jQuery ->
    jQuery("a.send_kudo_link").live 'click', ->

        user_id = jQuery(this).attr("id")
        jQuery.get("/users/"+ user_id + "/first_identities/0")

button_pressed = false
jQuery(window).mousedown (event) ->
  button_pressed = true

jQuery(window).mouseup (event) ->
  button_pressed = false

jQuery.fn.businessCard = ->
  jQuery(this).hover ((event) ->


    return  if button_pressed == true

    id      = jQuery(this).attr("id")
    content = jQuery(".business_card_popup#business_card_"+ id).html()

    append = "<div class=\"business-card-window\" id=\"" + id + "\">" + content + "</div>"

    setTimeout(->
        jQuery("body").append(append)

        if jQuery(window).width() < event.clientX
          clientX = event.clientX - 30
        else
          clientX = event.clientX + 30

        if jQuery(window).height() < event.clientY
          clientY = event.pageY + 10
        else
          clientY = event.pageY - 10
    , 2000)

    jQuery(".business-card-window").css("top", clientY + "px").css("left", clientX + "px").fadeIn "fast"
  ), (e) ->
   # jQuery(".business-card-window").remove()

  jQuery(this).mousedown (event) ->
    jQuery(".business-card-window").remove()

  jQuery(this).mouseup (event) ->
    jQuery(".business-card-window").remove()

  jQuery(this).mousemove (event) ->
    if jQuery(window).width() < event.clientX
      clientX = event.clientX - 30
    else
      clientX = event.clientX + 30
    if jQuery(window).height() < event.clientY
      clientY = event.pageY + 10
    else
      clientY = event.pageY - 10
    jQuery(".business-card-window").css("top", clientY + "px").css "left", clientX + "px"

