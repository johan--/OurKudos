jQuery(function($) {

  $("#gift_select_slider input[type=radio]").attr('checked', false);

  //repopulate slider
  $("#gift_select_slider a").click(function(event) {
         
    //unbind click that were bound on DOM load
    $('a.back').unbind('click');
    $('a.forward').unbind('click');
    $('#gift_select_slider').css({'background-image' :'url(/images/loading.gif','background-repeat' : 'no-repeat', 'background-position' : 'center center'});

    // Step 1 Remove the current li's
    $('.wrapper li').remove();

    // Step 2 fetch new data
    var gift_group = $(this).attr('name');
    var group_name = $(this).attr('title');

    //jQuery.get('/gifts/list_gifts_in_group_slider/' + gift_group + ".js", function(data){
    jQuery.ajax({
      url: '/gifts/list_gifts_in_group_slider/' + gift_group + ".js",
      dataType: 'html',
      success: function(data){
        $('.wrapper ul').append(data); 
        $('ul > li');
        $('.infiniteCarousel').infiniteCarousel();
      }
    });

    // Step 3 Rebind all carousel functions
    $('#group_name').html(group_name);
    $('#gift_select_slider').css('background-image', 'none');
        
    $('.wrapper a').bind('click');

    return false;
    });
})

//display gift info in gift_info div
jQuery(document).ready(function(){
  $("#gifting_img_slider .wrapper a").live('click', function(event) {
    var gift_id = $(this).attr('name');
    jQuery.ajax({
        type: 'GET',
        dataType: 'html',
        url: '/gifts/' + gift_id + ".js", 
        success: function(data){
          $("#gift_info").html(data);
        } 
    });
    return false
  });
});


//Graceful degredation JS and Document load calls
jQuery(document).ready(function(){
  $('#gift_list_noscript').hide();
  $('#gift_select_slider').show();
  $('.infiniteCarousel .wrapper ul').css({'width' : '9999px'});
  $('#gifting_img_slider .infiniteCarousel .wrapper').css({'min-height' : '230px'});
  $('#pages p').show();
//  $('.infiniteCarousel ul li').css({'height' : '85px'})
  $('.infiniteCarousel').infiniteCarousel();
  $('.wysiwyg').wysiwyg();

});
