// jquery.observe_field.js


(function( $ ){

  jQuery.fn.observe_field = function(frequency, callback) {

    frequency = frequency * 1000; // translate to milliseconds

    return this.each(function(){
      var $this = $(this);
      var prev = $this.val();

      var check = function() {
        var val = $this.val();
        if(prev != val){
          prev = val;
          $this.map(callback); // invokes the callback on $this
        }
      };

      var reset = function() {
        if(ti){
          clearInterval(ti);
          ti = setInterval(check, frequency);
        }
      };

      check();
      var ti = setInterval(check, frequency); // invoke check periodically

      // reset counter after user interaction
      $this.bind('keyup click mousemove', reset); //mousemove is for selects
    });

  };

})( jQuery );

function ltrim(s)
{
	var l=0;
	while(l < s.length && s[l] == ' ')
	{	l++; }
	return s.substring(l, s.length);
}


jQuery(document).ready(function(){
  // Executes a callback detecting changes with a frequency of 1 second

  //$("#kudo_message_textarea").observe_field(2, function( ) {
  $("#kudo_message_textarea").focusout(function(event) {
    var handles = []
    handles = this.value.match(/[@]+[A-Za-z0-9-_]+/g)
    if (handles.length > 0 ) {
      for ( var i=0, len=handles.length; i<len; ++i) {
        handle = handles[i].substring(1, handles[i].length)
        jQuery.ajax({
            type: 'GET',
            dataType: 'json',
            url: "/autocomplete/new?object=recipients&q=%40" + handle, 
            success: function(data){
              $.Token.tokenInput("add", data[0]);
            } 
        });

      }
    
    }
  });
});
