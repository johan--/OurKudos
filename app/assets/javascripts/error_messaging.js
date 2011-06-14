$(document).ready(function(){
	// if there are Rails flash alerts or Devise form errors, capture the HTML and insert into interstitial message area
	
	if ($('#error_explanation').length) {
		var error_contents = $('#error_explanation').html();
		$('div.interstitial_message').html(error_contents);
	
		$('div#overlay').css('display','block');
	}
	
	if ($('.alert').length) {
		var error_contents = $('.alert').html();
		$('div.interstitial_message').html(error_contents);
	
		$('div#overlay').css('display','block');

	}

  // the okay button has been clicked
  $('p#interstitial_message_close_control').click(function(){
    // hide the overlay DOM object
  	$('div#overlay').hide();
  });
	
	  // the video tour button clicked
  $('a#video_tour_link').click(function(){
  	$('div#overlay').css('display','block');
  	$('div.interstitial_message').html('<iframe width="425" height="349" src="http://www.youtube.com/embed/ahHZFck-2ys?rel=0" frameborder="0" allowfullscreen></iframe>');
  	return false;
  });
	

}); // document.ready