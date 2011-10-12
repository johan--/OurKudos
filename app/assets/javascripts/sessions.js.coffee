jQuery ->
  jQuery("input#user_email").blur ->
    email = jQuery("input#user_email").val()
    if (email.length > 0) and (email.match(/^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/))
      /* the user entered a properly formatted email address */
      email = encodeURIComponent(email)
      jQuery.get "/users/password/new.js?email=" + email
      
      /* try to find the user's authentications email */
      jQuery.get "/authentications/find_from_email?email=" + email, (found_authentications) ->
        if found_authentications then jQuery("span#email_warning_message").html(found_authentications)
        else jQuery("span#email_warning_message").empty()
      
    else if (email.length > 0) and (!email.match(/^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/))
      /* the user entered an improperly formatted email address, warn them */
      jQuery("span#email_warning_message").html("You did not enter a properly formatted email address.")
 
    