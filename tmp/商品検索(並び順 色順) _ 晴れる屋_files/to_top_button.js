jQuery(function(){

	jQuery(".to_top_button").click(function(){
		jQuery('html,body').animate({
			scrollTop: 0
		});
	});
	
	jQuery(window).scroll(function(){
		
		if(jQuery(window).scrollTop() > 200){
			jQuery(".to_top_button").fadeIn();
		} else {
			jQuery(".to_top_button").fadeOut();			
		}		
	});
	
	var timer=false;
	jQuery(window).resize(function(){
		if (timer !== false) {
			clearTimeout(timer);
		}
		timer = setTimeout(function() {
			console.log('resized');
			if(jQuery(window).width() > 1110){
				jQuery(".to_top_button").attr("style","right:-20px; display:block;");
			} else {
				jQuery(".to_top_button").attr("style","right:" + (parseInt(jQuery(".wrapper_").css("margin-left"), 10) - 90) + "px; display:block;");
			}
		}, 100);
	});
	
});