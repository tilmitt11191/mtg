;(function($) {

	var REQUEST_URL = EC_WWW_ROOT + '/jp/search/popupproduct.aspx';

	var Goods = {
		search : function( goods_cd , fncBeforeSend ){
			var defer = $.Deferred();
			$.ajax({
				 url			: REQUEST_URL
				,dataType		: "html"
				,scriptCharset	: "UTF-8"
				,data			: { goods : goods_cd }
				,beforeSend		: fncBeforeSend
				,success		: defer.resolve
				,error			: defer.reject
			});
			return defer.promise();
		}
	}

	var ModalHideTimer;
	var $hoverItem	= null;
	var $modalRoot	= $('#popupProduct');
	var $modalDetal	= $('.popupWindow:first', $modalRoot);
	var $ArrowUp	= $('.upArrow:first'	, $modalRoot);
	var $ArrowDown	= $('.downArrow:first'	, $modalRoot);
	var $Wrapper	= $('.wrapper_:first'	, 'body'	);
	var $Success	= $('.cartSuccess:first', $modalRoot);

	var goods_cd = "";

	var Page = {
		 mouseOnModal : false
		,showPopup : function( html ){

			$Success.hide();

			var goods = $( html ).prev('div.popupLeft').attr('data-goods');
			if( goods_cd != goods ){ return false; }

			$modalDetal.append( html );

			var modalTop	= 0;
			var modalLeft	= 0;
			var arrowLeft	= 32;
			var scroll_top	= $(window).scrollTop();
			var obj_offset	= $hoverItem.offset();
			var base_height	= $hoverItem.height();
			var rightLimit	= $Wrapper.offset().left + $Wrapper.width();

			if( 220 < ( obj_offset.top - scroll_top )){
				$ArrowUp.hide();
				$ArrowDown.show();
				modalTop = obj_offset.top - $modalRoot.outerHeight(true);
			}else{
				$ArrowUp.show();
				$ArrowDown.hide();
				modalTop = obj_offset.top + $hoverItem.outerHeight(true);
			}

			var modalRight = obj_offset.left + $modalRoot.width();

			if( rightLimit < modalRight ){
				modalLeft = obj_offset.left - ( modalRight - rightLimit );
				arrowLeft += modalRight - rightLimit;
			}else{
				modalLeft = obj_offset.left;
			}

			$(".popupArrow",$modalRoot).css("left",arrowLeft + 'px');
			$modalRoot.css({"top": modalTop + 'px',"left": modalLeft + 'px'}).show();

		}
		,hidePopup : function(){
			$modalRoot.hide();
			$('.popupLeft'	, $modalDetal ).remove();
			$('.popupRight'	, $modalDetal ).remove();
		}
		,plusQty : function(){
			var $cartQty = $('#cartNum',$modalRoot);
			var cartNum	 = $cartQty.val();
			if( isFinite( cartNum ) ){
				cartNum++;
			}
			$cartQty.val( cartNum );
		}
		,minusQty : function(){
			var $cartQty = $('#cartNum',$modalRoot);
			var cartNum	 = $cartQty.val();
			if( isFinite( cartNum ) && 1 < cartNum ){
				cartNum--;
			}
			$cartQty.val( cartNum );
		}
	}

	$modalRoot.mouseenter(function(){
		Page.mouseOnModal = true;
	}).mouseleave( function(){
		Page.mouseOnModal = false;
	});

	$('a.popup_product').live('mouseenter', function(){

		var $this = $(this);

		$this.attr('data-on-mouse',1)

		clearInterval(ModalHideTimer);
		$hoverItem = $(this);
		goods_cd = $(this).attr('data-goods');

		setTimeout( function(){
			if( 1 == $this.attr('data-on-mouse') ){
				Goods
					.search( goods_cd , function(){
					
					})
					.done( function( html ){
						Page.hidePopup();
						Page.showPopup( html );
					})
					.fail( function( e ){
					});
			}
		},300);

		return false;

	}).live('mouseleave', function(){

		$(this).attr('data-on-mouse',0);

		ModalHideTimer = setInterval( function(){
			var isAjax = $modalRoot.attr('data-is-ajax');
			if( !Page.mouseOnModal && '1' != isAjax ){
				Page.hidePopup();
				clearInterval(ModalHideTimer);
			}
		}, 300 );
	});

	$('.cartPlus:first', $modalRoot ).live('click',function(){
		Page.plusQty();
		return false;
	});

	$('.cartMinus:first', $modalRoot ).live('click',function(){
		Page.minusQty();
		return false;
	});

	$('.btn_cart_').live('click',function(){
		var url = location.href;
		ga('send', 'event', 'cart_popup', 'click', url );
	});

	$('#rotationBanner a').live('click',function(){
		var img = $(this).children('img').attr('src');
		ga('send', 'event', 'top_banner', 'click', img );
	});

	$('#tcSlide a').live('click',function(){
		var img = $(this).children('img').attr('src');
		ga('send', 'event', 'tc_banner', 'click', img );
	});

	$('#naritaSlide a').live('click',function(){
		var img = $(this).children('img').attr('src');
		ga('send', 'event', 'narita_banner', 'click', img );
	});



}(jQuery));
