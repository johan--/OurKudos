$(document).ready(function(){

	jQuery('#signup_user_password').pstrength({minChar: 6, minCharText: ''});
	jQuery('#change_user_password').pstrength({minChar: 6, minCharText: ''});

}); // document.ready