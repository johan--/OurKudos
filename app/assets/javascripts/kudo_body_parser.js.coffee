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
          url: "/autocomplete/new?object=recipients&q=%40" + handle
          success: (data) ->
            $.Token.tokenInput "add", data[0]
        ++i
