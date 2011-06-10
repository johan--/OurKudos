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
	

}); // document.ready