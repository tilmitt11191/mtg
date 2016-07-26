$(function(){
	var $container = $('#start_slideshow ul');
	var $items = $('#start_slideshow li');
	var interval = 6000;
	var delaySpeed = 100;
	var fadeSpeed = 1000;

	$items.find('a').hover(function(){
		var w = $(this).find('img').width();
		var h = $(this).find('img').height();
		$(this).append('<span></span>');
		$(this).find('span').width(w).height(h);
	},function(){
		$(this).find('span').remove();
	});

	function loadImg(){
		addClass();
		$items.each(function(i){
			$(this).delay(i*(delaySpeed)).css({
				display:'block',
				opacity:'0'
			}).animate({
				opacity:'1'
			},fadeSpeed);
		});
		startTimer();
	}
	function switchImg(){
		var fourth = $('#start_slideshow li:nth-child(3)');
		var lastChild = $('#start_slideshow li:last-child()');
		$items.removeClass().hide();
		lastChild.prependTo($container);
		addClass();
		$items.fadeIn(fadeSpeed);
	}
	function addClass(){
		$('#start_slideshow').find('li').each(function(i){
			$(this).addClass('item' + (i+1));
		});
	}
	function startTimer(){
		timer = setInterval(switchImg, interval);
	}
	function stopTimer(){
		clearInterval(timer);
	}
	loadImg();
	$container.find('a').hover(stopTimer,startTimer);



});
