/// <reference path="jquery.js"/>
/// <reference path="jquery-ui.js"/>

    var cartlistfunc = function (isSlide) {
        if(isSlide){
        jQuery("#jscart_replace_").css("display", "none");
        }
        
        jQuery("#jscart_replace_").load(EC_WWW_ROOT + "/jp/js/cart.aspx", function () {

            var rem_fn = function () {
                jQuery("#jscart_replace_ .cart_goods_ .delete_ img").each(function () {
                    var cart = jQuery(this).attr("alt");
                    jQuery(this).bind("click", function () {
                        jQuery(this).parent().parent().parent().slideUp("normal", function () {
                            jQuery(this).remove();
                            jQuery.ajax({
                                type: "POST",
                                url: EC_WWW_ROOT + "/jp/js/delcart.aspx",
                                data: { "cart": cart, "crsirefo_hidden": crsirefo_jscart },
                                cache: false,
                                success: function () {
                                    cartlistfunc(false);
                                }
        });
    });
                    });
                });
            }

        if (jQuery(".cart_frame_ .cart_erroralert_").length > 0) {
            jQuery(".cart_frame_ .cart_erroralert_")
            .css("cursor", "pointer")
            .bind("click", function () {
                jQuery(".cart_frame_ .cart_errormessages_").show();
                jQuery(".cart_frame_ .cart_erroralert_").css("cursor", null);
            });
        }

            if(isSlide){
            jQuery("#jscart_replace_").show();
                    rem_fn();
            }
            else{
                rem_fn();
            }

        });
    }
    cartlistfunc(true);