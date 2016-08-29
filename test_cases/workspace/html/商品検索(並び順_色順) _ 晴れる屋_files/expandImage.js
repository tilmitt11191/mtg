jQuery(function(){
	jQuery(".expand_image").click(function() {
		jQuery(".expand_image").fadeOut();
	});
	jQuery(".expand,.item_info_img").click(function() {
		jQuery(".expand_image").fadeIn();
	});
});