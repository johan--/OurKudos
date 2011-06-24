$(document).ready(function(){
	// if there are Rails flash alerts or Devise form errors, capture the HTML and insert into interstitial message area
	
	if ($('#error_explanation').length) {
		$('#error_explanation').dialog({modal: true, resizable: false });
	}
	
	if ($('.alert').length) {
		$('.alert').dialog({modal: true, resizable: false });
	}

  // the okay button has been clicked
  $('p#interstitial_message_close_control').click(function(){
    // hide the overlay DOM object
  	$('div#overlay').hide();
  	$('div#overlay_overlay').hide();
  });
	
	
	
	
	// the video tour button clicked (move this to a separate file at some point)
  $('a.video_tour_link').click(function(){
  	$('body').append('<div id="kudos_video"></div>');
  	$('#kudos_video').html('<iframe width="425" height="349" src="http://www.youtube.com/embed/ahHZFck-2ys?rel=0" frameborder="0" allowfullscreen></iframe>').dialog({modal: true, width: 447, resizable: false });
  	
  	$('a.ui-dialog-titlebar-close').click(function(){
			
			$('div#kudos_video').remove();
		});
  	
  	
  	return false;
  });
  
 
	

}); // document.ready