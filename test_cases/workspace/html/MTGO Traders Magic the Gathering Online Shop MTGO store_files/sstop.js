function setCookie (name, value, expires, path, domain, secure) {
      document.cookie = name + "=" + escape(value) +
        ((expires) ? "; expires=" + expires : "") +
        ((path) ? "; path=" + path : "") +
        ((domain) ? "; domain=" + domain : "") +
        ((secure) ? "; secure" : "");
}
function getCookie(name){
	var cookie = " " + document.cookie;
	var search = " " + name + "=";
	var setStr = null;
	var offset = 0;
	var end = 0;
	if (cookie.length > 0) {
		offset = cookie.indexOf(search);
		if (offset != -1) {
			offset += search.length;
			end = cookie.indexOf(";", offset)
			if (end == -1) {
				end = cookie.length;
			}
			setStr = unescape(cookie.substring(offset, end));
		}
	}
	return(setStr);	
}

function showCart(id, pattern){
/**
	Example: 
	pattern = '<span class="price">{price}</span> <span class="items"><strong>{items}</strongs> {itemstext}</span>'
*/
	
	var cartvalues = getCookie("ss_cart_" + serialNumber);
	
	var price = "$0.00";
	var count = 0;
	

	if (cartvalues){
		var values = cartvalues.split("|");

		//Get number of items
		count = values[2].substring(values[2].indexOf(":") + 1)
		
		//Get price		
		price = values[3].substring(values[3].indexOf(":") + 1)
	}
  
	pattern = pattern.replace("{price}", price).replace("{items}", count)
	if(count == 1){
		pattern = pattern.replace("{itemstext}", "Item")
	}else{
		pattern = pattern.replace("{itemstext}", "Items")
	}
	document.getElementById(id).innerHTML = pattern;  
}
/* end showCart() */

function fixSearchResults(){
	$$('.search-pipeline').each(function(element){
		if(element.next().nodeName == "DIV"){
			element.remove();
		}
	})
}
function BasicPop(loc, w, h){
	newwindow=window.open(loc,"PopWin","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,width="+w+",height="+h);
}

/* Shopping Cart Extended */
function processCheckout(event){
	//need to remove empty coupons and gift certificate
	$$("input[name='coupon_code']").each(function(o){
		if(o.value == "Coupon Code"){
			o.disabled = true;
		}
	})
	$$("input[name='giftcert_code']").each(function(o){
		if(o.value == "Certificate Number"){
			o.disabled = true;
		}
	})
	$$("input[name='giftcert_pin']").each(function(o){
		if(o.value == "PIN"){
			o.disabled = true;
		}
	})
	return true;
}
/* End Shopping Cart Extended */

function updateQuantity(){
	var value = parseInt($("qnty").value)
	
	if(value){
		value++
	}else{
		value = 1;
	}
	
	$("qnty").value = value
}

function fixDlList(){
	$$(".product-addtocart dl dt").each(function(dt){
		if(dt.getHeight() != dt.next("dd").getHeight()){
			if(dt.hasClassName("last")){
				dt.setStyle({height: "" + ( dt.next("dd").getHeight() - 6 ) + "px"})
			}else{
				dt.setStyle({height: "" + dt.next("dd").getHeight() + "px"})
			}
		}
	})
	$$(".product-addtocart dl dd:last-child").each(function(el){
		el.addClassName("last");
		el.previous("dt").addClassName("last");
	})
}

function hideForgotPassword(){
	hideOverlay();
	$('forgotpassword').fade({duration: 0.5})
}
function showForgotPassword(){
	$("loading").hide();
	
	showOverlay({onclose: hideForgotPassword, showLoading: false})
	$('forgotpassword').appear({duration: 0.5})
	return false;
}
function submitForgotPassword(){
	if(validPassword.validate()){
		
	
	frm = $('forgotpassrodfrm')
	$("loading").show();
	new Ajax.Request(frm.readAttribute("action"), {
		parameters: frm.serialize(),
		method: "post",
		onSuccess: function(transport){
			$("loading").addClassName("loading-no").update(transport.responseText);
		},
		onError: function(){
			$("loading").addClassName("loading-no").update("Something wrong. Please try again later.");
		}
	})
	}
	return false;
}

function hideAddWishList(e){
	hideOverlay();
	$("createwishlistfrm").hide();
	e.stop();
	return false;
}


function updateNewWishlist(){
	
	$$(".ss_wl_Lists span.ss_wl_List[value='new list']").each(function(span){

		span.observe("click", function(){
		
			showOverlay({onclose: hideAddWishList, showLoading: false});
			
			var itemnum = $$("form.addtocartfrm input[name='itemnum']")[0].value;
			var addedfrom = document.location.href;
			var qnty = $$("form.addtocartfrm input.qnty")[0].value;
				
				
			$$("#createwishlistfrm input[name='itemnum']").each(function(input){
				input.disabled = false;
				input.value = itemnum
			})
			$$("#createwishlistfrm input[name='addedfrom']").each(function(input){
				input.disabled = false;
				input.value = addedfrom
			})
			$$("#createwishlistfrm input[name='qnty']").each(function(input){
				input.disabled = false;
				input.value = qnty
			})
			
			var scrollOffset = document.viewport.getScrollOffsets();
			var newTop = scrollOffset.top + 50;
			$("createwishlistfrm").setStyle({top: newTop + "px"}).show();
		})
	})
}

Date.prototype.stdTimezoneOffset = function() {
    var jan = new Date(this.getFullYear(), 0, 1);
    var jul = new Date(this.getFullYear(), 6, 1);
    return Math.max(jan.getTimezoneOffset(), jul.getTimezoneOffset());
}

Date.prototype.dst = function() {
    return this.getTimezoneOffset() < this.stdTimezoneOffset();
}

function updateTimer(){
	//8:41:39 am EST
	var el = document.getElementById("time");
	if(el){
		var d = new Date();
		
		var offset = d.getTimezoneOffset()/60;
		
		if( d.dst() ){
			offset = offset - 4
		}else{
			offset = offset - 5
		}
		
		d.setHours(d.getHours() + offset);
		
		var hours = d.getHours();
		
		if(hours == 0){
			var ampm = "am";
			hours = 12;	
		}else if(hours == 12){
			var ampm = "pm";
			hours = 12;					
		}else if(hours > 12){
			var ampm = "pm";
			hours -= 12;
		}else{
			var ampm = "am";
		}
		
		var minutes = d.getMinutes();
		if(minutes < 10){
			minutes = "0" + minutes;
		}
		
		var seconds = d.getSeconds()
		if(seconds < 10){
			seconds = "0" + seconds;
		}
		
		el.innerHTML = hours + ":" + minutes + ":" + seconds + " " + ampm + " EST";
	}
	window.setTimeout(updateTimer, 1000);
}
updateTimer()

document.observe("dom:loaded", function() {

if($$(".wishlist-product-options form").length > 0){
	//auto saving information about product inside wishlist	
	$$(".ss_wl_qnty").each(function(div){
		
		div.up("form").select("input[type='text']").each(function(element){
			element.observe("keypress", function(e){
				var frm = e.element().up("form");
				frm.select(".saved").each(function(div){div.setStyle({display: "none"})})
				//need to hide "Saved"
			})
		})
		
		div.up("form").select("select").each(function(element){
			element.observe("change", function(e){
				var frm = e.element().up("form");
				frm.select(".saved").each(function(div){div.setStyle({display: "none"})})
				//need to hide "Saved"
			})
		})
		
		
		
		div.up("form").select("input[type='text'], select").each(function(element){
			element.observe("change", function(e){
				//need to create and show loading icon
				
				var frm = e.element().up("form");
				
				if(frm.select(".saved").length == 0){
					frm.select(".ss_wl_qnty")[0].insert(
						(new Element("div")).addClassName("saved").update("Saving...")
					)
				}
				frm.select(".saved")[0].setStyle({display: "block"}).update("Saving...");
				
				new Ajax.Request(frm.action, {
					method: frm.method,
					parameters: frm.serialize(),
					onSuccess: function(response){
						//alert("Updated!")
						frm.select(".saved")[0].setStyle({display: "block"}).update("Saved!");
						//need to create and show "Saved"
					}
				})
				
				
			})
		})
		
	})
	
	

	//fixing problem with quantity
	$$(".wishlist-product-options form").each(function(frm){
		
		frm.observe("submit", function(e){
			
			frm = e.element();
			
			var itemnum = frm.select("input[name='itemnum']")[0].value;
			var qnty = frm.up("div.wishlist-product").select("input[name='qntyDesired']")[0].value;
		
			frm.insert(
				new Element("input", {name: itemnum + ":qnty", type: "hidden", value: qnty})
			);
			
		})
		
	})
	//adding "Add all products to cart"
	var addToCart = new Element("input", {id: "addalltocart", type: "image", src: "http://www.mtgotraders.com/store/media/images/addalltocart.png", value: "Add to Cart", style: "clear: both; display: block; margin: 0 auto 15px auto;"})
	$("wishlist-products").insert(addToCart, {position: "after"})
	$("wishlist-products").insert(
		(new Element("form", {method: "post", action: "http://www.mtgotraders.com/cgi-bin/shop-bin/sc/order.cgi", id: "addalltocartfrm", style: "display: none;"})).insert(
			new Element("input", {type: "hidden", name: "storeid", value: "*1a4c945171a04aae08de729fc95b2a"})
		).insert(
			new Element("input", {type: "hidden", name: "dbname", value: "products"})
		).insert(
			new Element("input", {type: "hidden", name: "function", value: "add"})
		)
	)
	
	$$(".content")[0].insert(
		(new Element("button", {id: "scroll", style: "display: none; width: auto; left: auto; right: 0; font-size: 18px; font-variant: normal;"})).update("Add ALL Cards on This Page to the Basket!")
	)
	//<button id="scroll" style="display: none;">Add to Cart</button>
	
	$("scroll").observe("click", function(){
		
		$$(".wishlist-product-options form").each(function(frm){
			var itemnum = frm.select("input[name='itemnum']")[0].value;
			var qnty = frm.up("div.wishlist-product").select("input[name='qntyDesired']")[0].value;
			var wlpid = frm.select("input[name='" + itemnum + ":wlpid']")[0].value

			$("addalltocartfrm").insert(
				new Element("input", {name: "itemnum", type: "hidden", value: itemnum})
			);
		
			$("addalltocartfrm").insert(
				new Element("input", {name: itemnum + ":qnty", type: "hidden", value: qnty})
			);
			
			$("addalltocartfrm").insert(
				new Element("input", {name: itemnum + ":wlpid", type: "hidden", value: wlpid})
			);
		})
	
		$("addalltocartfrm").submit();
		
	})
	
	$("addalltocart").observe("click", function(){	
	
		$$(".wishlist-product-options form").each(function(frm){
			var itemnum = frm.select("input[name='itemnum']")[0].value;
			var qnty = frm.up("div.wishlist-product").select("input[name='qntyDesired']")[0].value;
			var wlpid = frm.select("input[name='" + itemnum + ":wlpid']")[0].value

			$("addalltocartfrm").insert(
				new Element("input", {name: "itemnum", type: "hidden", value: itemnum})
			);
		
			$("addalltocartfrm").insert(
				new Element("input", {name: itemnum + ":qnty", type: "hidden", value: qnty})
			);
			
			$("addalltocartfrm").insert(
				new Element("input", {name: itemnum + ":wlpid", type: "hidden", value: wlpid})
			);
		})
	
		$("addalltocartfrm").submit();
	})
	
	
	
	
	
	
	
	
	
	
	
function processScroll(){
	var scroll = $("scroll")
	if(scroll){
		var scrollOffset = document.viewport.getScrollOffsets()
		var dim = getPageSize();
		if(scrollOffset.top + document.viewport.getHeight() >= dim[1]){
			scroll.setStyle({display: "none"})
			return;
		}
		var wrapper = $$(".wrapper")[0];
		var height = document.viewport.getHeight();
		var newY = scrollOffset.top + height - 40;
		if(newY > wrapper.getHeight() - 100){
			newY = wrapper.getHeight() - 100;
		}
		scroll.setStyle({display: "block", top: newY + "px"})
	}
}

function getPageSize(){
	var xScroll, yScroll;
	if (window.innerHeight && window.scrollMaxY) {
	xScroll = document.body.scrollWidth;
	yScroll = window.innerHeight + window.scrollMaxY;
	} else if (document.body.scrollHeight > document.body.offsetHeight){ // all but Explorer Mac
	xScroll = document.body.scrollWidth;
	yScroll = document.body.scrollHeight;
	} else { // Explorer Mac...would also work in Explorer 6 Strict, Mozilla and Safari
	xScroll = document.body.offsetWidth;
	yScroll = document.body.offsetHeight;
	}
	var windowWidth, windowHeight;
	if (self.innerHeight) { // all except Explorer
	windowWidth = self.innerWidth;
	windowHeight = self.innerHeight;
	} else if (document.documentElement && document.documentElement.clientHeight) { // Explorer 6 Strict Mode
	windowWidth = document.documentElement.clientWidth;
	windowHeight = document.documentElement.clientHeight;
	} else if (document.body) { // other Explorers
	windowWidth = document.body.clientWidth;
	windowHeight = document.body.clientHeight;
	}
	// for small pages with total height less then height of the viewport
	if(yScroll < windowHeight){
	pageHeight = windowHeight;
	} else {
	pageHeight = yScroll;
	}
	// for small pages with total width less then width of the viewport
	if(xScroll < windowWidth){
	pageWidth = windowWidth;
	} else {
	pageWidth = xScroll;
	}
	arrayPageSize = new Array(pageWidth,pageHeight,windowWidth,windowHeight)
	return arrayPageSize;
}

window.onresize = processScroll
window.onload = processScroll
window.onscroll = processScroll 	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
	
	
	$$("#choose_wishlist form").each(function(form){
		form.observe("submit", function(e){
			
			if(e.element().select("input[name='wl']:checked")[0].value == "new list"){
				
				showOverlay({onclose: hideAddWishList, showLoading: false});
			
				var vars = {};
				var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
      				vars[key] = value;
    			});
			
				var itemnum = vars["itemnum"];
				var addedfrom = vars["addedfrom"];
				var qnty = vars["qnty"];
				
				
				$$("#createwishlistfrm input[name='itemnum']").each(function(input){
					input.disabled = false;
					input.value = itemnum
				})
				$$("#createwishlistfrm input[name='addedfrom']").each(function(input){
					input.disabled = false;
					input.value = addedfrom
				})
				$$("#createwishlistfrm input[name='qnty']").each(function(input){
					input.disabled = false;
					input.value = qnty
				})
			
				var scrollOffset = document.viewport.getScrollOffsets();
				var newTop = scrollOffset.top + 50;
				$("createwishlistfrm").setStyle({top: newTop + "px"}).show();
				
				
				e.stop();
				return false;
			}
		})
	})
	
	$$(".create-wishlist-link span.createwishlist a, .unused-text-button span.createwishlist a").each(function(a){
		a.observe("click", function(e){
			
			showOverlay({onclose: hideAddWishList, showLoading: false});
			
			$$("#createwishlistfrm input[name='itemnum'], #createwishlistfrm input[name='addedfrom'], #createwishlistfrm input[name='qnty']").each(function(input){
				input.disabled = true;
			})
			
			var scrollOffset = document.viewport.getScrollOffsets();
			var newTop = scrollOffset.top + 50;
			$("createwishlistfrm").setStyle({top: newTop + "px"}).show();
			
			e.stop();
			return false;
		})
	})
	
	$$("#createwishlistfrm span.close, #createwishlistfrm input[value='Continue Shopping']").each(function(o){
		o.observe("click", hideAddWishList)
	})
	
	function hideDeleteWishList(e){
		hideOverlay();
		$("deletewishlistfrm").hide();
		e.stop();
		return false;
	}
	
	$$(".unused-text-button span.deletewishlist a").each(function(a){
		a.observe("click", function(e){
			
			showOverlay({onclose: hideDeleteWishList, showLoading: false})
			
			var vars = {};
			var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
      			vars[key] = value;
    		});
			
			var wlid = vars["wl"];
			
			$$("#deletewishlistfrm input[name='wl']").each(function(input){
				input.value=wlid
			})
			var scrollOffset = document.viewport.getScrollOffsets();
			var newTop = scrollOffset.top + 50;
			$("deletewishlistfrm").setStyle({top: newTop + "px"}).show();
			
			e.stop();
			return false;
		})
	})
	
	$$("#deletewishlistfrm span.close, #deletewishlistfrm input[value='No ']").each(function(o){
		o.observe("click", hideDeleteWishList)
	})
	//http://www.mtgotraders.com/cgi-bin/shop-bin/sc/wishlist.cgi?storeid=*1a4c945171a04aae08de729fc95b2a&func=edit&wl=FjeXdQjLAjVB7iYDIPzd
	
	
	
	function hideEditWishList(e){
		hideOverlay();
		$("editwishlistfrm").hide();
		e.stop();
		return false;
	}
	
	$$("span.editwishlist a").each(function(a){
		a.observe("click", function(e){
			
			showOverlay({onclose: hideEditWishList, showLoading: true})
			
			var vars = {};
			var parts = a.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
      			vars[key] = value;
    		});
			
			var wlid = vars["wl"];
			$$("#editwishlistfrm input[name='wl']").each(function(input){
				input.value=wlid
			})
			
			
			new Ajax.Request(shoppingCartUrl + "/wishlist.cgi" + e.element().readAttribute("href"), {
				method: "get",
				onSuccess: function(transport){
					
					var wrapper= document.createElement('div');
					wrapper.innerHTML= transport.responseText;
					
					var scrollOffset = document.viewport.getScrollOffsets();
					var newTop = scrollOffset.top + 50;
					
					if(wrapper.select("input[name='name']").length > 0){
						var name = wrapper.select("input[name='name']")[0].readAttribute("value")
					}else{
						var name = "";
					}
					
					$$("#editwishlistfrm input[name='name']").each(function(input){
						input.value = name;
						input.focus();
					})
					
					if(wrapper.select("textarea[name='comments']").length > 0){
						var comments = wrapper.select("textarea[name='comments']")[0].value
					}else{
						var comments = "";
					}
					
					$$("#editwishlistfrm textarea[name='comments']").each(function(input){
						input.value = comments;
					})
					
					if(wrapper.select("select[name='priv']").length > 0){
						var pri = wrapper.select("select[name='priv']")[0].value
					}else{
						var pri = "";
					}
					
					$$("#editwishlistfrm select[name='priv']").each(function(input){
						input.value = pri;
					})
					
					$("editwishlistfrm").setStyle({top: newTop + "px"}).show();
					
					stopOverlayLoading();
				},
				onError: function(){
					alert("Something wrong. Please try again later.")
				}
			})
						
			e.stop();
			return false;
		})
	})
	
	$$("#editwishlistfrm span.close, #editwishlistfrm input[value='Continue Shopping']").each(function(o){
		o.observe("click", hideEditWishList)
	})
	
	
})
