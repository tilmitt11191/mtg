jQuery(function(){
	jQuery('.slideLeftButton').click(function(){
		var id = jQuery(this).parent('section');
		var target = jQuery(id).find('.itemListLine');
		var listNum = Math.floor(jQuery(id).children('.overLayer').outerWidth(true) / jQuery(target).find('li').outerWidth(true));
		var distance = '+=' + (jQuery(target).find('li').outerWidth(true) * listNum) + 'px';
		var pos = jQuery(target).position();
		var leftCheck = -(jQuery(target).find('li').outerWidth(true) * listNum);
		
		console.log(listNum);

		if(pos.left >= 0){
			var outerDistance = jQuery(target).outerWidth(true);
			var mo = '-' + (outerDistance + leftCheck) + 'px';
			jQuery(target).animate({'left':mo},"slow");
		}else if(pos.left >= leftCheck){
			jQuery(target).animate({'left': '0px'},"slow");
		}else{
			jQuery(target).animate({'left':distance},"slow");
		}
		
	});
	jQuery('.slideRightButton').click(function(){
		var id = jQuery(this).parent('section');
		var target = jQuery(id).find('.itemListLine');
		var listNum = Math.floor(jQuery(id).children('.overLayer').outerWidth(true) / jQuery(target).find('li').outerWidth(true));
		var distance = '-=' + (jQuery(target).find('li').outerWidth(true) * listNum) + 'px';
		var pos = jQuery(target).position();
		var leftCheck = -(jQuery(target).find('li').outerWidth(true) * listNum);
		

		if(-(pos.left + leftCheck) >= jQuery(target).outerWidth(true)){
			jQuery(target).animate({'left':'0px'},"slow");
		}else if(-(pos.left + leftCheck*2) >= jQuery(target).outerWidth(true)){
			var mo = leftCheck - ((pos.left + leftCheck*2) + jQuery(target).outerWidth(true)) + pos.left + 'px';
			jQuery(target).animate({'left':mo},"slow");
		}else{
			jQuery(target).animate({'left':distance},"slow");
		}
	});
});