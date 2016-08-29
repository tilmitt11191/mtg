//順序ボタン用
jQuery(window).load(function(){
	jQuery("#order p").click(function(){
		if(jQuery(this).hasClass('selected')){
			/*
			jQuery("#order p").each(function(){
			jQuery(this).removeClass("selected");
			});
			jQuery("#chrono").addClass("selected");
			*/
		}
		else{
			jQuery("#order p").each(function(){
				jQuery(this).removeClass("selected");
			});
			jQuery(this).addClass("selected");
		}
	});
});


//data_alphaの上4桁をあいうえお順の制御に、下4桁をアルファベット順の制御に用いる
jQuery(function() {
	var arr= new Array();
	jQuery(".category_tree_ li.category_key").each(function(i){
		arr[i]= new Object();
		//arr[i].key= jQuery(this).attr("data_alpha").substring(0,4);//ABC順
		arr[i].key= jQuery(this).attr("data_alpha").substring(4,8);//あいう順
		arr[i].key2= jQuery(this).attr("data_relese");//時系列順
		arr[i].value=jQuery(this);
	});

//あいうえお昇順
jQuery("#alpha").click(function(){
	arr.sort(sortAlpha);
	for(i=0;i<arr.length;i++){
		jQuery(".category_tree_").append(arr[i].value);
	}
});

//時系列降順
jQuery("#chrono").click(function(){
	arr.sort(sortChrono);
	for(i=0;i<arr.length;i++){
		jQuery(".category_tree_").append(arr[i].value);
	}
});

var sortAlpha = function(a, b) {
	return a.key.localeCompare(b.key);
}
var sortChrono = function(a, b) {
	return b.key2.localeCompare(a.key2);
}


});

/*
jQuery(function() {

	var arr= new Array();
	jQuery(".category_tree_ li.category_key").each(function(i){
		arr[i]= new Object();
		arr[i].key2= jQuery(this).attr("data_relese");
		arr[i].value2=jQuery(this);
	});

//時系列昇順
	jQuery("#chrono").click(function(){
		arr.sort(sortDesc);
		for(i=0;i<arr.length;i++){
			jQuery(".category_tree_").append(arr[i].value2);
			alert(arr[i].value2);
		}
	});
	
	var sortDesc = function(a, b) {
    return b.key2.localeCompare(a.key2);
  }


});
*/


//カテゴリー絞込み
jQuery(function(){
	jQuery('#narrow p').each(function(){
		jQuery(this).click(function(){
			if(jQuery(this).hasClass('selected')){
				//jQuery(".category_tree_ .category_key").css("display","block");
			}
			else{
				var idname = jQuery(this).attr("id").substring(3).toLowerCase();
				var classname = '.';
				classname += idname;
				jQuery('.category_tree_ .category_key:not(classname)').css('display','none');
				jQuery(classname).fadeIn(200);
			}
		});
	});
});


//カテゴリーボタン用
jQuery(function(){
	jQuery("#narrow p").click(function(){
		if(jQuery(this).hasClass('selected')){
			/*
			if(jQuery(this).hasClass('selected')){
			jQuery("#narrow p").removeClass("selected");
			jQuery(".category_tree_ .category_key").removeAttr("display");
			jQuery("#keyAll").addClass("selected");
			*/
		}
		else{
			jQuery("#narrow p").removeClass("selected");
			jQuery(this).addClass("selected");
		}
	});
});

