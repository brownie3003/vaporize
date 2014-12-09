// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require jquery-ui
//= require bootstrap-sprockets
//= require jquery.fullPage.js
//= require stripe


$('document').ready(function() {
    $('html').addClass('js');
    
    $('.footer-trigger').click(function(e) {
        var $footer = $("footer"),
            $footerTrigger = $(".footer-trigger"),
            animationSpeed = 500;
            
        
        if($footer.is(":visible")) {
            $footerTrigger.animate(
                {bottom: 0},
                animationSpeed
            );
            $footerTrigger.find(".glyphicon").removeClass("glyphicon-chevron-down").addClass("glyphicon-chevron-up");
            $footer.slideUp(animationSpeed);
        } else {
            $footerTrigger.animate(
                {bottom: "10%"},
                animationSpeed
            );
            $footerTrigger.find(".glyphicon").removeClass("glyphicon-chevron-up").addClass("glyphicon-chevron-down");
            $footer.slideDown(animationSpeed);
        }
    })
});