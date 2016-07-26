$(function(){

	//image to text
	$(window).bind('resize load', function(){
		if($(this).width() < 641){
			$('.altText').each(function(){
				var alt = $(this).find('img').attr('alt');
				$(this).find('img').hide();
				if(!$(this).find('span').size()){
					$(this).append('<span>'+alt+'</span>');
				}
			});
		}else{
			$('.altText').each(function(){
				var alt = $(this).find('img').attr('alt');
				$(this).find('img:hidden').show();
				if($(this).find('span').size()){
					$(this).find('span').remove();
				}
			});
		}
	});
	
	$('.ttl2 a,#footer .ttl.start a').click(function(){
		var $this = $(this);
		var $target = $(this).parent().next();
		if(!$this.hasClass('open')){
			$this.addClass('open');
			$target.slideDown();
		}else{
			$target.slideUp(function(){
				$this.removeClass('open');
			});
		}
		return false;
	});
	
	$('.ttsBox .btn a').click(function(){
		if(!$(this).hasClass('cu')){
			var myClass = $(this).attr('class');
			$(this).parent().parent().parent().find('.inner').hide();
			$(this).parent().parent().parent().find('.inner.'+myClass).show();
			$(this).parent().parent().parent().find('.inner.'+myClass+' .inner2').jScrollPane({showArrows: true, autoReinitialise: true});
			$(this).parent().parent().find('.cu').removeClass('cu');
			$(this).addClass('cu');
		}
		return false;
	});
	
	//jscroll
    $(function() {
        $(".ttsBox .inner2").each(function(){
			$(this).jScrollPane({showArrows: true, autoReinitialise: true});
		});
    });
	

	//sitemap
	$('.sitemap h2 a').hover(function(){
		$(this).parent().toggleClass('hover');
	});
	$('.sitemap .wrap h2 a').click(function(){
		var $target = $(this).parent().next();
		var $parent = $(this).parent().parent();
		if($parent.hasClass('open')){
			$target.slideUp(function(){
				$parent.removeClass('open');
			});
		}else{
			$parent.addClass('open');
			$target.slideDown();
		}
		return false;
	});

});
