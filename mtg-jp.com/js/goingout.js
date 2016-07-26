Event.domReady.add(function(){

	if (document.location.href.match(/\/[0-9]{6}\//)) {
		reptxt(/<!-- art:(.+?) -->/gi, function(all, PR){
			return PR.replace(/(C:.*?[\]\)])/gi, '<!-- $1 -->');
		});
	} else {
		reptxt(/<!-- cat:(.+?) -->/gi, function(all, PR){
			return PR.replace(/(C:.*?[\]\)])/gi, '<!-- $1 -->');
		});
	}

	var inner = ["^https?://[^/]*mtg-jp.com/", "^https?://[^/]*wizards.com/", "^https?://[^/]*hasbro.com/", "^https?://wizards.custhelp.com/"];
	for(var i = 0; i < document.links.length; i++){
		var link = document.links[i];
		var out = 0;
		for (var j = 0, n = inner.length; j < n; j++){
			if (link.href.match(new RegExp(inner[j], "i"))) out = 1;
		}
		if (out == 1) continue;
		link.target = "_blank"; 
		if (link.addEventListener){
			link.addEventListener("click", GoingOut, false);
		}else if (link.attachEvent){
			link.attachEvent("onclick", GoingOut);
		}else{
			link.onclick = GoingOut;
		}
	}
});


function GoingOut(evt){
	if (!confirm("リンク先は Wizards of the Coast, LLC の管理するサイトではありません。移動しますか？")){
		if (evt.target){ 
			evt.preventDefault();
		}else if (window.event){ 
			window.event.returnValue = false;
		}
	}
}