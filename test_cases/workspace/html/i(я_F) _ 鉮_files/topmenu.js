jQuery(function () {
	var over_flg;
	
  jQuery('.middlemenu_button').click(function() {
  	if(jQuery(this).hasClass('middlemenu_selected')){
  	jQuery(this).removeClass('middlemenu_selected');
    jQuery(this).next('div').slideToggle('fast');
  	}else{
      jQuery('.middlemenu_button').next('div').slideUp('fast');
      jQuery('.middlemenu_button').removeClass('middlemenu_selected');
    jQuery(this).next('div').slideToggle('fast');
    jQuery(this).addClass("middlemenu_selected");
    }
  });

  //　マウスカーソルの位置（メニュー上/メニュー外）
  jQuery('.middlemenu_button,.dropdown').hover(function(){
    over_flg = true;
  }, function(){
    over_flg = false;
  });
  
  // メニュー領域外をクリックしたらメニューを閉じる
  jQuery(document).click(function() {
    if (over_flg == false) {
      jQuery('.middlemenu_button').next('div').slideUp('fast');
      jQuery('.middlemenu_button').removeClass('middlemenu_selected');
    }
  });
});



// 梶谷追記　内部タブ切り替え

function ChangeTab2(tabname2) { 
   // 全部消す
   document.getElementById('category_theme').style.display = 'none';
   document.getElementById('category_duel').style.display = 'none';
   document.getElementById('category_FTV').style.display = 'none';
   // 指定箇所のみ表示
   document.getElementById(tabname2).style.display = 'block';
}

jQuery(function() {
	jQuery('#dropdown_promo .dropdown_tab .tab a').click(function() {
		jQuery('#dropdown_promo .dropdown_tab .tab a').removeClass('selected');
		jQuery(this).addClass('selected');
	});
});
function ChangeTab3(tabname3) { 
   // 全部消す
   document.getElementById('category_middle_standard').style.display = 'none';
   document.getElementById('category_middle_modern').style.display = 'none';
   document.getElementById('category_middle_legacy').style.display = 'none';
   // 指定箇所のみ表示
   document.getElementById(tabname3).style.display = 'block';
}

jQuery(function() {
	jQuery('#dropdown_foil .dropdown_tab .tab a').click(function() {
		jQuery('#dropdown_foil .dropdown_tab .tab a').removeClass('selected');
		jQuery(this).addClass('selected');
	});
});