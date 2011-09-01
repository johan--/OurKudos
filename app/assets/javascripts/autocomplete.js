jQuery(document).ready(function(){
  var handles;
  jQuery.ajax({
    url: '/autocompletes/inline_autocomplete_identities',
    async: false,
    dataType: 'json',
    success: function(data){
      handles = data;
    }
  });

  $("#kudo_message_textarea").autocomplete({
    wordCount:1,
    mode: "inner",
    on: {
      query: function(text,cb){
        var words = [];
        for( var i=0; i<handles.length; i++ ){
          if( handles[i].toLowerCase().indexOf(text.toLowerCase()) == 0 ) words.push(handles[i]);
        }
        cb(words);								
      }
    }
  });
});

