jQuery(window).load(function(){
    jQuery("img.ChangePhoto").click(function(){
        var ImgSrc = jQuery(this).attr("src");
        var ImgAlt = jQuery(this).attr("alt");
        jQuery("img#MainPhoto").attr({src:ImgSrc,alt:ImgAlt});
        jQuery("img#MainPhoto").hide();
        jQuery("img#MainPhoto").fadeIn("slow");
        jQuery("img#ExpandedImage").attr({src:ImgSrc,alt:ImgAlt});
        jQuery("img#ExpandedImage").hide();
        jQuery("img#ExpandedImage").fadeIn("slow");
        jQuery(".expandPhoto").attr({src:ImgSrc,alt:ImgAlt});
        jQuery(".expandPhoto").hide();
        jQuery(".expandPhoto").fadeIn("slow");
        return false;
    });
});
