//Make sure to address focus issue
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
          var matchable = handles[i][0].split(' ');
          matchable.push(handles[i][1]);
          for (var k=0; k<matchable.length; k++) {
            var matcher = "@" + matchable[k];
            if( matcher.toLowerCase().indexOf(text.toLowerCase()) == 0 ) {
              words.push(handles[i]);
              break;
            }
          }
        }
        cb(words);								
      }
    }
  });
});

