
jQuery(document).ready(function(){
 ////////////////////// 
  $(".kudo_message_cont").live('mouseover mouseout', function(event) {
    ////
    if (event.type == "mouseover") {
    var kudo_scope = $(".kudo_message_mid", this).data('scope');
    if (kudo_scope == undefined) {
      var base_url = "http://www.rkudos.com/kudos/"
      kudo_id = $(".kudo_message_mid", this).data('id');

      var google_div = "google_plus_" + kudo_id
      if ($("#" + google_div).is(':empty')) {
        $(google_div).empty();
        //////START GOOGLE//////
        gapi.plusone.render(google_div, {"size" : "small", "count" : "false", "href" : base_url + kudo_id});
        //////END GOOGLE//////
        $('html').attr("xmlns:og","http://www.facebook.com/2008/fbml").attr("xmlns:fb","http://www.facebook.com/2008/fbml");

        // Remove previously created FB like elements -- if they exist -- so they can be re-added after AJAX pagination
        $('.fb-like').remove();
        $('#fb-root').empty();

        // Build and inject Like button
          var fb_url = base_url + kudo_id,
          fb_like = '<div class="fb_like"><fb:like href="'+fb_url+'" layout="button_count" show_faces="false" action="like" colorscheme="light"></fb:like></div>';
          
          $("#facebook_like_" + kudo_id).html(fb_like);
          

        // Load in FB javascript SDK
        $('body').append('<div id="fb-root"></div>');
          window.fbAsyncInit = function() {
          FB.init({appId: '152607901444320', status: true, cookie: true, xfbml: true});
        };
        (function() {
          var e = document.createElement('script'); e.async = true;
          e.src = document.location.protocol + '//connect.facebook.net/en_US/all.js';
          document.getElementById('fb-root').appendChild(e);
        }());
       //$(this).hide(); 

      } else {
        $(".plusone_button", this).show(); 
        $(".facebook_like", this).show(); 
      }
    }  
      //////////////////////////////////
    } else { 
      $(".plusone_button", this).hide(); 
      $(".facebook_like", this).hide(); 
    }
    });
});
