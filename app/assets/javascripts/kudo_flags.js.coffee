jQuery ->
    jQuery("div.kudo_flag_cont.kf_dimmed.clickable").click ->
        data_id     = jQuery(this).attr('data-id')

        jQuery(this).removeClass("clickable") #to prevent multiple requests
        jQuery.get("/kudos/" + data_id + "/kudo_flags/new.js")