//すぅぱーぎゃざりんくJS 
//mixed by *ぱお*/米村 薫
//20081202　初版作成・公開
//20090215　リンク先をタカラトミー社のAutocardからWhisperに変更
//20090218　<a>内の該当文字列はリンクしないように変更。onready.js使用に変更
//20090410　リンク先をbeta.gathererに変更
//20090627　mtg-jp.com用に編集。onready.htcを相方に。
//20090629　カード画像にも対応。CSS側対応必須。
//20090703　マナ、タップ、アンタップシンボルに対応。
//20090709　何か変な機能追加。関数「LangGatherer」。
//20090710　シンボルおよびカード画像に alt 要素を追加。
//20090802　外部からの利用に向け、onreadyを廃止。onload拡張関数 addEventを定義。
//20090813　カード画像リンク、略号じゃないセット名にも対応。
//20091016　リンク先を臨時にmtg-jp.com内カードリストへ。
//20091225　<a>A<a>B<\/a>C<\/a>を<a>ABC<\/a>にする置換実装。
//20100321　カード画像部分に入っている全角文字を無視するように。これで辞書そのままで対応可能に。
//20100512　<caption>に[MO]リンクを追加する機能実装。
//20100626　互換性のためにaddEventを解体。
//20100702　domready.jsを採用。
//20100807　20091225の改良を単純化。
//20100816　20091225の改良をさらに改善。<a>A<a>B<\/a>C<a>D<\/a>E<\/a>に対応。
//20101030　PopUpCards.js と連携。
//20110121　分割カードのPopUpCards.js に対応。
//20110305　いつからかIEで[MO]リンクが作動しなくなっていた模様。innerHTMLの仕様違い。
//20110313　英語カード名に使える文字を拡張しすぎて余計なものまで食っていた。
//20110816　innerHTMLを改めて正当なDOMいじりに変更。reptxtを定義。
//20110910　リダイレクトの処理をようやく実装。
//20111202　tableからimgにカード画像の実装を変更。
//20120529　{C}シンボルの実装。
//20121201　カバレージ分類用badgeの実装。
//20130215　カバレージ分類用badgeの更新。
//20130517　分割カードのfindcard.cgiに対応。
//20130605　英語カード名の'に対応。
//20140423　<!-- Cn: --> で、リンクナシで画像表示のみ。
//20151211　{C}に対応。

Event.domReady.add(function (){
	var dfc = 0;
	var CARD, BORDER, LA;
	reptxt(/C:[^A-Z>]*?([A-Z][\x20-\x2e|\x30-\x3b|=\?|A-Z|a-z]+)[^>\[\(]*[\[\(]([A-Z0-9_]{3})[\]\)].*/g, 1, function (){
		if ((arguments[2] != '1ED')&&(arguments[2].search(/^.ED/) != -1)) {
			BORDER = "_w";
		}else if ((arguments[2] == 'UNH')||(arguments[2] == 'UGL')) {
			BORDER = "_s";
		}else{
			BORDER = "_b";
		}
		var LA = arguments[1].replace(/[\+,':] */g, '_').replace(/ /g, '+');
		return ('<a href="http://mtg-jp.com/js/findcard.cgi?name=' + arguments[1].replace(/\+/, "  ").replace(/ /g, "+") + '" target="_blank"><img class="cii'+ BORDER +'" src="http://mtg-jp.com/cardlist/cards/' + arguments[2] + '/' + LA + '.jpg" alt="' + arguments[1] + '"><\/a>');
	});
	reptxt(/Cn:[^A-Z>]*?([A-Z][\x20-\x2e|\x30-\x3b|=\?|A-Z|a-z]+)[^>\[\(]*[\[\(]([A-Z0-9_]{3})[\]\)].*/g, 1, function (){
		if ((arguments[2] != '1ED')&&(arguments[2].search(/^.ED/) != -1)) {
			BORDER = "_w";
		}else if ((arguments[2] == 'UNH')||(arguments[2] == 'UGL')) {
			BORDER = "_s";
		}else{
			BORDER = "_b";
		}
		var LA = arguments[1].replace(/[\+,':] */g, '_').replace(/ /g, '+');
		return ('<img class="cii'+ BORDER +'" src="http://mtg-jp.com/cardlist/cards/' + arguments[2] + '/' + LA + '.jpg" alt="' + arguments[1] + '">');
	});
	reptxt(/Cd:[^A-Z>]*?([A-Z][\x20-\x2e|\x30-\x3b|=\?|A-Z|a-z]+)[^>\[\(]*[\[\(]([A-Z0-9_]{3})[\]\)].*?\|[^A-Z>]*?([A-Z][\x20-\x2e|\x30-\x3b|=\?|A-Z|a-z]+)[^>\[\(]*[\[\(]([A-Z0-9_]{3})[\]\)].*/g, 1, function (){
		if ((arguments[2] != '1ED')&&(arguments[2].search(/^.ED/) != -1)) {
			BORDER = "_w";
		}else if ((arguments[2] == 'UNH')||(arguments[2] == 'UGL')) {
			BORDER = "_s";
		}else{
			BORDER = "_b";
		}
		var LA1 = arguments[1].replace(/[\+,':] */g, '_').replace(/ /g, '+');
		var LA3 = arguments[3].replace(/[\+,':] */g, '_').replace(/ /g, '+');
		dfc = dfc + 1;
		var dfca = "dfc" + dfc.toString() + "a";
		var dfcb = "dfc" + dfc.toString() + "b";

		return ('<img id="' + dfca + '" onclick="getElementById('+ "'" + dfca + "'" + ').style.display=' + "'" + "none" + "'" + '; getElementById(' + "'" + dfcb + "'" + ').style.display=' + "'" + "inline" + "'" + '; return false;" class="cii'+ BORDER +'" src="http://mtg-jp.com/cardlist/cards/' + arguments[2] + '/' + LA1 + '.jpg" alt="' + arguments[1] + '"><img id="' + dfcb + '" onclick="getElementById(' + "'" + dfcb + "'" + ').style.display=' + "'" + "none" + "'" + '; getElementById(' + "'" + dfca + "'" + ').style.display=' + "'" + "inline" + "'" + '; return false;" style="display: none" class="cii'+ BORDER +'" src="http://mtg-jp.com/cardlist/cards/' + arguments[4] + '/' + LA3 + '.jpg" alt="' + arguments[3] + '">');

	});

	reptxt(/《([^》\/／\(]+)[^》]*?》(?:\[\w+\])?/ig, 3, function(){
		if (arguments[1].search(/[A-Za-z]/) == -1){
			if (arguments[1].search(/[＋\+]/) == -1){
				return ('《<a class="cardlink" onmouseover="popUpCard(' + "'" + arguments[1] + "'" + ', arguments[0]);" onMouseOut="popDown()" href="http://mtg-jp.com/js/findcard.cgi?name=' + EscapeUTF8(arguments[1]).replace(/\%20/g, "+") + '" target="_blank">' + arguments[1] + '<\/a>》');
			}else{
				JAPs = arguments[1].split(/[＋\+]/);
				return ('《<a class="cardlink" onmouseover="popUpCard(' +"'"+ JAPs[0] +"'"+ ', arguments[0]);" onMouseOut="popDown()" href="http://mtg-jp.com/js/findcard.cgi?name=' + EscapeUTF8(JAPs[0]).replace(/\%20/g, "+") + '" target="_blank">' + JAPs[0] + '<\/a>＋<a class="cardlink" onmouseover="popUpCard(' +"'"+ JAPs[1] +"'"+ ', arguments[0]);" onMouseOut="popDown()" href="http://mtg-jp.com/js/findcard.cgi?name=' + EscapeUTF8(JAPs[1]).replace(/\%20/g, "+") + '" target="_blank">' + JAPs[1] + '<\/a>》');
			}
		}else{
			return ('《<a class="cardlink" onmouseover="popUpCard(' +"'"+ arguments[1].replace(/\'/, "\\\'") +"'"+ ', arguments[0]);" onMouseOut="popDown()" href="http://mtg-jp.com/js/findcard.cgi?name=' + EscapeUTF8(arguments[1]).replace(/\%20/g, "+") + '" target="_blank">' + arguments[1] + '<\/a>》');
		}
	});
	reptxt(/\{o?([WUBRGXYZC])\}/g, 0, '<img src="http://mtg-jp.com/img/mana/$1.png" alt="{$1}" style="vertical-align:middle; width:1em; height:1em;">');
	reptxt(/\{o?(\d+)\}/g, 0, '<img src="http://mtg-jp.com/img/mana/$1.png" alt="{$1}" style="vertical-align:middle; width:1em; height:1em;">');
	reptxt(/(\{([WUBRG2]).([WUBRGP])\})/g, 0, '<img src="http://mtg-jp.com/img/mana/$2$3.png" alt="$1" style="vertical-align:middle; width:1em; height:1em;">');
	reptxt(/\{(S|Snow|oS|Si)\}/g, 0, '<img src="http://mtg-jp.com/img/mana/Snow.png" alt="{S}" style="vertical-align:middle; width:1em; height:1em;">');
	reptxt(/\{(Tap|T)\}/g, 0, '<img src="http://mtg-jp.com/img/mana/Tap.png"  alt="{T}" style="vertical-align:middle; width:1em; height:1em;">');
	reptxt(/\{(Untap|Q)\}/g, 0, '<img src="http://mtg-jp.com/img/mana/Untap.png"  alt="{Q}" style="vertical-align:middle; width:1em; height:1em;">');
	reptxt(/\{PW\}/g, 0, '<img src="http://mtg-jp.com/img/mana/PW.png"  alt="{PW}" style="vertical-align:middle; width:1em; height:1em;">');
	reptxt(/\{CHAOS\}/gi, 0, '<img src="http://mtg-jp.com/img/mana/Chaos.png"  alt="{CHAOS}" style="vertical-align:middle; width:1em; height:1em;">');
	reptxt(/【観戦記事】/, 0, '<img src="http://coverage.mtg-jp.com/img/badge/match.png" class="badge" alt="【観戦記事】">');
	reptxt(/【お知らせ】/, 0, '<img src="http://coverage.mtg-jp.com/img/badge/publicity.png" class="badge" alt="【お知らせ】">');
	reptxt(/【戦略記事】/, 0, '<img src="http://coverage.mtg-jp.com/img/badge/strategy.png" class="badge" alt="【戦略記事】">');
	reptxt(/【トピック】/, 0, '<img src="http://coverage.mtg-jp.com/img/badge/topic.png" class="badge" alt="【トピック】">');
	reptxt(/【英語記事】/, 0, '<img src="http://coverage.mtg-jp.com/img/badge/english.png" class="badge" alt="【英語記事】">');
	reptxt(/【動画記事】/, 0, '<img src="http://coverage.mtg-jp.com/img/badge/video.png" class="badge" alt="【動画記事】">');



	var allTables = document.getElementsByTagName('table');
	for (i = 0, j = 0; i < allTables.length; i++){
		if (allTables[i].className == 'decklist'){
			if (allTables[i].caption != null){
				var lhref = document.location.href;
				if (lhref.toLowerCase().indexOf('cgi') == -1){
					allTables[i].caption.innerHTML = allTables[i].caption.innerHTML+'<a href="http://mtg-jp.com/js/decklist.cgi?caption=' + encodeURIComponent(allTables[i].caption.innerHTML) + '" target="_blank">[MO]<\/a><a href="http://mtg-jp.com/js/firsthand.cgi?caption=' + encodeURIComponent(allTables[i].caption.innerHTML) + '" target="_blank">[Hand]<\/a><\/caption>';
				}
			}
		}
	};
	reptxt(/http:/g, 2, "");
	var ahash = location.hash;
	location.hash = "";
	location.hash = ahash;

});

// 以上 オートリンクについて本気出して考えてみた より翻案
// Copyright (C) http://atab0u.blog105.fc2.com/blog-entry-33.html

function reptxt(from_r, type, to_str) {
	(function r(n) {
		var node = n.firstChild;
		while(node){
			if (node.nodeType == 1) {
				r(node);
			}else if (((type == 0)&&(node.nodeType == 3))||((type == 1)&&(node.nodeType == 8))) {
				if (node.nodeValue.match(from_r) != null){
					var newnode = document.createElement('span');
					newnode.innerHTML = node.nodeValue.replace(from_r, to_str);
					n.replaceChild(newnode, node);
					node = newnode;
				}
			}else if ((type == 2)&&(node.nodeType == 8)){
				if (node.nodeValue.match(from_r) != null){
					node.parentNode.href = node.nodeValue;
				}
			}else if ((type == 3)&&(node.nodeType == 3)&&(node.parentNode.getAttribute('href') == null)) {
				if (node.nodeValue.match(from_r) != null){
					var newnode = document.createElement('span');
					newnode.innerHTML = node.nodeValue.replace(from_r, to_str);
					n.replaceChild(newnode, node);
					node = newnode;
				}
			}
		node = node.nextSibling;
		}
	}(document.body));
}
//以上 http://muumoo.jp/news/2008/07/06/0autolinkjs.html より修整、転用


var EscapeUTF8=function(str){
	return str.replace(/[^*+.-9A-Z_a-z-]/g,function(s){
		var c=s.charCodeAt(0);
		return (c<16?"%0"+c.toString(16):c<128?"%"+c.toString(16):c<2048?"%"+(c>>6|192).toString(16)+"%"+(c&63|128).toString(16):"%"+(c>>12|224).toString(16)+"%"+(c>>6&63|128).toString(16)+"%"+(c&63|128).toString(16)).toUpperCase()
	})
};

//以上 Escape Codec Library: ecl.js (Ver.041208) より引用
// Copyright (C) http://nurucom-archives.hp.infoseek.co.jp/digital/
