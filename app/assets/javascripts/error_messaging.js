$(document).ready(function(){
	// if there are Rails flash alerts or Devise form errors, capture the HTML and insert into interstitial message area
	
	if ($('#error_explanation').length) {
		$('#error_explanation').dialog({width: 446, modal: true, resizable: false, title: 'Action Required:', draggable: false, buttons: [{ text: "Okay", click: function(){$(this).dialog("close");} } ] });
		$('.ui-dialog').prepend('<div id="dialog-kudos-character" class="stopcop"></div>');
		$('.ui-dialog-content').prepend('<div class="flow-around-object"></div>');
		// we style the button this way because doing it as a button config option breaks in IE8
		$('button.ui-button').addClass('action_button');
	}
	
	if ($('.alert').length) {
		$('.alert').dialog({width: 446, modal: true, resizable: false, title: 'Alert:', draggable: false, buttons: [{ text: "Okay", click: function(){$(this).dialog("close");} } ]});
		$('.ui-dialog').prepend('<div id="dialog-kudos-character" class="stopcop"></div>');
		$('.ui-dialog-content').prepend('<div class="flow-around-object"></div>');
		$('button.ui-button').addClass('action_button');
	}

	
	// the video tour button clicked (move this to a separate file at some point)
  $('a.video_tour_link').click(function(){
  	$('body').append('<div id="kudos_video"></div>');
  	$('#kudos_video').html('<iframe width="425" height="349" src="http://www.youtube.com/embed/ahHZFck-2ys?rel=0" frameborder="0" allowfullscreen></iframe>').dialog({modal: true, width: 446, resizable: false, buttons: [{ text: "Exit", click: function(){$(this).dialog("close"); $('div#kudos_video').remove(); } } ]  });
  	
  	$('button.ui-button').addClass('action_button');
  	
  	/* fix some styling rules that really apply to error messages */
  	
  	$('.ui-widget-header').css('display','none');
  	
  	
  	return false;
  });
  

        
	

}); // document.ready