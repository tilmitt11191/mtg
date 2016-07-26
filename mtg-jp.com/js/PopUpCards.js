//PopUpCards フロントエンド Javascript (Cross-browser :-)
//Made by Pao for mtg-jp.com
document.write('<div id="PopupCard" style="display: none; border-style: none; width:266px; height: 1000px; position: absolute; z-index: 9999;" allowtransparency="true" frameborder="0"></div>');


// HTTP通信用、共通関数
function createXMLHttpRequest(cbFunc){
	var XMLhttpObject = null;
	try{
		XMLhttpObject = new XMLHttpRequest();
	}catch(e){
		try{
			XMLhttpObject = new ActiveXObject("Msxml2.XMLHTTP");
		}catch(e){
			try{
				XMLhttpObject = new ActiveXObject("Microsoft.XMLHTTP");
			}catch(e){
				return null;
			}
		}
	}
	if (XMLhttpObject) XMLhttpObject.onreadystatechange = cbFunc;
	return XMLhttpObject;
}



function popUpCard( cardname, evt ) {
	var puc   = document.getElementById( 'PopupCard' );
	var style = puc.style;
	if (! evt) { evt = event; }
	httpObj = createXMLHttpRequest(displayData);

	if (httpObj){
		httpObj.open("GET", "/js/PopUpCards.cgi?name=" + encodeURI(cardname), true);
		httpObj.send(null);
	}
	var ox; var oy;
	var dx; var dy;
	ox = (document.body.scrollLeft || document.documentElement.scrollLeft);
	oy = (document.body.scrollTop  || document.documentElement.scrollTop);
	if ((!document.all || window.opera) && document.getElementById) {
		dx=window.innerWidth;
		dy=window.innerHeight;
	}else if (document.getElementById && (document.compatMode=='CSS1Compat')) {
		dx=document.documentElement.clientWidth;
		dy=document.documentElement.clientHeight;
	}else if (document.all) {
		dx=document.body.clientWidth;
		dy=document.body.clientHeight;
	} else {
		dx=1024;
		dy=800;
	}

	var width = 288;
	if (evt.clientX + width + 16 > dx){
		style.left = (evt.clientX + ox - width) + "px"; 
	} else {
		style.left = (evt.clientX + ox + 16) + 'px';
	}
	var height = 500;
	if (evt.clientY + height + 16 > dy){
		style.top = (dy + oy - height) + "px";
	} else { 
		style.top = (evt.clientY + oy + 16) +"px";
	}

}
function displayData() {
	var puc   = document.getElementById( 'PopupCard' );
	if ((httpObj.readyState == 4) && (httpObj.status == 200)){
		puc.innerHTML = httpObj.responseText;
		puc.style.display  = 'block';
	}else{
		puc.innerHTML = "";
		puc.style.display  = 'none';
	}
}

function popDown() {
	httpObj.abort();
	document.getElementById( 'PopupCard' ).style.display = 'none';
}
