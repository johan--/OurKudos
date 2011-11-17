$(document).ready ->
  $("#add_card").live "click", (event) ->
    if $("#add_card").is(":checked")
      $("#kudo_ecard_cont").slideDown(400)
      jQuery.ajax
        type: "GET"
        dataType: "html"
        url: "/cards"
        success: (data) ->
          $("#kudo_ecard_cont").html data
          $('.infiniteCarousel .wrapper ul').css({'width' : '9999px'})
          $('.infiniteCarousel .wrapper').css({'min-height' : '230px'})
          $('#pages p').show()
          $('.infiniteCarousel ul li').css({'height' : '85px'})
          $('.infiniteCarousel').infiniteCarousel()
    else
      $("#kudo_ecard_cont").slideUp(400)
      $("#kudo_attachment_id").val(null)

  $("#cards_img_slider .wrapper a").live "click", (event) ->
    attachment_id = $(this).attr("name")
    $("#kudo_attachment_id").val(attachment_id)
    $("#kudo_ecard_cont").slideUp(400)
    false
