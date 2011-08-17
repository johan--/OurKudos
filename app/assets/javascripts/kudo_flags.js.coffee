jQuery ->
    jQuery("div.kudo_flag_cont.kf_dimmed.clickable").live 'click', ->
        data_id     = jQuery(this).attr('data-id')

        jQuery(this).removeClass("clickable") #to prevent multiple requests
        jQuery.get("/kudos/" + data_id + "/kudo_flags/new.js")
        

    jQuery('cancel-kudo-flag').click ->
        jQuery("div.popup_placeholder").dialog('close')

    jQuery('div.popup_placeholder').bind 'dialogclose', ->
        kudo_id = jQuery(this).data('kudo_id')
        jQuery('div.kudo_flag_cont.kf_dimmed[data-id='+kudo_id+']').addClass('clickable')
        

    jQuery('#new_action').click ->
        flagged_kudo = jQuery(this).data('id')
        action = jQuery('#action_select_' + flagged_kudo).val()
        user_id = jQuery(this).data('user_id')
        alert('flagged kudo ' + action)
        alert('action ' + action)
        alert('user ' + user_id)
        return false
