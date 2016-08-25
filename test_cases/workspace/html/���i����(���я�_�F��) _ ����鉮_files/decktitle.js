jQuery(window).load(function() {
    jQuery('.deck_title p,.name1_,.name_.deckTitle,.columntitle,deckRecommend .deckTitle').each(function() {
        var $target = jQuery(this);
 
        var html = $target.html();
 
        var $clone = $target.clone();
        $clone
            .css({
                display: 'none',
                position : 'absolute',
                overflow : 'visible',
				maxHeight:'none'
            })
            .width($target.width())
            .height('auto');
 
        $target.after($clone);
		
        while((html.length > 0) && ($clone.height() > $target.height())) {
            html = html.substr(0, html.length - 3);
            $clone.html(html + '&hellip;');
        }
		
        $target.html($clone.html());
        $clone.remove();
    });
});