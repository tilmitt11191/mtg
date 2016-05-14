function ChangeTab(tabname) { 
   // 全部消す
   document.getElementById('hit_standard').style.display = 'none';
   document.getElementById('hit_modern').style.display = 'none';
   document.getElementById('hit_legacy').style.display = 'none';
   // 指定箇所のみ表示
   document.getElementById(tabname).style.display = 'block';
}

jQuery(window).load(function() {
	jQuery('#deck_hitchart .tab li').click(function() {
		jQuery('#deck_hitchart .tab li').removeClass('selected');
		jQuery(this).addClass('selected');
	});
});
