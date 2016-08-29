// JavaScript Document
jQuery.noConflict();

jQuery(function() {
    jQuery("#topCart").hover(function() {
            if (jQuery("#jscart_replace_ .cartOver").css("display") == "none") {
                jQuery("#jscart_replace_ .cartOver").css("display", "block");
                jQuery("#jscart_replace_ .cart_").addClass("on_");
            } else if (jQuery("#jscart_replace_ .cart_on_box_").css("display") == "block") {
               jQuery("#jscart_replace_ .cartOver").css("display", "none");
               jQuery("#jscart_replace_ .cart_").removeClass("on_");
            }
    });
});