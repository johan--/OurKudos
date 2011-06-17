jQuery ->
  jQuery("input#user_email").blur ->
    email = jQuery("input#user_email").val()
    if (email.length > 0) and (email.match(/^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/))
      email = encodeURIComponent(email)
      jQuery.get "/users/password/new.js?email=" + email