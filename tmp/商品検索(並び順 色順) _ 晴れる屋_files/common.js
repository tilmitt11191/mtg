﻿/// <reference path="jquery.js"/>
jQuery.noConflict();

// global変数
var EC_WWW_ROOT = '';

// default charsetの設定
jQuery.ajaxSetup({ contentType: 'application/x-www-form-urlencoded; charset=utf-8' });

// util
function _ecUtil() {
    // ダブルクリック禁止処理
    this.ignoreDblClickFlag = null;

    // 郵便番号検索
    var timerId_lookupzip_ = null;
    var zipcache_lookupzip_ = '';

    // 全角半角変換
    this.hanMap = {};
    this.zenMap = {
        'ａ': 'a', 'ｂ': 'b', 'ｃ': 'c', 'ｄ': 'd', 'ｅ': 'e', 'ｆ': 'f', 'ｇ': 'g', 'ｈ': 'h', 'ｉ': 'i', 'ｊ': 'j',
        'ｋ': 'k', 'ｌ': 'l', 'ｍ': 'm', 'ｎ': 'n', 'ｏ': 'o', 'ｐ': 'p', 'ｑ': 'q', 'ｒ': 'r', 'ｓ': 's', 'ｔ': 't',
        'ｕ': 'u', 'ｖ': 'v', 'ｗ': 'w', 'ｘ': 'x', 'ｙ': 'y', 'ｚ': 'z', 'Ａ': 'A', 'Ｂ': 'B', 'Ｃ': 'C', 'Ｄ': 'D',
        'Ｅ': 'E', 'Ｆ': 'F', 'Ｇ': 'G', 'Ｈ': 'H', 'Ｉ': 'I', 'Ｊ': 'J', 'Ｋ': 'K', 'Ｌ': 'L', 'Ｍ': 'M', 'Ｎ': 'N',
        'Ｏ': 'O', 'Ｐ': 'P', 'Ｑ': 'Q', 'Ｒ': 'R', 'Ｓ': 'S', 'Ｔ': 'T', 'Ｕ': 'U', 'Ｖ': 'V', 'Ｗ': 'W', 'Ｘ': 'X',
        'Ｙ': 'Y', 'Ｚ': 'Z', '０': '0', '１': '1', '２': '2', '３': '3', '４': '4', '５': '5', '６': '6', '７': '7',
        '８': '8', '９': '9', '！': '!', '＠': '@', '＃': '#', '＄': '$', '％': '%', '＾': '^', '＆': '&', '＊': '*',
        '（': '(', '）': ')', '＿': '_', '＋': '+', '｜': '|', '￣': '~', '－': '-', '＝': '=', '￥': '\\', '｀': '`',
        '｛': '{', '｝': '}', '［': '[', '］': ']', '：': ':', '”': '"', '；': ';', '’': '\'', '＜': '<', '＞': '>',
        '？': '?', '，': ',', '．': '.', '／': '/', '。': '｡', '「': '｢', '」': '｣', '、': '､', '・': '･', 'ヲ': 'ｦ',
        'ァ': 'ｧ', 'ィ': 'ｨ', 'ゥ': 'ｩ', 'ェ': 'ｪ', 'ォ': 'ｫ', 'ャ': 'ｬ', 'ュ': 'ｭ', 'ョ': 'ｮ', 'ッ': 'ｯ', 'ー': 'ｰ',
        'ア': 'ｱ', 'イ': 'ｲ', 'ウ': 'ｳ', 'エ': 'ｴ', 'オ': 'ｵ', 'カ': 'ｶ', 'キ': 'ｷ', 'ク': 'ｸ', 'ケ': 'ｹ', 'コ': 'ｺ',
        'サ': 'ｻ', 'シ': 'ｼ', 'ス': 'ｽ', 'セ': 'ｾ', 'ソ': 'ｿ', 'タ': 'ﾀ', 'チ': 'ﾁ', 'ツ': 'ﾂ', 'テ': 'ﾃ', 'ト': 'ﾄ',
        'ナ': 'ﾅ', 'ニ': 'ﾆ', 'ヌ': 'ﾇ', 'ネ': 'ﾈ', 'ノ': 'ﾉ', 'ハ': 'ﾊ', 'ヒ': 'ﾋ', 'フ': 'ﾌ', 'ヘ': 'ﾍ', 'ホ': 'ﾎ',
        'マ': 'ﾏ', 'ミ': 'ﾐ', 'ム': 'ﾑ', 'メ': 'ﾒ', 'モ': 'ﾓ', 'ヤ': 'ﾔ', 'ユ': 'ﾕ', 'ヨ': 'ﾖ', 'ラ': 'ﾗ', 'リ': 'ﾘ',
        'ル': 'ﾙ', 'レ': 'ﾚ', 'ロ': 'ﾛ', 'ワ': 'ﾜ', 'ン': 'ﾝ', 'ガ': 'ｶﾞ', 'ギ': 'ｷﾞ', 'グ': 'ｸﾞ', 'ゲ': 'ｹﾞ', 'ゴ': 'ｺﾞ',
        'ザ': 'ｻﾞ', 'ジ': 'ｼﾞ', 'ズ': 'ｽﾞ', 'ゼ': 'ｾﾞ', 'ゾ': 'ｿﾞ', 'ダ': 'ﾀﾞ', 'ヂ': 'ﾁﾞ', 'ヅ': 'ﾂﾞ', 'デ': 'ﾃﾞ', 'ド': 'ﾄﾞ',
        'バ': 'ﾊﾞ', 'パ': 'ﾊﾟ', 'ビ': 'ﾋﾞ', 'ピ': 'ﾋﾟ', 'ブ': 'ﾌﾞ', 'プ': 'ﾌﾟ', 'ベ': 'ﾍﾞ', 'ペ': 'ﾍﾟ', 'ボ': 'ﾎﾞ', 'ポ': 'ﾎﾟ',
        'ヴ': 'ｳﾞ', '゛': 'ﾞ', '゜': 'ﾟ', '　': ' '
    };

    // 半角->全角マップ
    for (var key in this.zenMap) {
        if (!this.hanMap[this.zenMap[key]]) {
            this.hanMap[this.zenMap[key]] = key;
        }
    }

    // 半角<->全角変換
    this.strConvert = function(obj, isHanToZen) {
        if (obj.value == obj.getAttribute("title")){
            return true;
        }
        var str = obj.value;
        var conv = '';
        var map = isHanToZen ? this.hanMap : this.zenMap;

        for (var i = 0; i < str.length; i++) {
            var tmp = '';
            if (i < str.length - 1) {
                tmp = str.substring(i, i + 2);
            }
            if (map[tmp]) {
                conv += map[tmp];
                i++;
                continue;
            } else {
                tmp = str.substring(i, i + 1);
                conv += map[tmp] ? map[tmp] : tmp;
            }
        }
        obj.value = conv;
        return true;
    }

    // ダブルクリック（連続ポスト）の制御
    this.ignoreDblClick = function() {
        if (this.ignoreDblClickFlag == null) {
            this.ignoreDblClickFlag = 1;
            return true;
        } else {
            return false;
        }
    }

    // htmlタグの置き換え
    this.htmlspecialchars = function(str) {
        if (!str || str == '') { return ''; }
        str = str.replace(/&/g, '&amp;');
        str = str.replace(/"/g, '&quot;');
        str = str.replace(/'/g, '&#039;');
        str = str.replace(/</g, '&lt;');
        str = str.replace(/>/g, '&gt;');
        return str;
    }

    // 郵便番号検索
    this.lookupZipInit = function(zip, pref, addr, addr2, cnt, offset) {
        var defaultXOffset = 90;
        var timerOffset = 300;

        var zip_id = '#' + zip + cnt;
        var pref_id = '#' + pref + cnt;
        var addr_id = '#' + addr + cnt;
        var addr2_id = '#' + addr2 + cnt;

        offset = offset + defaultXOffset;
        jQuery(zip_id).bind('keyup', function() {
            jQuery('ul.ziplist_').remove();

            if (zipcache_lookupzip_ == jQuery(zip_id).val()) {
                zipcache_lookupzip_ = jQuery(zip_id).val();
                return false;
            }
            zipcache_lookupzip_ = jQuery(zip_id).val();

            clearTimeout(timerId_lookupzip_);
            timerId_lookupzip_ = setTimeout(function() {
                if (!jQuery(zip_id).val().match(/^[0-9]{3}[\-]{0,1}[0-9]{0,4}$/)) {
                    return true;
                }
                jQuery.get('../search/lookupzipjson.aspx',
                  {
                      zip: jQuery(zip_id).val(),
                      charset: 'utf-8'
                  },
                function(data, status) {
                    var of = jQuery(zip_id).offset();
                    var ul = jQuery('<ul></ul>').addClass('ziplist_');
                    ul.css('top', of.top);
                    ul.css('left', of.left + offset);

                    var searchCount = 0;
                    var tempzip, temppref, tempaddr, tempaddr2;
                    jQuery.each(data, function(key, item) {
                        searchCount++;
                        tempzip = item.zip;
                        temppref = item.pref;
                        tempaddr = item.addr;
                        tempaddr2 = item.addr2;

                        var li = jQuery('<li>' + key + ' ' + item.pref + ' ' + item.addr + ' ' + item.addr2 + '</li>');
                        li.bind('click', function() {
                            jQuery(zip_id).val(item.zip);
                            jQuery(pref_id).val(item.pref);
                            jQuery(addr_id).val(item.addr);
                            jQuery(addr2_id).val(item.addr2);
                            jQuery('ul.ziplist_').remove();
                            jQuery(zip_id).blur();
                            jQuery(pref_id).change();
                            jQuery(addr_id).focus();
                            jQuery(addr2_id).blur().focus();
                            return false;
                        });
                        li.bind('mouseover', function() { li.addClass('hover'); });
                        li.bind('mouseleave', function() { li.removeClass('hover'); });
                        ul.append(li);
                    });

                    if ((searchCount == 1) && (zipcache_lookupzip_.replace("-","").length == 7)) {
                        jQuery(zip_id).val(tempzip);
                        jQuery(pref_id).val(temppref);
                        jQuery(addr_id).val(tempaddr);
                        jQuery(addr2_id).val(tempaddr2);
                        jQuery('ul.ziplist_').remove();
                        jQuery(zip_id).blur();
                        jQuery(pref_id).change();
                        jQuery(addr_id).focus();
                        jQuery(addr2_id).blur().focus();
                        return false;
                    } else if (searchCount != 0) {
                        jQuery(document.body).append(ul);
                    }
                }, 'json'
                );
            }, timerOffset);
        });
    }

    // 汎用入力チェック
    this.confirmInputCheck = function() {
        // メールアドレスチェック
        if (jQuery('#mail').size() == 1 && jQuery('#cmail').size() == 1) {
            if (jQuery('#mail').val() != jQuery('#cmail').val()) {
                alert('メールアドレスとメールアドレス（確認）が一致しません');
                ecUtil.ignoreDblClickFlag = false;
                return false;
            }
        }

        // メールアドレスチェック２
        if (jQuery('#newmail1').size() == 1 && jQuery('#newmail2').size() == 1) {
            if (jQuery('#newmail1').val() != jQuery('#newmail2').val()) {
                alert('メールアドレスとメールアドレス（確認）が一致しません');
                ecUtil.ignoreDblClickFlag = false;
                return false;
            }
        }

        // パスワードチェック
        if (jQuery('#pwd').size() == 1 && jQuery('#cpwd').size() == 1) {
            if (jQuery('#pwd').val() != jQuery('#cpwd').val()) {
                alert('入力されたパスワードと確認用パスワードが一致しません');
                ecUtil.ignoreDblClickFlag = false;
                return false;
            }
        }

        // パスワードチェック2
        if (jQuery('#npwd1').size() == 1 && jQuery('#npwd2').size() == 1) {
            if (jQuery('#npwd1').val() != jQuery('#npwd2').val()) {
                alert('入力されたパスワードと確認用パスワードが一致しません');
                ecUtil.ignoreDblClickFlag = false;
                return false;
            }
        }

        // IDチェック
        if (jQuery('#newid1').size() == 1 && jQuery('#newid2').size() == 1) {
            if (jQuery('#newid1').val() != jQuery('#newid2').val()) {
                alert('入力されたIDと確認用IDが一致しません');
                ecUtil.ignoreDblClickFlag = false;
                return false;
            }
        }
        
        // IDとPASSの不一致確認
        if (jQuery('#uid').size() == 1 && jQuery('#pwd').size() == 1) {
            if (jQuery('#uid').val() != "" && jQuery('#pwd').val() != "" ) {
	            if (jQuery('#uid').val() == jQuery('#pwd').val()) {
	                alert('会員IDとパスワードは別々のものを指定してください');
	                jQuery('#pwd').val('');
	                jQuery('#cpwd').val('');
	                ecUtil.ignoreDblClickFlag = false;
	                return false;
	            }
			}
	    }
        
        return true;
    }

}

var ecUtil = new _ecUtil();

function ReplaceChar(input_id){
  var target_id = '#' + input_id;
  var buf;
  if (jQuery(target_id).size() > 0){
    buf = jQuery(target_id).val();
    buf = buf.replace(/'/g, ' ');
    buf = buf.replace(/à/g, 'a');
    buf = buf.replace(/á/g, 'a');
    buf = buf.replace(/â/g, 'a');
    buf = buf.replace(/í/g, 'i');
    buf = buf.replace(/ú/g, 'u');
    buf = buf.replace(/û/g, 'u');
    buf = buf.replace(/é/g, 'e');
    buf = buf.replace(/ö/g, 'o');
    buf = buf.replace(/À/g, 'A');
    buf = buf.replace(/Á/g, 'A');
    buf = buf.replace(/Â/g, 'A');
    buf = buf.replace(/Í/g, 'I');
    buf = buf.replace(/Ú/g, 'U');
    buf = buf.replace(/Û/g, 'U');
    buf = buf.replace(/É/g, 'E');
    buf = buf.replace(/Ö/g, 'O');
    jQuery(target_id).val(buf);
  }
  return true;
}

function ReplaceChar_QuotDelete(input_id){
  var target_id = '#' + input_id;
  var buf;
  if (jQuery(target_id).size() > 0){
    buf = jQuery(target_id).val();
    buf = buf.replace(/'/g, '');
    buf = buf.replace(/à/g, 'a');
    buf = buf.replace(/á/g, 'a');
    buf = buf.replace(/â/g, 'a');
    buf = buf.replace(/í/g, 'i');
    buf = buf.replace(/ú/g, 'u');
    buf = buf.replace(/û/g, 'u');
    buf = buf.replace(/é/g, 'e');
    buf = buf.replace(/ö/g, 'o');
    buf = buf.replace(/À/g, 'A');
    buf = buf.replace(/Á/g, 'A');
    buf = buf.replace(/Â/g, 'A');
    buf = buf.replace(/Í/g, 'I');
    buf = buf.replace(/Ú/g, 'U');
    buf = buf.replace(/Û/g, 'U');
    buf = buf.replace(/É/g, 'E');
    buf = buf.replace(/Ö/g, 'O');
    jQuery(target_id).val(buf);
  }
  return true;
}
