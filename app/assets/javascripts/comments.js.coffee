jQuery ->
    jQuery("a.comment_form_toggle").live 'click', ->
        id = jQuery(this).attr('id');

        jQuery(".comments_form#comments_form_" + id).toggle()
        jQuery("p.message_container#container_" + id).html('')

        jQuery(".notice, .alert, .error").remove()

    jQuery("a.form_close").live 'click', ->
        id = jQuery(this).attr('id');

        jQuery(".comments_form#comments_form_" + id).hide();


@showCommentForm = (id)->

        jQuery(".comments_form#comments_form_" + id).toggle()
        jQuery("p.message_container#container_" + id).html('')
        jQuery(".notice, .alert, .error").remove()

    jQuery("a.form_close").live 'click', ->
        id = jQuery(this).attr('id');
        jQuery(".comments_form#comments_form_" + id).hide();
