jQuery ->
  jQuery('#merge-account-autocomplete').autocomplete
    source: '/autocomplete/new?object=identities'

  jQuery("a.send_kudo_link").click ->

    user_id = jQuery(this).attr("id")
    jQuery.get("/users/"+ user_id + "/first_identities/0")