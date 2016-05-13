
jQuery(window).load(function() {

	var pageNumR = 0 ;
	var pageNumT = 0 ;

	// 売れ筋商品右ボタン
	jQuery("#ranking .rightbutton").click(function(){
		if(pageNumR < 3){
				//window.alert(pageNumR);
			pageNumR ++;
			jQuery(".StyleR_Item_list").stop().animate({
			marginLeft: - 855 * pageNumR
			});
		}
		else{
			jQuery(".StyleR_Item_list").stop().animate({
			marginLeft: - 855 * pageNumR - 30
			},200).animate({
			marginLeft: - 855 * pageNumR
			},200);
		};
	});

	// 売れ筋商品左ボタン
	jQuery("#ranking .leftbutton").click(function(){
		if(pageNumR > 0){
				//window.alert(pageNumR);
			pageNumR --;
			jQuery(".StyleR_Item_list").stop().animate({
			marginLeft: - 855 * pageNumR
			});
		}
		else{
			jQuery(".StyleR_Item_list").stop().animate({
			marginLeft: - 855 * pageNumR + 30
			},200).animate({
			marginLeft: - 855 * pageNumR
			},200);
		};

	});	
	
	// 商品履歴右ボタン
	jQuery("#block_of_itemhistory .rightbutton").click(function(){
		if(pageNumT < 1){
				//window.alert(pageNumT);
			pageNumT ++;
			jQuery(".StyleT_Item_list").stop().animate({
			marginLeft: - 880 * pageNumT
			});
		}
		else{
			jQuery(".StyleT_Item_list").stop().animate({
			marginLeft: - 880 * pageNumT - 30
			},200).animate({
			marginLeft: - 880 * pageNumT
			},200);
		};

	});

	// 商品履歴左ボタン
	jQuery("#block_of_itemhistory .leftbutton").click(function(){
		if(pageNumT > 0){
				//window.alert(pageNumT);
			pageNumT --;
			jQuery(".StyleT_Item_list").stop().animate({
			marginLeft: - 880 * pageNumT
			});
		}
		else{
			jQuery(".StyleT_Item_list").stop().animate({
			marginLeft: - 880 * pageNumT + 30
			},200).animate({
			marginLeft: - 880 * pageNumT
			},200);
		};

	});	

	// 商品詳細おすすめ　右ボタン
	jQuery("#item_detail_recommend .rightbutton").click(function(){
		if(pageNumR < 3){
				//window.alert(pageNumR);
			pageNumR ++;
			jQuery(".StyleR_Item_detail_list").stop().animate({
			marginLeft: - 615 * pageNumR
			});
		}
		else{
			jQuery(".StyleR_Item_detail_list").stop().animate({
			marginLeft: - 615 * pageNumR - 20
			},200).animate({
			marginLeft: - 615 * pageNumR
			},200);
		};

	});

	// 商品詳細おすすめ　左ボタン
	jQuery("#item_detail_recommend .leftbutton").click(function(){
		if(pageNumR > 0){
				//window.alert(pageNumT);
			pageNumR --;
			jQuery(".StyleR_Item_detail_list").stop().animate({
			marginLeft: - 615 * pageNumR
			});
		}
		else{
			jQuery(".StyleR_Item_detail_list").stop().animate({
			marginLeft: - 615 * pageNumR + 20
			},200).animate({
			marginLeft: - 615 * pageNumR
			},200);
		};

	});

	jQuery('.slideLeftButton').live('click',function(){
		var id = jQuery(this).parent('section');
		var target = jQuery(id).find('.itemListLine');
		var listNum = Math.floor(jQuery(id).children('.overLayer').outerWidth(true) / jQuery(target).find('li').outerWidth(true));
		var distance = '+=' + (jQuery(target).find('li').outerWidth(true) * listNum) + 'px';
		var pos = jQuery(target).position();
		var leftCheck = -(jQuery(target).find('li').outerWidth(true) * listNum);
		

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
	jQuery('.slideRightButton').live('click',function(){
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