jQuery(document).ready ->
  $("#kudo_message_textarea").focusout (event) ->
    handles = []
    handles = @value.match(/[@]+[A-Za-z0-9-_]+/g)
    if handles.length > 0
      i = 0
      len = handles.length
      
      while i < len
        handle = handles[i].substring(1, handles[i].length)
        jQuery.ajax 
          type: "GET"
          dataType: "json"
          url: "/autocomplete/new?object=exact&q=%40" + handle
          success: (data) ->
            #need to parse for if no identity
            if data[0] == "no matches"
              $.Token.tokenInput "add", "@" + handle
            else
              $.Token.tokenInput "add", data[0]
        ++i
