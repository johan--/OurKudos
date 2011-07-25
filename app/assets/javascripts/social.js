
jQuery(document).ready(function(){
 ////////////////////// 
  $("#social_buttons a").click(function(event) {
    var base_url = "www.rkudos.com/kudos/"
    var kudo_id = $(this).attr('name');

    $(this).empty();
    //////START GOOGLE//////
    gapi.plusone.render(this, {"size" : "medium"," count" : "false", "href" : base_url + kudo_id});
    //////END GOOGLE//////
    $('html').attr("xmlns:og","http://www.facebook.com/2008/fbml").attr("xmlns:fb","http://www.facebook.com/2008/fbml");

    // Remove previously created FB like elements -- if they exist -- so they can be re-added after AJAX pagination
    $('.fb-like').remove();
    $('#fb-root').empty();

    // Build and inject Like button
      var fb_url = base_url + kudo_id,
      fb_like = '<div class="fb_like"><fb:like href="'+fb_url+'" layout="standard" show_faces="false" action="like" colorscheme="light"></fb:like></div>';
      
      $(this).append(fb_like);
      

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
    //////////////////////////////////
    return false
  });

});
