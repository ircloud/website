// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function() {
   var winheight = window.innerHeight;
    if(winheight < 800 && winheight > 400){
    var hheight = winheight - $('.top-bar').height() - $('.mainhicon').height();
    $('.header').height(hheight);
    $('.backwhite').height(winheight - 100);
    }
    $('#back-top').hide();

    $(function() {
        $(window).scroll(function() {
            if ($(this).scrollTop() > 100) {
                $('#back-top').fadeIn();
            } else {
                $('#back-top').fadeOut();
            }
        });

        $('#back-top').click(function(e) {
            console.log('test')
            $('body.html').animate({
                scrollTop: 0
            }, 800);
        });
    });
});
