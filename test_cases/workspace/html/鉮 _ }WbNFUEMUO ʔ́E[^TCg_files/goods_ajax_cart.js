jQuery(document).ready(function () {
    var s_width = 60;
    var l_width = 200;

    if (document.URL.match("cart.aspx")) {
        return false;
    }
    var $btn_cart = jQuery(".goods_ .btn_cart_");
    //$btn_cart.unbind("click");
    //$btn_cart.bind("click", function (e) {
      $btn_cart.die("click");
      $btn_cart.live("click", function (e) {
        var $popup = jQuery('#popupProduct');
        var loadStart = function (elem) {
            var src = jQuery(elem).attr("src");
            var re = new RegExp("^(.+)(\.png|\.gif)$");
            var matches = src.match(re);
            var loadingsrc = "";
            if (matches.length == 3) {
                loadingsrc = matches[1] + "_loading" + matches[2];
            }
            jQuery(elem).attr({
                src: loadingsrc,
                alt: ""
            });
            return elem;
        }
        var loadEnd = function (elem, iserror) {
            var src = jQuery(elem).attr("src");
            //src = src.replace("_loading.", ".");
            if (!iserror) {
				/*
                var box = jQuery("<div></div>").addClass("addcart_overlay_")
                                .append(jQuery("<img>")
                                .attr("src", EC_WWW_ROOT + "/img/usr/cart_complete.gif").attr("alt", ""));
                var position = jQuery(elem).position();
                box.css("top", position.top - 50);
                if (jQuery(elem).width() < l_width) {
                    var leftoffset = (l_width - s_width) / 2;
                    box.css("left", position.left - leftoffset);
                }
                else {
                    box.css("left", position.left);
                }
                jQuery(elem).parent().append(box);
                jQuery(box).fadeIn("normal", function () {
                    setTimeout(function () {
                        jQuery(box).fadeOut("normal", function () {
                            jQuery(box).remove();

                            jQuery(elem).attr({
                                src: src,
                                alt: ""
                            });
                        });
                    }, 900);
                });
                */
                jQuery('.cartSuccess', $popup ).show();
            }
            else {
                jQuery(elem).attr({
                    src: src,
                    alt: ""
                });
                //jQuery(elem).remove();
            }
            $popup.attr('data-is-ajax','0');
        }

        var addCart = function (b, g , q ) {
            $popup.attr('data-is-ajax','1');
            var o = loadStart(b);
			jQuery(b).attr('src', EC_WWW_ROOT + "/img/sys/button/cart_s_loading.gif" );
            jQuery.ajax({
                async: true,
                type: "POST",
                url: EC_WWW_ROOT + "/jp/js/addcart.aspx",
                data: { "goods": goods, "crsirefo_hidden": crsirefo_jscart , "qty" : q },
                cache: false,
                ifModified: false,
                dataType: "json",
                success: function (msg) {
                    if ("loadABtest" in window) {
                    	saveBlockClickLog("jscart");
                    }
                    if (msg != null) {
                        alert(msg.join("\r\n").replace(/<\/?[^>]+>/gi, ""));
                        loadEnd(o, true);
                        return false;
                    }

                    if (jQuery("#jscart_replace_").length > 0) {
                        var self = function (isDelete) {
                            jQuery("#jscart_replace_").load(EC_WWW_ROOT + "/jp/js/cart.aspx", function () {
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
                                                    self(true);
                                                }
                                            });
                                        });
                                    });
                                });
                                if (jQuery(".cart_frame_ .cart_erroralert_").length > 0) {
                                    jQuery(".cart_frame_ .cart_erroralert_")
                                    .css("cursor", "pointer")
                                    .bind("click", function () {
                                        jQuery(".cart_frame_ .cart_errormessages_").show();
                                        jQuery(".cart_frame_ .cart_erroralert_").css("cursor", null);
                                    });
                                }

                                if (!isDelete) {
                                    setTimeout(function () {
                                        loadEnd(o, false);
                                    }, 400);
                                }

                            });
                        }
                        self(false);

                    }
                    else {
                        setTimeout(function () {
                            loadEnd(o, false);
                        }, 400);
                    }
                },
                error: function (xhr, status, thrown) {
                    loadEnd(o, true);
                    alert("セッションの有効期間がきれました。\n" +
                          "誠に恐れ入りますが再度トップページよりのアクセスをお願いいたします。\n\n" +
                          "※当サイトではお客様の情報保護のため、一定時間経過後に接続情報を解除させていただいております。");
                    return false;
                }
            });
            return true;
        }

        if (jQuery(this).attr("src").indexOf("_loading.") != -1) {
            return false;
        }

        var href = jQuery(this).parent().attr("href");
        var re = new RegExp("goods=([0-9A-Za-z_\-]+)");
        var matches = href.match(re);
        var goods = "";
        var qty = jQuery("#cartNum").val();
        if (matches && matches.length == 2) {
            goods = matches[1];
        }
        else {
            return true;
        }
        if (jQuery("#agree_" + goods).length > 0) {
            var btn = this;
            jQuery("#dialog").dialog("destroy");
            jQuery("#agree_" + goods).dialog({
                resizable: false,
                height: 140,
                modal: false,
                buttons: {
                    '　同意する　': function () {
                        jQuery(this).dialog('close');
                        addCart(btn, goods , qty );
                        return false;
                    },
                    '同意しない': function () {
                        jQuery(this).dialog('close');
                        return false;
                    }
                }
            });
        }
        else {
            addCart(this, goods , qty );
            return false;
        }
        return false;
    });
});
