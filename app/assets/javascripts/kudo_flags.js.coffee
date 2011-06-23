jQuery ->
    data_id     = jQuery(this).attr('data-id')
    jQuery("div.kudo_flag_cont.kf_dimmed.clickable").click ->

        data_id     = jQuery(this).attr('data-id')
       if confirm "Are you sure you want to flag this kudo?"

            data_helper = jQuery(this).attr('data-helper')

            jQuery(this).removeClass("clickable") #to prevent multiple requests

            jQuery.get("/kudos/" + data_id + "/kudo_flags/new.js?helper=" + data_helper)
        else
            jQuery(this).addClass("clickable")

