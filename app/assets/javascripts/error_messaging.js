$(document).ready(function(){
	// if there are Rails flash alerts or Devise form errors, capture the HTML and insert into interstitial message area
	
	if ($('#error_explanation').length) {
		$('#error_explanation').dialog({width: 446, modal: true, resizable: false, title: 'Action Required:', draggable: false, buttons: [{ text: "Okay", click: function(){$(this).dialog("close");}, class: 'action_button' } ] });
		$('.ui-dialog').prepend('<div id="dialog-kudos-character" class="stopcop"></div>');
		$('.ui-dialog-content').prepend('<div class="flow-around-object"></div>');
	}
	
	if ($('.alert').length) {
		$('.alert').dialog({width: 446, modal: true, resizable: false, title: 'Alert:', draggable: false, buttons: [{ text: "Okay", click: function(){$(this).dialog("close");}, class: 'action_button' } ]});
		$('.ui-dialog').prepend('<div id="dialog-kudos-character" class="stopcop"></div>');
		$('.ui-dialog-content').prepend('<div class="flow-around-object"></div>');
	}

	
	// the video tour button clicked (move this to a separate file at some point)
  $('a.video_tour_link').click(function(){
  	$('body').append('<div id="kudos_video"></div>');
  	$('#kudos_video').html('<iframe width="425" height="349" src="http://www.youtube.com/embed/ahHZFck-2ys?rel=0" frameborder="0" allowfullscreen></iframe>').dialog({modal: true, width: 467, resizable: false, buttons: [{ text: "Exit", click: function(){$(this).dialog("close");}, class: 'action_button' } ]  });
  	/* fix some styling rules that really apply to error messages */
  	
  	$('.ui-widget-header').css('display','none');
  	
  	/* close button on jquery ui modal dialog clicked, remove the video content from the DOM */
  	$('a.ui-dialog-titlebar-close').click(function(){
			
			$('div#kudos_video').remove();
		});
  	
  	
  	return false;
  });
  
 	$('a#cancel-kudo-flag').click(function(){
 		$('div').dialog('close');
 	});
        
	

}); // document.ready