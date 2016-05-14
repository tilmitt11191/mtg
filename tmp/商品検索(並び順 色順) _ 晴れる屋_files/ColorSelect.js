jQuery(function(){
	jQuery(".mana_symbols .color").click(function(){
		if(jQuery(".mana_symbols .color").is(":not(.selected)")){
			jQuery(this).toggleClass("selected");
		}else{
			jQuery(".mana_symbols .color").removeClass("selected");
			jQuery(this).toggleClass("selected");
		}
	});
});

jQuery(function(){
	jQuery(".select_all").click(function(){
		jQuery(".mana_symbols .color").addClass("selected");
	});
});


jQuery(function(){
	jQuery(".select_none").click(function(){
		jQuery(".mana_symbols .color").removeClass("selected");
	});
});