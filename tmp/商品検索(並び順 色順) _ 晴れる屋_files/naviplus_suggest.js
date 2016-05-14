/*
--------------------------------------------------------
naviplus_suggest.js
--------------------------------------------------------
*/

/*-- NPSuggest ---------------------------------*/
NPSuggest = {}
NPSuggest.currentIndex = 0;
NPSuggest.currentKeyword = "";

// 以下はNPSuggest_createItemList_htmlでのみ使用
NPSuggest.currentRecommendList = null;
NPSuggest.currentRequest = null;
NPSuggest.currentColumn = null;

/*-- NPSuggest.Request ------------------------*/
NPSuggest.requests = [];

NPSuggest.Request = function(options, sources, columns, version) {
	this.requestIndex = NPSuggest.requests.length;
	this.search = new NPSuggest.SearchRequest(options, sources, columns, this.requestIndex, version);

	NPSuggest.requests.push(this);
};

// 商品検索にアクセスする部分
NPSuggest.SearchRequest = function(options, sources, columns, requestIndex, version) {
	this.options = options;
	this.sources = sources;
	this.columns = columns;
	this.requestIndex = requestIndex;
	this.version = version;
	this._lastRequestInput = null;
	this._lastRequestCategory = "";
	this._lastRequestField = "";
	this._suggestKeywordList = [];
	this._suggestItemList = [];
}

NPSuggest.SearchRequest.prototype = {
	_getSendScript : function(action,params,callback) {
		var server = this.sources.search.server;
		if (server == null || server.length == 0) {
			server = window.location.host;
		}
		var root = (document.location.protocol=="https:"?"https://":"http://") + server + "/~" + encodeURIComponent(this.sources.search.accountID) + "/";
		var script = document.createElement("script");
		script.setAttribute("type", "text/javascript");
		script.setAttribute("language", "JavaScript");
		script.setAttribute("charset", "UTF-8");
		var query = "";
		for (var key in params) {
			if (typeof(params[key]) != 'function')
				query += ("&"+key+"="+encodeURIComponent(params[key]));
		}
		if (callback==null) {
			script.setAttribute("src", root+"?action="+encodeURIComponent(action)+query+"&dummy="+String(new Date().getTime()));
		} else {
			script.setAttribute("src", root+"?action="+encodeURIComponent(action)+query+"&callback="+encodeURIComponent(callback)+"&dummy="+String(new Date().getTime()));
		}
		script.onload = script.onreadystatechange = null;
		return script;
	},

	createSuggestItemList : function(keyword, categoryName, category, fieldName, callback, position) {
		if (typeof callback == "undefined")
			callback = null;

		var column = null;
		var itemid_html = false;
		if (fieldName == "itemid_html") {
			if (NPSuggest.currentColumn) {
				column = NPSuggest.currentColumn;
			}
			itemid_html = true;
		} else if (typeof(this.columns[fieldName]) != "undefined") {
			column = this.columns[fieldName];
		}

		var kc = keyword+"::"+category+"::"+fieldName;
		if (typeof this._suggestItemList[kc] == "undefined") {
			this._suggestItemList[keyword+"::"+category] = {"result":{"items":{"item":[]}}};
			var q = [];
			if(typeof(column) != "undefined" && column != null) {
				// ソート順
				if(position == "lower" && typeof(column.lowerSort) != "undefined") {
					q["sort"] = column.lowerSort;
				} else if(typeof(column.upperSort) != "undefined") {
					q["sort"] = column.upperSort;
				} else {
					q["sort"] = this.options.recommendItemSort;
				}

				// データ返却形式
				if (this.version == 2) {		// v2はhtmlがデフォルト
					q["fmt"] = "html";

					// HTML連携時のみテンプレート指定を有効にする
					if (position == "lower") {
						q["with_hitnum"] = 1;		// DOMでhitnumを受け取る
						if (typeof(column.lowerTmpl) != "undefined"){
							q["tmpl"] = column.lowerTmpl;
						}
					} else {
						q["with_first_itemid"] = 1;		// DOMでitemidを受け取る
						if (typeof(column.upperTmpl) != "undefined"){
							q["tmpl"] = column.upperTmpl;
						}
					}
				} else {		// v1はJSONPがデフォルト
					q["fmt"] = "jsonp";
				}
				q["fieldName"] = fieldName;

				if (itemid_html) {		// JS（HTML）連携の特別パターン
					q["fieldName"] = "itemid";
				}
			} else {
				q["sort"] = this.options.recommendItemSort;
				q["fmt"] = "jsonp";
				q["fieldName"] = fieldName;
			}			
			if (categoryName != "undefined" && categoryName.length > 0 && category.length > 0) {
				q[categoryName] = category;
			}
			if (fieldName != "undefined" && fieldName.length > 0) {
				if (fieldName == "title") {
					q["t"] = keyword;		// 完全一致なのでnormalize前を使う
				} else if (fieldName == "path") {
					q["path"] = keyword;		// 完全一致なのでnormalize前を使う
				} else if (fieldName.search(/keyword/) == 0) {
					q[fieldName.replace("keyword", "k")] = keyword;		// 完全一致なのでnormalize前を使う
				} else if (fieldName.search(/narrow/) == 0) {
					q[fieldName.replace("narrow", "s")] = keyword;		// 完全一致なのでnormalize前を使う
				} else if (fieldName == "itemid" || fieldName == "itemid_html") {		// テキストマイニングに向けた仕込み
					q["tm"] = keyword;
				} else {
					q["q"] = NPSuggest.Util.normalizeKeyword(keyword);
				}
			} else {
				q["q"] = NPSuggest.Util.normalizeKeyword(keyword);
			}
			q["fieldValue"] = keyword;
			kc = kc.replace('\\', '\\\\').replace('"', '\\"');
			var script = this._getSendScript("suggestitem", q,
					"NPSuggest.requests[" + this.requestIndex + "].search._suggestItemList[\""+kc+"\"]=");
			document.getElementsByTagName("head")[0].appendChild(script);
			script.onload = callback;
			script.onreadystatechange =
					function(){if(this.readyState=="loaded"||this.readyState=="complete"){callback.call();}}
		} else {
			if (callback != null) callback.call();
		}
	},
	getSuggestItemList : function(keyword,category,fieldName, type) {
		var kc = keyword+"::"+category+"::"+fieldName;
		if (typeof this._suggestItemList[kc] == "undefined") {
			return null;
		}
		if (type == "html") {
			return this._suggestItemList[kc];
		} else {
			return this._suggestItemList[kc].kotohaco.result.items;
		}
	},
	getSuggestItemInfo : function(keyword,category,fieldName) {
		var kc = keyword+"::"+category+"::"+fieldName;
		if (typeof this._suggestItemList[kc] == "undefined") {
			return null;
		}
		return this._suggestItemList[kc].kotohaco.result.info;
	},

	createSuggestKeywordList : function(text, category, field, callback) {
		if (typeof callback == "undefined")
			callback = null;

		//test
		if (text === "######") {
			this._suggestKeywordList[text] = {"result":{"info":{"hitnum":20},"keywords":[]}};
			for (var i=0;i<20;i++) {
				this._suggestKeywordList[text].result.keywords[i] = {"surface":"######"+String(i+1),"index":"######"+String(i+1)};
			}
			this._lastRequestInput = text;
			this._lastRequestCategory = category;
			this._lastRequestField = field;
			if (callback != null) callback.call();
			return;
		}

		var isSuggest = true; // サジェストするかどうか

		if (text.length == 1 && text.match("[\u3400-\u4DBF\u4E00-\u9FFF\uF900-\uFAFF]|[\uD840-\uD87F][\uDC00-\uDFFF]")) {
			// 漢字の場合はminimumCharに関係なく1文字目からサジェストする
			isSuggest = true;
		} else if (this.options.minimumChar > 0) {		// minimumCharが指定されている場合
			if (text.length >= this.options.minimumChar) {
				isSuggest = true;
			} else {
				isSuggest = false;
			}
		} else {	// minimumCharが指定されていない場合のデフォルト
			if (text.match(/^[0-9\uFF10-\uFF19]+$/)) { // numeric
				if (text.length >= 3) {
					isSuggest = true;
				} else {
					isSuggest = false;
				}
			} else {
				if (text.length >= 2) {
					isSuggest = true;
				} else {
					isSuggest = false;
				}
			}
		}
		if (!isSuggest) {
			this._suggestKeywordList = [];
			this._lastRequestInput = null;
			this._lastRequestCategory = "";
			this._lastRequestField = "";
			if (callback != null) callback.call();
			return;
		}

		if (this._lastRequestCategory === category && this._lastRequestField === field
				&& this._lastRequestInput != null
				&& text in this._suggestKeywordList
				&& this._suggestKeywordList[text].result.keywords
				&& this._suggestKeywordList[text].result.keywords.length < 250
				&& !(this._lastRequestInput.length==1 && this._lastRequestInput.match("[\u3040-\u309F]|[\u30A0-\u30FF]|[a-zA-Zａ-ｚＡ-Ｚ]"))) {
			if (callback != null) callback.call();
		} else {
			this._suggestKeywordList[text] = {"result":{"info":{"hitnum":0},"keywords":[]}};
			var text2 = text.replace('\\', '\\\\').replace('"', '\\"');
			var script = this._getSendScript("suggest",
				{"keyword":text,"category":category,"field":field,"match_mode":this.options.matchMode,
				 "sort":this.options.sortType, "furigana":this.options.furigana},
				"NPSuggest.requests[" + this.requestIndex + "].search._suggestKeywordList[\"" + text2 + "\"]=");
			document.getElementsByTagName("head")[0].appendChild(script);
			script.onload = script.onreadystatechange = callback;
			this._lastRequestInput = text;
			this._lastRequestCategory = category;
			this._lastRequestField = field;
		}
	},

	getCandidateKeywordList : function(text) {
		if (this._suggestKeywordList == null) {
			return [];
		} else if(text in this._suggestKeywordList) {
			return this._suggestKeywordList[text].result.keywords;
		} else {
			return [];
		}
	},
	getResultInfo : function(text) {
		if (this._suggestKeywordList == null) {
			return [];
		} else if(text in this._suggestKeywordList) {
			return this._suggestKeywordList[text].result.info;
		} else {
			return [];
		}
	},

	// サーチ経由でレコメンドを呼ぶ
	createRecommendItemList: function(reco_server, account, keyword, column, callback) {
		if (typeof callback == "undefined")
			callback = null;

		// レコメンド系ではcategoryは使えないので無視＋fieldNameは「recommend」で固定
		var kc = keyword+"::::recommend";
		if (typeof this._suggestItemList[kc] == "undefined") {
			this._suggestItemList[keyword] = {"result":{"items":{"item":[]}}};
			var k = NPSuggest.Util.normalizeKeyword(keyword);
			var q = [];
			NPSuggest.currentIndex = this.requestIndex;
			NPSuggest.currentKeyword = k;
			q["server"] = reco_server;
			q["k"] = account;
			q["q"] = keyword;
			if(typeof(column) != "undefined" && typeof(column.recommendBase) != "undefined") {
				// テンプレート番号
				if (typeof(column.recommendTmpl) != "undefined") {
					q["recotmpl"] = column.recommendTmpl;
				}
				// apiの値によってパラメータが異なる
				var api = column.recommendBase;
				q["type"] = api;

				// データ返却形式とテンプレート
				q["fmt"] = "html";			// 固定（このメソッドはv2でしか使わないので）
				q["with_hitnum"] = 1;		// DOMでhitnumを受け取る
				if (typeof(column.lowerTmpl) != "undefined"){
					q["tmpl"] = column.lowerTmpl;
				}
			}

			kc = kc.replace('\\', '\\\\').replace('"', '\\"');
			var script = this._getSendScript("recommend", q,
					"NPSuggest.requests[" + this.requestIndex + "].search._suggestItemList[\""+kc+"\"]=");
			document.getElementsByTagName("head")[0].appendChild(script);
			script.onload = callback;
			script.onreadystatechange =
					function(){if(this.readyState=="loaded"||this.readyState=="complete"){callback.call();}}
		} else {
			if (callback != null) callback.call();
		}
	},
}

/*-- NPSuggest.Event --------------------------*/
NPSuggest.Event = {
	add: (window.addEventListener ?
			function(element, type, func) {
				element.addEventListener(type, func, false);
			} :
			function(element, type, func) {
				element.attachEvent('on' + type, func);
	}),
	stop: function(event) {
		if (event.preventDefault) {
			event.preventDefault();
			event.stopPropagation();
		} else {
			event.returnValue = false;
			event.cancelBubble = true;
		}
	},
	getElement: function(event) {
		return event.target || event.srcElement;
	},
	getCurrentElement: function(event) {
		return event.currentTarget || event.srcElement;
	}
}
/*-- NPSuggest.Timer --------------------------*/
NPSuggest.Timer = function() {}
NPSuggest.Timer.prototype = {
	timerId: null,
	set: function(func ,msec) {
		if (this.timerId) clearTimeout(this.timerId);
		this.timerId = null;
		this.timerId = setTimeout(func ,msec);
	},
	clear: function() {
		if (this.timerId) clearTimeout(this.timerId);
		this.timerId = null;
	},
	hasTask: function() {
		if (this.timerId) return true;
		else return false;
	}
}

/*-- NPSuggest.Controller --------------------------*/
NPSuggest.Controller = function() {
	this.initialize.apply(this, arguments);
};
NPSuggest.Controller.prototype = {
	interval: 300,
	defaultOptions: {
		server: '',
		accountID: '',
		inputAreaID: '',
		submitBtnID: '',
		categoryAreaID: '',
		fieldAreaID: '',
		field: '',
		categoryName: '', // s1 など
		suggestAreaClass: 'np-keyword-suggest',
		itemListClass: 'np-item-suggest',
		maxSuggest: 10,
		matchMode: 'prefix',
		groupByCategory: false,
		alwaysOnTop: false,
		sortType: 1,
		minimumChar: -1,
		overlayMode: 'off',
		overlayPlaceHolder: '',
		furigana: true,
		suggestHighlight: 'off',
		recommendItemEnabled: 'off',
		recommendItemTiming: 'mouseover',
		recommendItemAreaTitle: 'Top Results',
		recommendItemAreaPosition: 'right',
		recommendItemSort: 'Score',
		recommendItemHtmlEnabled: false,
		recommendItemLimitWidth: -1,
		recommendItemLimitHeight: -1,
		recommendItemUrlPrefix: '',
		recommendImageUrlPrefix: '',
		recommendImageAlternative: '',
		sources: {
			search: {
				server: '',
				accountID: '',
			},
			recommend: {
				server: '',
				accountID: '',
			},
		},
		columns: {
		},
	},

	initialize: function(options) {
		this.keywordSuggestTaskTimer = new NPSuggest.Timer();
		this.itemRecommendTaskTimer = new NPSuggest.Timer();
		this.compositionTaskTimer = new NPSuggest.Timer();
		this.options = {};
		this.sources = {};
		this.columns = {};
		this.version = 1;			// デフォルトのバージョン
		for (name in this.defaultOptions) {
			if (typeof(options[name]) != 'undefined') {
				if (name == "sources") {
					this.version = 2;		// sourcesがあればVer.2とみなす
					for (name2 in this.defaultOptions.sources) {
						// ただのイコールだと参照渡しされてしまうので、値渡しのためJSONに一度変換する
						this.sources[name2] = JSON.parse(JSON.stringify(this.defaultOptions.sources[name2]));
						if (typeof(options.sources) != 'undefined' && typeof(options.sources[name2]) != 'undefined') {
							for (name3 in this.defaultOptions.sources[name2]) {
								if (typeof(options.sources[name2][name3]) != 'undefined') {
									this.sources[name2][name3] = options.sources[name2][name3];
								}
							}
						}
					}
				} else if (name == "columns") {
					// スマサジェの各項目ごとのパラメータ設定
					this.version = 2;		// columnsがあればVer.2とみなす

					// ただのイコールだと参照渡しされてしまうので、値渡しのためJSONに一度変換する
					this.columns = JSON.parse(JSON.stringify(options[name]));
					for(name in this.columns) {
						var column = this.columns[name];
						if (typeof(column) != 'undefined') {
							// デフォルト値を設定
							if (typeof(column['upperSort']) == 'undefined') {
								column.upperSort = this.options.recommendItemSort;		// 旧仕様のsortを引き継ぐ
							}
							if (typeof(column['lowerSort']) == 'undefined') {
								column.lowerSort = '';
							}
							if (typeof(column['recommendBase']) == 'undefined') {
								column.recommendBase = 'keyword';
							}
							if (typeof(column['recommendTmpl']) == 'undefined') {
								column.recommendTmpl = 0;
		 					}
						}
						this.columns[name] = column;
					}
				} else {
					this.options[name] = options[name];
				}
			} else {
				if (name == "sources") {
					// ただのイコールだと参照渡しされてしまうので、値渡しのためJSONに一度変換する
					this.sources = JSON.parse(JSON.stringify(this.defaultOptions[name]));
				} else if (name == "columns") {
					// defaultが空なので何もしない
				} else {
					this.options[name] = this.defaultOptions[name];
				}
			}
		}

		// 既存サジェストとの互換性確保のため
		if (this.version == 1 && typeof(options['server']) != 'undefined') {
			this.sources.search.server = options.server;
		}
		if (this.version == 1 && typeof(options['accountID']) != 'undefined') {
			this.sources.search.accountID = options.accountID;
		}
		if (this.version >= 2 && typeof(options['itemListClass']) == 'undefined') {
			this.options.itemListClass = 'np-item-suggest-v2';			// Ver.1とVer.2のCSSを1ファイルにまとめるため、デフォルトのクラスを変更
		}

		this.request = new NPSuggest.Request(this.options, this.sources, this.columns, this.version);

		// input area
		this.input = NPSuggest.Util.getElement(this.options.inputAreaID);
		if (typeof(this.input)=="undefined" || this.input==null) {
			this.input = document.createElement("input"); // dummy object
		}

		// suggest area
		this.suggestArea = document.createElement("div");
		this.suggestArea.className = this.options.suggestAreaClass;
		if (this._isOverlay()) {
			var w = Math.max(document.body.clientWidth, document.body.scrollWidth, document.documentElement.scrollWidth, document.documentElement.clientWidth);
			this.suggestArea.style.width = w + 'px';
			var h = Math.max(document.body.clientHeight, document.body.scrollHeight, document.documentElement.scrollHeight, document.documentElement.clientHeight);
			this.suggestArea.style.height = h + 'px';
			document.body.appendChild(this.suggestArea);
			this.suggestArea.className += " " + this.options.suggestAreaClass + "_overlay";		// suffix
		} else if (this.options.alwaysOnTop == true || this.options.alwaysOnTop == 'on') {
			document.body.appendChild(this.suggestArea);
		} else {
			this.input.parentNode.appendChild(this.suggestArea);
		}

		// item recommend area
		this.itemListArea = document.createElement("div");
		this.itemListArea.className = this.options.itemListClass;
		if (this.options.alwaysOnTop == true || this.options.alwaysOnTop == 'on') {
			document.body.appendChild(this.itemListArea);
		} else {
			this.input.parentNode.appendChild(this.itemListArea);
		}

		// category area
		this.categoryArea = NPSuggest.Util.getElement(this.options.categoryAreaID);
		if (typeof(this.categoryArea)=="undefined" || this.categoryArea==null)
			this.categoryArea = document.createElement("input"); // dummy object

		// field area
		this.fieldArea = NPSuggest.Util.getElement(this.options.fieldAreaID);
		if (typeof(this.fieldArea)=="undefined" || this.fieldArea==null)
			this.field = this.options.field;

		// init value
		this.candidateList = null;
		this.oldText = this.getInputText();
		this.oldCategory = this.getInputCategory();
		this.oldField = this.getInputField();
		this.groupByField = false;
		this.compositionStatus = false;
		this.keywordBackup = '';

		// add event
		if (this._isOverlay()) {
			NPSuggest.Event.add(this.input, 'focus', this._bind(this.createOverlayArea));
			// 実機だとブラウザバック時にサジェストが表示されっぱなしになることがあるので修正
			NPSuggest.Event.add(window, 'beforeunload', this._bind(this.clearOverlayArea, true));
		} else {
			NPSuggest.Event.add(this.input, 'focus', this._bind(this.checkLoop));
			NPSuggest.Event.add(this.input, 'blur', this._bind(this.inputBlur));

			var keyevent = NPSuggest.Util.getKeyEvent();
			NPSuggest.Event.add(this.input, keyevent, this._bindEvent(this.keyEvent));

			NPSuggest.Event.add(this.input, 'compositionstart', this._bindEvent(this.compositionStartEvent));
			NPSuggest.Event.add(this.input, 'compositionend', this._bindEvent(this.compositionEndEvent));

			// resize event
			NPSuggest.Event.add(window, 'resize', this._bind(this._onWindowResize, true));
		}

		var submitBtn = NPSuggest.Util.getElement(this.options.submitBtnID);
		if (typeof(submitBtn)=="undefined" || submitBtn==null) {
			submitBtn = document.createElement("input"); // dummy object
		}

		// init
		this.clearSuggestArea(true);
	},

	createKeywordList: function(text, category, field) {
		this.candidateList = [];
		this.request.search.createSuggestKeywordList(text, category, field, this._bind(this.setCandidateList, text));
	},

	setCandidateList: function(text) {
		this.candidateList = this.request.search.getCandidateKeywordList(text);
		var info = this.request.search.getResultInfo(text);
		if (typeof(info.group_by_field) != "undefined") {
			this.groupByField = info.group_by_field;
		}
	},

	createItemList: function(index) {
		if (this.options.recommendItemEnabled == false || this.options.recommendItemEnabled === 'off') {		// offのとき以外はデータ取得する
			return;
		}
		var categoryName = this.options.categoryName;
		var category = this.getInputCategory();
		if (this.activePosition === index) {
			this.clearRecommendItemArea();
			var element = this.suggestList[index];
			var keyword = NPSuggest.Util.getSuggestValue(element, "value");
			var fieldName = "";
			if (element && "field" in element) {
				fieldName = element.field;
			}
			this.request.search.createSuggestItemList(keyword, categoryName, category, fieldName, this._bind(this.createRecommendItemArea ,keyword ,category), 'upper');
		} else if (index < 0) {
			if (this.resultList.length <= 0) {
				this.clearRecommendItemArea(true);
				return;
			}
			this.clearRecommendItemArea();
			var element = this.suggestList[0];
			var keyword = NPSuggest.Util.getSuggestValue(element, "value");
			var fieldName = "";
			if ("field" in element) {
				fieldName = element.field;
			}
			this.request.search.createSuggestItemList(keyword, categoryName, category, fieldName, this._bind(this.createRecommendItemArea ,keyword ,category), 'upper');
		}
	},

	createRecommendItemArea: function(keyword, category) {
		if (this._isOverlay()) {
			return;
		}

		var fieldName = "";
		if (this.options.recommendItemTiming == 'input' && this.activePosition == null) {
			if (this.suggestList == "undefined" || this.suggestList == null || this.suggestList.length <= 0) {
				return;
			}
			var element = this.suggestList[0];
			var k = NPSuggest.Util.getSuggestValue(element, "value");
			if (keyword != k) {
				return;
			}
			if (element && "field" in element) {
				fieldName = element.field;
			}
		} else {
			if(this.activePosition == null) {
				return;
			}
			var element = this.suggestList[this.activePosition];
			var k = NPSuggest.Util.getSuggestValue(element, "value");
			if (keyword != k) {
				return;
			}
			if (element && "field" in element) {
				fieldName = element.field;
			}
		}
		var column = null;
		if (typeof(this.columns[fieldName]) != "undefined") {
			column = this.columns[fieldName];
		}

		if (this.version >= 2 && column != null){
			var html = this.request.search.getSuggestItemList(keyword, category, fieldName, "html");
			if (typeof html == "string" && html != null) {
				if (typeof NPSuggest_createItemList_html == "function") {
					var contents2 = NPSuggest_createItemList_html(keyword, fieldName, html, this.options, this.request, column)
					if (typeof contents2 == "string") {
						this.itemListArea.innerHTML = contents2;
					} else {
						for (var i=this.itemListArea.childNodes.length-1; i>=0; i--) {
							this.itemListArea.removeChild(this.itemListArea.childNodes[i]);
						}
						this.itemListArea.appendChild(contents2);
					}
				} else {
					this.itemListArea.innerHTML = html;
				}
				if (this._isItemAreaEnabled()) {
					this.itemListArea.style.display = 'block';
				}
			} else {
				this.clearRecommendItemArea(true);
			}
		} else {
			var items = this.request.search.getSuggestItemList(keyword, category, fieldName);
			var info = this.request.search.getSuggestItemInfo(keyword, category, fieldName);
			if (items.length > 0) {
				if (typeof NPSuggest_createItemList == "function") {
					var contents = NPSuggest_createItemList(items, this.options.recommendItemAreaTitle, this.options, info);
					if (typeof contents == "string") {
						this.itemListArea.innerHTML = contents;
					} else {
						for (var i=this.itemListArea.childNodes.length-1; i>=0; i--) {
							this.itemListArea.removeChild(this.itemListArea.childNodes[i]);
						}
						this.itemListArea.appendChild(contents);
					}
					if (this._isItemAreaEnabled()) {
						this.itemListArea.style.display = 'block';
					}
				}
			} else {
				this.clearRecommendItemArea(true);
			}
		}
	},

	clearRecommendItemArea: function(forceClear) {
		if (forceClear == true || this.options.recommendItemTiming != 'input') {
			this.itemListArea.innerHTML = "";
			this.itemListArea.style.display = 'none';
		}
	},

	inputBlur: function() {
		this.changeUnactive();
		this.oldText = this.getInputText();
		this.keywordSuggestTaskTimer.set(this._bind(this.clearSuggestArea, true), 500);
	},

	checkLoop: function() {
		if (this.options.maxSuggest <= 0) {
			return;
		}

		var text = this.getInputText();
		var category = this.getInputCategory();
		var field = this.getInputField();
		if (text != this.oldText || category != this.oldCategory || field != this.oldField) {
			this.oldText = text;
			this.oldCategory = category;
			this.oldField = field;
			this.createKeywordList(text, category, field);
			if (this.candidateList != null && this.candidateList.length>0) {
				this.search();
				if (this.options.recommendItemTiming == 'input' && !this._isOverlay()) {
					this.itemRecommendTaskTimer.set(this._bind(this.createItemList, -1), 300);
				}
			} else {
				if (this._isOverlay()) {
					this.clearOverlayArea(false);
				} else {
					this.clearSuggestArea(true);
				}
			}
		}
		else if (this.candidateList != null && this.candidateList.length>0 && this.resultList==null) {
			this.search();
			if (this.options.recommendItemTiming == 'input' && !this._isOverlay()) {
				this.itemRecommendTaskTimer.set(this._bind(this.createItemList, -1), 300);
			}
		}
		this.keywordSuggestTaskTimer.set(this._bind(this.checkLoop), this.interval);
	},

	search: function() {
		if (this._isOverlay()) {
			this.clearOverlayArea(false);
		} else {
			this.clearSuggestArea();
		}
		var text = this.getInputText();
		if (text == '' || text == null) return;
		this._search();
		if (this.resultList != null && this.resultList.length > 0) {
			this.createSuggestArea();
		}
	},

	_matchesKana: function(candidate, list) {
		for (var i = 0; i < list.length; i++) {
			if (candidate.indexOf(list[i]) !== -1) {
				return true;
			}
		}
		return false;
	},

	_search: function() {
		var resultList;
		if (this.groupByField) {		// field単位でグルーピングする場合
			var resultListByField = {};
			var fieldIndex = 0;
			for (var i = 0, length = this.candidateList.length; i < length; i++) {
				var candidate = this.candidateList[i];
				var field = candidate.field;
				if (field == null) {
					field = '';
				}
				var fl = resultListByField[field];
				if (fl == null) {
					fl = {index: fieldIndex, list: []};
					resultListByField[field] = fl;
					fieldIndex++;
				} else if (fl.list.length >= this.options.maxSuggest) {
					continue;
				}
				var duplicate = false;
				for (var ii = 0; ii < fl.list.length; ii++) {
					if (fl.list[ii].surface == candidate.surface) {
						duplicate = true;
						break;
					}
				}
				if (!duplicate) {
					fl.list.push(candidate);
				}
			}
			resultList = new Array(fieldIndex);
			for (var name in resultListByField) {
				var fl = resultListByField[name];
				resultList[fl.index] = {field: name, list: fl.list};
			}
		} else {		// field単位でグルーピングしない場合
			var itemCount = 0;
			var resultListByCategory = {};
			var categoryIndex = 0;
			for (var i = 0, length = this.candidateList.length; i < length && itemCount < this.options.maxSuggest; i++) {
				var candidate = this.candidateList[i];
				var categories = null;
				if ((this.options.groupByCategory == true || this.options.groupByCategory == 'on') && candidate.category) {
					categories = candidate.category;
				} else {
					categories = [ '' ];
				}
				for (var ci = 0; ci < categories.length && itemCount < this.options.maxSuggest; ci++) {
					var category = categories[ci];
					if (category == null) {
						category = '';
					}
					var cat = resultListByCategory[category];
					if (cat == null) {
						cat = {index: categoryIndex, list: []};
						resultListByCategory[category] = cat;
						categoryIndex++;
					}
					var duplicate = false;
					for (var ii = 0; ii < cat.list.length; ii++) {
						if (cat.list[ii].surface == candidate.surface) {
							duplicate = true;
							break;
						}
					}
					if (!duplicate) {
						cat.list.push(candidate);
						itemCount++;
					}
				}
			}
			resultList = new Array(categoryIndex);
			for (var name in resultListByCategory) {
				var cat = resultListByCategory[name];
				resultList[cat.index] = {category: name, list: cat.list};
			}
		}
		this.resultList = resultList;
	},

	clearSuggestArea: function(forceClear) {
		if (this._isOverlay()) {
			this.clearOverlayArea(true);
			return;
		}
		this.suggestArea.innerHTML = '';
		this.suggestArea.style.display = 'none';
		this.suggestList = null;
		this.activePosition = null;
		this.resultList = null;
		this.clearRecommendItemArea(forceClear);
	},

	// _isOverlay()がtrueのときにoverlayする領域を作る
	createOverlayArea: function() {
		var inputAlreadyExists = false;
		for(i = 0; i < this.suggestArea.childNodes.length; i++) {
			var element = this.suggestArea.childNodes[i];
			if (element.id == '__NPSuggest_text_input') {
				inputAlreadyExists = true;
				break;
			}
		}

		var inputArea, spanArea, tmpTextArea, clearButton, submitButton, cancelButton;
		if (!inputAlreadyExists) {
			inputArea = document.createElement('div');
			inputArea.id = '__NPSuggest_text_input';
			inputArea.className = 'inputArea';

			cancelButton = document.createElement('button');
			cancelButton.innerText = 'cancel';
			cancelButton.className = 'cancelButton';
			NPSuggest.Event.add(cancelButton, 'click', this._bind(this.clearOverlayArea, true));
			inputArea.appendChild(cancelButton);

			submitButton = document.createElement('button');
			submitButton.innerText = 'submit';
			submitButton.className = 'submitButton';
			NPSuggest.Event.add(submitButton, 'click', this._bind(this.listClick));
			inputArea.appendChild(submitButton);

			spanArea = document.createElement('span');
			spanArea.style.display = "inline-block";
			spanArea.style.position = "relative";
			tmpTextArea = document.createElement('input');
			tmpTextArea.type = 'text';
			tmpTextArea.autoComplete = 'off';
			tmpTextArea.id = '__NPSuggest_text_input_input';
			tmpTextArea.placeholder = this.options.overlayPlaceHolder;
			spanArea.appendChild(tmpTextArea);
			clearButton = document.createElement('a');
			clearButton.innerHTML = "&#10006;";
			clearButton.style.textDecoration = "none";
			clearButton.style.top = "1px";
			clearButton.style.position = "absolute";
			clearButton.style.right = "6px";
			clearButton.style.top = "1px";
			spanArea.appendChild(clearButton);
			inputArea.appendChild(spanArea);
			NPSuggest.Event.add(clearButton, 'click', this._bind(function() {tmpTextArea.value = '';}));

			this.suggestArea.appendChild(inputArea);

			NPSuggest.Event.add(tmpTextArea, 'focus', this._bind(this.checkLoop));
			var keyevent = NPSuggest.Util.getKeyEvent();
			NPSuggest.Event.add(tmpTextArea, keyevent, this._bindEvent(this.keyEvent));
			NPSuggest.Event.add(tmpTextArea, 'compositionstart', this._bindEvent(this.compositionStartEvent));
			NPSuggest.Event.add(tmpTextArea, 'compositionend', this._bindEvent(this.compositionEndEvent));
		} else {
			window.scrollTo(0,0);
		}

		this.suggestArea.style.position = "absolute";
		this.suggestArea.style.zIndex  = 0x7fffffff;
		this.suggestArea.style.left = 0;
		this.suggestArea.style.top = 0;
		this.suggestArea.style.display = 'block';

		this.oldText = null;
		this.oldCategory = null;
		this.oldField = null;
		this.keywordBackup = '';		// compositionDelayEventが呼ばれない代わりにここで初期化

		// テキストボックス及び、その内のクリアボタンのサイズを調整
		if (!inputAlreadyExists) {
			var w_div = NPSuggest.Util.getCurrentWidth(inputArea);
			var w_submit = NPSuggest.Util.getCurrentWidth(submitButton, true);		// margin分も計算に入れる
			var w_cancel = NPSuggest.Util.getCurrentWidth(cancelButton, true);		// 同上
			var w_input = w_div - (w_submit + w_cancel);
			if (w_input > 0) {
				tmpTextArea.style.width = String(w_input) + "px";
			}
			if (document.defaultView) {		// Firefox,Opera,Safari,after IE9
				cs = document.defaultView.getComputedStyle(tmpTextArea, null);
				clearButton.style.fontSize = cs.fontSize;
			} else if (element.currentStyle) {		// before IE8
				clearButton.style.fontSize = tmpTextArea.currentStyle.fontSize;
			}
		}

		this.input = NPSuggest.Util.getElement('__NPSuggest_text_input_input');
		var inp = NPSuggest.Util.getElement(this.options.inputAreaID);
		if (typeof(inp) != 'undefined') {
			this.input.value = inp.value;
		}
		this.input.focus();
	},

	clearOverlayArea: function(hideArea) {
		for(i = 0; i < this.suggestArea.childNodes.length; i++) {
			var element = this.suggestArea.childNodes[i];
			if (element.id != '__NPSuggest_text_input') {
				this.suggestArea.removeChild(element);
				i--;
			}
		}
		this.suggestList = null;
		this.activePosition = null;
		this.resultList = null;
		this.clearRecommendItemArea(true);
		if (hideArea) {
			this.suggestArea.style.display = 'none';
		}
	},

	createSuggestArea: function() {
		this.suggestList = [];
		this.inputValueBackup = this.getInputText();
		var lastCategory = null;
		if (this.groupByField) {		// field単位でグルーピングする場合
			for (var flIndex = 0, length = this.resultList.length; flIndex < length; flIndex++) {
				var fl = this.resultList[flIndex];
				var group_element = document.createElement('div');
				group_element.className = "group";
				for (var i = 0; i < fl.list.length; i++) {
					var keyword = fl.list[i];
					var element;
					var fieldName = fl.field;
					var display_str = keyword.surface;
					var search_val = keyword.surface;
					if (fieldName == "path" && display_str.indexOf(":") != -1) {		// カテゴリの時は表示を加工する
						var buf = display_str.split(":");
						buf.reverse();			// 検索に渡す用に元の順番に戻す
						search_val = buf.join(":");
						display_str = buf.pop();			// 本来の子カテゴリを取り出す
						if (buf.length > 0) {				// 残りは元の順番で表示する
							display_str += " - ";
							display_str += buf.join(" > ");
						}
					}
					if (this.options.suggestHighlight == true || this.options.suggestHighlight == 'on') {
						element = NPSuggest.Util.highlightHTML(display_str, this.getInputText(), 'highlight');
					} else {
						element = NPSuggest.Util.highlightHTML(display_str, this.getInputText(), '');
					}
					element.value = search_val;				// 商品詳細検索用の値
					element.field = fieldName;
					element.className = "item " + fieldName;
					var plusBtn = null;
					if (this._isOverlay()) {			// overlayModeのときはプラスボタンを表示する
						plusBtn = document.createElement('button');
						plusBtn.innerHTML = '＋';
						plusBtn.className = 'plusButton';
						element.appendChild(plusBtn);
					}
					group_element.appendChild(element);
					var listIndex = this.suggestList.length;
					NPSuggest.Event.add(element, 'click', this._bindEvent(this.listClick, listIndex));
					NPSuggest.Event.add(element, 'mouseover', this._bindEvent(this.listMouseOver, listIndex));
					NPSuggest.Event.add(element, 'mouseout', this._bindEvent(this.listMouseOut, listIndex));
					if (plusBtn != null) {
						NPSuggest.Event.add(plusBtn, 'click', this._bindEvent(this.listClick2, listIndex));
					}
					this.suggestList.push(element);
				}
				this.suggestArea.appendChild(group_element);
			}
		} else {
			for (var catIndex = 0, length = this.resultList.length; catIndex < length; catIndex++) {
				var cat = this.resultList[catIndex];
				if (this.options.groupByCategory == true || this.options.groupByCategory == 'on') {
					if (cat.category != lastCategory) {
						lastCategory = cat.category;
						var element = document.createElement('div');
						if (cat.category == "undefined" || cat.category.length == 0) {
							element.innerHTML = '&nbsp;';
						} else {
							element.innerHTML = NPSuggest.Util.escapeHTML(cat.category);
						}
						element.className = 'category';
						this.suggestArea.appendChild(element);
						var listIndex = this.suggestList.length;
						NPSuggest.Event.add(element, 'click', this._bindEvent(this.listClick, listIndex));
						NPSuggest.Event.add(element, 'mouseover', this._bindEvent(this.listMouseOver, listIndex));
						NPSuggest.Event.add(element, 'mouseout', this._bindEvent(this.listMouseOut, listIndex));
						this.suggestList.push(element);
					}
				}
				for (var i = 0; i < cat.list.length; i++) {
					var keyword = cat.list[i];
					var element;
					var display_str = keyword.surface;
					var search_val = keyword.surface;
					if (keyword.field == "path" && display_str.indexOf(":") != -1) {		// カテゴリの時は表示を加工する
						var buf = display_str.split(":");
						buf.reverse();			// 検索に渡す用に元の順番に戻す
						search_val = buf.join(":");
						display_str = buf.pop();			// 本来の子カテゴリを取り出す
						if (buf.length > 0) {				// 残りは元の順番で表示する
							display_str += " - ";
							display_str += buf.join(" > ");
						}
					}
					if (this.options.suggestHighlight == true || this.options.suggestHighlight == 'on') {
						element = NPSuggest.Util.highlightHTML(display_str, this.getInputText(), 'highlight');
					} else {
						element = NPSuggest.Util.highlightHTML(display_str, this.getInputText(), '');
					}
					element.value = search_val;				// 商品詳細検索用の値
					//element.field = keyword.field;
					element.className = "item";
					var plusBtn = null;
					if (this._isOverlay()) {			// overlayModeのときはプラスボタンを表示する
						plusBtn = document.createElement('button');
						plusBtn.innerHTML = '＋';
						plusBtn.className = 'plusButton';
						element.appendChild(plusBtn);
					}
					this.suggestArea.appendChild(element);
					var listIndex = this.suggestList.length;
					NPSuggest.Event.add(element, 'click', this._bindEvent(this.listClick, listIndex));
					NPSuggest.Event.add(element, 'mouseover', this._bindEvent(this.listMouseOver, listIndex));
					NPSuggest.Event.add(element, 'mouseout', this._bindEvent(this.listMouseOut, listIndex));
					if (plusBtn != null) {
						NPSuggest.Event.add(plusBtn, 'click', this._bindEvent(this.listClick2, listIndex));
					}
					this.suggestList.push(element);
				}
			}
		}

		this.drawSuggestArea();
	},

	drawSuggestArea: function() {
		var pos = this._onWindowResize();		// サジェストの表示位置を決定

		// display
		if (!this._isOverlay()) {
			this.suggestArea.style.position = "absolute";
			this.suggestArea.style.zIndex  = 0x7fffffff;
			this.suggestArea.style.height = 'auto';
			this.suggestArea.style.display = 'block';

			this.clearRecommendItemArea();
			this.itemListArea.style.position = "absolute";
			this.itemListArea.style.zIndex  = 0x7fffffff;
			this.itemListArea.style.height = 'auto';
		}

		this._onWindowResize2(pos);
	},

	getInputText: function() {
		return this.input.value;
	},
	getInputCategory: function() {
		return this.categoryArea.value;
	},
	getInputField: function() {
		return this.fieldArea ? this.fieldArea.value : this.field;
	},

	setInputText: function(text) {
		this.input.value = text;
	},

	// key event
	keyEvent: function(event) {
		if (!this.keywordSuggestTaskTimer.hasTask()) {
			this.keywordSuggestTaskTimer.set(this._bind(this.checkLoop), this.interval);
		}
		if (event.keyCode == NPSuggest.Key.UP ||
					event.keyCode == NPSuggest.Key.DOWN) {
			// key move
			if (this.suggestList && this.suggestList.length != 0) {
				NPSuggest.Event.stop(event);
				this.keyEventMove(event.keyCode);
			}
		} else if (event.keyCode == NPSuggest.Key.RETURN) {
			if (this._isOverlay()) {
				this.keyEventReturn(event);
			} else {
				if (this.activePosition == null) {
					;
				} else if (this.suggestList && this.suggestList.length != 0) {
					this.keyEventReturn(event);
				}
			}
		} else if (event.keyCode == NPSuggest.Key.ESC) {
			if (this._isOverlay()) {
				NPSuggest.Event.stop(event);
				this.keyEventEsc();
			} else {
				if (this.activePosition == null) {
					;
				} else if (this.suggestList && this.suggestList.length != 0) {
					NPSuggest.Event.stop(event);
					this.keyEventEsc();
				}
			}
		} else {
			this.keyEventOther(event);
		}
	},

	keyEventMove: function(keyCode) {
		this.changeUnactive();
		if (keyCode == NPSuggest.Key.UP) {
			// up
			if (this.activePosition == null) {
				this.activePosition = this.suggestList.length -1;
			}else{
				this.activePosition--;
			}
			var element = this.suggestList[this.activePosition];
			while(!NPSuggest.Util.isVisible(element)) {
				this.activePosition--;
				if (this.activePosition < 0) {
					this.activePosition = null;
					this.input.value = this.inputValueBackup;
					return;
				}
				element = this.suggestList[this.activePosition];
			}
		}else{
			// down
			if (this.activePosition == null) {
				this.activePosition = 0;
			}else{
				this.activePosition++;
			}
			var element = this.suggestList[this.activePosition];
			while(!NPSuggest.Util.isVisible(element)) {
				this.activePosition++;
				if (this.activePosition >= this.suggestList.length) {
					this.activePosition = null;
					this.input.value = this.inputValueBackup;
					return;
				}
				element = this.suggestList[this.activePosition];
			}
		}
		this.changeActive(this.activePosition);
	},

	keyEventReturn: function(event) {
		// クライアント側のイベントハンドラがあったらそっちにデータを渡してこっちは終了
		// listClickにもほぼ同じ処理があるので注意
		var categoryName = this.options.categoryName;
		var category = this.getInputCategory();
		var element, keyword;
		var index = this.activePosition;
		if(this.suggestList != null && this.suggestList.length > 0 && typeof(this.suggestList[index]) != "undefined") {
			element = this.suggestList[index];
			keyword = NPSuggest.Util.getSuggestValue(element, "value");
			if (keyword == null) {
				keyword = '';
			}
		} else {
			keyword = this.getInputText();
		}
		var fieldName = "";
		if (element && "field" in element) {
			fieldName = element.field;
		}
		var fireSubmit = false;
		if (typeof NPSuggest_listClick == "function") {
			if (this._isOverlay()) {
				this.clearOverlayArea(true);
			}
			NPSuggest.Event.stop(event);		// eventを止める
			if (index != null) {			// サジェストが選択されている時のみ
				if(NPSuggest_listClick(keyword,fieldName,categoryName,category) == true) {
					return;
				} else {
					fireSubmit = true;
				}
			} else {
				fireSubmit = true;
			}
		}

		this.clearSuggestArea();
		this.moveEnd();

		if (this._isOverlay()) {
			var inp = NPSuggest.Util.getElement(this.options.inputAreaID);
			if (inp) {
				inp.value = this.getInputText();
			}

			var submit = NPSuggest.Util.getElement(this.options.submitBtnID);
			if (submit) {
				if (submit.click){
					submit.click();
				} else if (submit.onclick) {
					submit.onclick();
				}
			}
		} else if (fireSubmit) {		// 一旦event.stop()でeventを止めてるので再度submitする
			var submit = NPSuggest.Util.getElement(this.options.submitBtnID);
			if (submit) {
				if (submit.click){
					submit.click();
				} else if (submit.onclick) {
					submit.onclick();
				}
			}
		}
	},

	keyEventEsc: function() {
		this.clearSuggestArea();
		this.input.value = this.inputValueBackup;
		if (this._isOverlay()) {
			// no-op
		} else {
			this.oldText = this.getInputText();
		}
		if (window.opera) setTimeout(this._bind(this.moveEnd), 5);
	},

	keyEventOther: function(event) {},

	// MobileSafari対策のために上書きコードを入れる
	compositionStartEvent: function(event) {
		this.compositionStatus = true;
	},

	compositionEndEvent: function(event) {
		this.compositionStatus = false;
		if (NPSuggest.Browser.MobileSafari && this.keywordBackup.length > 0) {
			this.setInputText("");			// 画面表示上一旦消したほうが見栄えが良い
			this.compositionTaskTimer.set(this._bind(this.compositionDelayEvent), 50);
		}
	},

	compositionDelayEvent: function() {
		// overlay時はここは呼ばれない
		this.setInputText(this.keywordBackup);
		this.keywordBackup = '';
	},

	changeActive: function(index) {
		if (index == null || typeof(index) == "undefined") {
			return;
		}
		var element = this.suggestList[index];
		this.setStyleActive(element);
		var keyword = NPSuggest.Util.getSuggestValue(element, "value");
		this.setInputText(keyword);
		if (this.compositionStatus) {		// IMEで未確定文字列がある
			this.keywordBackup = keyword;
		}
		this.oldText = this.getInputText();
		this.input.focus();
		this.itemRecommendTaskTimer.set(this._bind(this.createItemList, index), 200);
	},

	changeUnactive: function() {
		if (this.suggestList != null
				&& this.suggestList.length > 0
				&& this.activePosition != null) {
			this.setStyleUnactive(this.suggestList[this.activePosition]);
		}
	},

	// 通常のサジェスト候補クリック時
	listClick: function(event, index) {
		this.changeUnactive();
		this.activePosition = index;
		this.changeActive(index);
		this.moveEnd();

		// クライアント側のイベントハンドラがあったらそっちにデータを渡してこっちは終了
		// keyEventReturnにもほぼ同じ処理があるので注意
		var categoryName = this.options.categoryName;
		var category = this.getInputCategory();
		var element, keyword;
		if(this.suggestList != null && this.suggestList.length > 0 && typeof(this.suggestList[index]) != "undefined") {
			element = this.suggestList[index];
			keyword = NPSuggest.Util.getSuggestValue(element, "value");
			if (keyword == null) {
				keyword = '';
			}
		} else {
			keyword = this.getInputText();
		}
		var fieldName = "";
		if (element && "field" in element) {
			fieldName = element.field;
		}
		if (typeof NPSuggest_listClick == "function") {
			if (this._isOverlay()) {
				this.clearOverlayArea(true);
			}
			if (index != undefined) {
				if(NPSuggest_listClick(keyword,fieldName,categoryName,category) == true) {
					return;
				}
			}
		}

		if (this._isOverlay()) {
			var inp = NPSuggest.Util.getElement(this.options.inputAreaID);
			if (inp) {
				inp.value = this.getInputText();
			}
		}

		var submit = NPSuggest.Util.getElement(this.options.submitBtnID);
		if (typeof(submit)=="undefined" || submit==null) {
			if (this._isOverlay()) {
				this.clearOverlayArea(true);
			}
		} else if (submit.click){
			submit.click();
		} else if (submit.onclick) {
			submit.onclick();
		}
	},

	// プラスボタンクリック時
	listClick2: function(event, index) {
		this.changeUnactive();
		this.activePosition = index;
		this.changeActive(index);
		this.moveEnd();

		NPSuggest.Event.stop(event);		// 一旦eventを止める
		this.oldText = '';					// oldTextをクリアして強制的にサジェスト候補を再検索させる
	},

	listMouseOver: function(event, index) {
		this.changeUnactive();
		this.activePosition = index;
		var el = NPSuggest.Event.getElement(event);
		if (el.isHighlight == true) {
			el = el.parentNode;
		}
		this.setStyleActive(el);
		if (!this._isOverlay()) {
			this.itemRecommendTaskTimer.set(this._bind(this.createItemList, index), 300);
		}
	},

	listMouseOut: function(event, index) {
		this.itemRecommendTaskTimer.clear();
		if (!this.suggestList) return;
		var el = NPSuggest.Event.getElement(event);
		if (el.isHighlight == true) {
			el = el.parentNode;
		}
		if (index == this.activePosition) {
			this.setStyleActive(el);
		}else{
			this.setStyleUnactive(el);
		}
	},

	addClass: function(element, className) {
		if (!element || !("className" in element)) {
			return;
		}
		var name = element.className;
		if (name != null && name.length > 0) {
			var names = name.split(' ');
			for (var i = 0; i < names.length; i++) {
				if (names[i] == className) {
					return;
				}
			}
			element.className = name + ' ' + className;
		} else {
			element.className = className;
		}
	},

	removeClass: function(element, className) {
		if (!element || !("className" in element)) {
			return;
		}
		var name = element.className;
		if (name != null && name.length > 0) {
			var names = name.split(' ');
			var newNames = [];
			for (var i = 0; i < names.length; i++) {
				if (names[i] != className) {
					newNames.push(names[i]);
				}
			}
			element.className = newNames.join(' ');
		}
	},

	setStyleActive: function(element) {
		this.addClass(element, 'selected');
	},

	setStyleUnactive: function(element) {
		this.removeClass(element, 'selected');
	},

	moveEnd: function() {
		if (this.input.createTextRange) {
			this.input.focus(); // Opera
			var range = this.input.createTextRange();
			range.move('character', this.input.value.length);
			range.select();
		} else if (this.input.setSelectionRange) {
			this.input.setSelectionRange(this.input.value.length, this.input.value.length);
		}
	},

	_bind: function(func) {
		var self = this;
		var args = Array.prototype.slice.call(arguments, 1);
		return function(){ func.apply(self, args); };
	},
	_bindEvent: function(func) {
		var self = this;
		var args = Array.prototype.slice.call(arguments, 1);
		return function(event){ event = event || window.event; func.apply(self, [event].concat(args)); };
	},

	// 商品詳細表示のon/off
	_isItemAreaEnabled: function() {
		if (this.options.recommendItemEnabled == true || this.options.recommendItemEnabled == "on") {		// 常時on
			return true;
		} else if (this.options.recommendItemEnabled == false || this.options.recommendItemEnabled == "off") {		// 常時off
			return false;
		} else if (this.options.recommendItemEnabled == "auto") {		// 自動切替
			if (this._isOverlay()) {		// overlay有効時は表示しない
				return false;
			}
			var limitWidth = this.options.recommendItemLimitWidth;
			var limitHeight = this.options.recommendItemLimitHeight;
			var w;
			var h;
			if ((!document.all || window.opera) && document.getElementById) {
				w=window.innerWidth;
				h=window.innerHeight;
			} else if (document.getElementById && (document.compatMode=='CSS1Compat')) {
				w=document.documentElement.clientWidth;
				h=document.documentElement.clientHeight;
			} else if (document.all) {
				w=document.body.clientWidth;
				h=document.body.clientHeight;
			} else {
				w = Math.max(document.body.clientWidth, document.body.scrollWidth, document.documentElement.scrollWidth, document.documentElement.clientWidth);
				h = Math.max(document.body.clientHeight, document.body.scrollHeight, document.documentElement.scrollHeight, document.documentElement.clientHeight);
			}
			if (limitWidth > w || limitHeight > h) {
				return false;
			}
		}
		return true;
	},

	// window resize時にサジェストも追随する
	_onWindowResize: function(isChain) {
		// position
		var x = 0;
		var y = 0;

		if (this._isOverlay()) {
			// 何もしない
		} else if (this.options.alwaysOnTop == true || this.options.alwaysOnTop == 'on') {
			this.inputPos = NPSuggest.Util.getAbsolutePosition(this.input);
			var height = NPSuggest.Util.getCurrentHeight(this.input);
			x = this.inputPos.x;
			y = this.inputPos.y + height;
			if ((navigator.platform=='iPhone' || navigator.platform=='iPod') && (navigator.userAgent.search(/iPhone OS (2|3|4)_/)>0) ){
				y += 15;
			}
		} else {
			var iPos = NPSuggest.Util.getElementPosition(this.input);
			x = iPos.x;
			y = iPos.y + this.input.offsetHeight;
			if ((navigator.platform=='iPhone' || navigator.platform=='iPod') && (navigator.userAgent.search(/iPhone OS (2|3|4)_/)>0) ){
				y += 15;
			}
		}

		var xPos = String(x) + "px";
		var yPos = String(y) + "px";
		this.suggestArea.style.left = xPos;
		this.suggestArea.style.top = yPos;

		var pos = new Array(x, y);
		if (isChain) {
			this._onWindowResize2(pos);
		}
		return pos;
	},

	// 商品詳細表示部分の表示on/offと位置調整
	_onWindowResize2: function(pos) {
		if (this._isOverlay()) {
			return;
		}

		if (this._isItemAreaEnabled() && this.itemListArea.innerHTML.length > 0) {
			this.itemListArea.style.display = "block";
		} else {
			this.itemListArea.style.display = "none";
		}

		var x = pos[0];
		var y = pos[1];
		var xPos = String(x) + "px";
		var yPos = String(y) + "px";

		if (this.options.recommendItemAreaPosition == "right") {
			xPos = String(x + this.suggestArea.offsetWidth) + "px";
			this.itemListArea.style.left = xPos;
			this.itemListArea.style.top = yPos;
		} else if (this.options.recommendItemAreaPosition == "left") {
			xPos = String(x - NPSuggest.Util.getCurrentWidth(this.itemListArea)) + "px";
			this.itemListArea.style.left = xPos;
			this.itemListArea.style.top = yPos;
		} else {		// bottom
			yPos = String(y + this.suggestArea.offsetHeight) + "px";
			this.itemListArea.style.left = xPos;
			this.itemListArea.style.top = yPos;
		}
	},

	// overlay表示を行うかどうか
	_isOverlay: function() {
		if (this.options.overlayMode == "auto") {
			// 端末種別によってon/offする
			return NPSuggest.Browser.isMobile();
		} else if (this.options.overlayMode == true || this.options.overlayMode == "on") {
			return true;
		} else if (!this.options.overlayMode == false || this.options.overlayMode == "off") {
			return false;
		}
		return false;
	}
};

/*-- NPSuggest.Key -----------------------------*/
NPSuggest.Key = {
	TAB:     9,
	RETURN: 13,
	ESC:    27,
	UP:     38,
	DOWN:   40
};

/*-- NPSuggest.Util ----------------------------*/
NPSuggest.Util = {
	addCSSRule : function(css,selector,attribute,value) {
		if (css.addRule) {
			css.addRule(selector ,attribute+":"+value);
		} else if (css.insertRule) {
			css.insertRule(selector + "{" + attribute+":"+value + "}", css.cssRules.length);
		}
	},
	normalizeKeyword : function(keyword) {
		var str = new String;
		var len = keyword.length;
		for (var i = 0; i < len; i++) {
			var c = keyword.charCodeAt(i);
			// hiragana -> katakana
			if ((c >= 12353 && c <= 12435) || c == 12445 || c == 12446)
				str += String.fromCharCode(c + 96);
			// zenkaku-eisuu -> hankaku-eisuu
			else if ((c >= 65313 && c <= 65338) || (c >= 65345 && c <= 65370) || (c >= 65296 && c <= 65305) || c == 65343)
				str += String.fromCharCode(c - 65248);
			//space
			else if (c == 12288)
				str += String.fromCharCode(32);
			else
				str += keyword.charAt(i);
		}
		return str.toLowerCase();
	},
	escapeHTML: function(value) {
			return value.replace(/\&/g, '&amp;').replace( /</g, '&lt;').replace(/>/g, '&gt;')
				.replace(/\"/g, '&quot;').replace(/\'/g, '&#39;');
	},
	highlightHTML: function(value, str, cls) {
		var doc = document.createElement('div');
		if (!cls) {
			doc.appendChild(document.createTextNode(value));
		} else {
			var pos = value.indexOf(str);
			if (pos < 0) {
				doc.appendChild(document.createTextNode(value));
			} else {
				var before, highlight, after;
				before = document.createTextNode(value.substr(0, pos));
				highlight = document.createElement('div');
				highlight.appendChild(document.createTextNode(str));
				highlight.className = cls;
				highlight.isHighlight = true;
				after = document.createTextNode(value.substr(pos + str.length));
				doc.appendChild(before);
				doc.appendChild(highlight);
				doc.appendChild(after);
			}
		}
		return doc;
	},
	textContent: function(element) {
		return element.textContent || element.innerText;
	},
	getSuggestValue: function(element, name) {
		if (!element) {
			return null;
		}
		if (name in element) {
			return element[name];
		}
		return NPSuggest.Util.textContent(element);
	},
	getElement: function(element) {
		if (typeof element == 'string') {
			if (element.length > 0) {
				return document.getElementById(element);
			}
			return null;
		}
		return element;
	},
	getElementPosition: function(element) {
		if (!NPSuggest.Browser.IE && !NPSuggest.Browser.Opera)
			return this._getElementPositionMozilla(element);
		var x = 0;
		var y = 0;
		var parent = element;
		while (parent) {
			if (parent != element && document.defaultView && document.defaultView.getComputedStyle(parent, null).position == "relative")
				break;
			if (parent != element && parent.currentStyle && parent.currentStyle["position"] == "relative")
				break;
			if (parent != element && document.defaultView && document.defaultView.getComputedStyle(parent, null).position == "absolute")
				break;
			if (parent != element && parent.currentStyle && parent.currentStyle["position"] == "absolute")
				break;
			var borderXOffset = 0;
			var borderYOffset = 0;
			if (parent != element) {
				borderXOffset = parseInt(parent.style.borderLeftWidth ,10);
				borderYOffset = parseInt(parent.style.borderTopWidth ,10);
				borderXOffset = isNaN(borderXOffset) ? 0 : borderXOffset;
				borderYOffset = isNaN(borderYOffset) ? 0 : borderYOffset;
			}
			if (parent == element && parent.scrollLeft > parent.width) {
				x += parent.offsetLeft - parent.width + borderXOffset;
			} else {
				if (parent != document.body && parent != document.documentElement) {
					x += parent.offsetLeft - parent.scrollLeft + borderXOffset;
				} else {
					x += parent.offsetLeft + borderXOffset;
				}
			}
			if (parent != document.body && parent != document.documentElement) {
				y += parent.offsetTop - parent.scrollTop + borderYOffset;
			} else {
				y += parent.offsetTop + borderYOffset;
			}
			parent = parent.offsetParent;
		}
		return {x:x ,y:y};
	},
	_getElementPositionMozilla: function(element) {
		var x = 0;
		var y = 0;
		var parent = element;
		while (parent) {
			if (parent != element && document.defaultView && document.defaultView.getComputedStyle(parent, null).position == "relative")
				break;
			if (parent != element && document.defaultView && document.defaultView.getComputedStyle(parent, null).position == "absolute") {
				if (NPSuggest.Browser.Firefox && NPSuggest.Browser.getVersion()<=9 && parent.tagName=="TABLE") {
					;;
				} else {
					break;
				}
			}
			x += parent.offsetLeft;
			y += parent.offsetTop;
			parent = parent.offsetParent;
		}

		parent = element;
		while (parent && parent != document.body && parent != document.documentElement) {
			if (parent.scrollLeft && parent != element)
				x -= parent.scrollLeft;
			if (parent.scrollTop)
				y -= parent.scrollTop;
			parent = parent.parentNode;
		}
		return {x:x ,y:y};
	},
	getAbsolutePosition: function(element) {
		// cross-browser code by mdn
		var x = (window.pageXOffset !== undefined) ? window.pageXOffset : (document.documentElement || document.body.parentNode || document.body).scrollLeft;
		var y = (window.pageYOffset !== undefined) ? window.pageYOffset : (document.documentElement || document.body.parentNode || document.body).scrollTop;

		var bounds = element.getBoundingClientRect();
		x = Math.round(x + bounds.left);
		y = Math.round(y + bounds.top);
		return {x:x ,y:y};
	},
	getCurrentHeight: function(element, withMargin) {
		var height = 0;
		var cs;
		if (document.defaultView) {		// Firefox,Opera,Safari,after IE9
			cs = document.defaultView.getComputedStyle(element, null);
			height = parseInt(cs.height) + parseInt(cs.paddingTop) + parseInt(cs.paddingBottom) + parseInt(cs.borderTopWidth) + parseInt(cs.borderBottomWidth);
			if (withMargin == true) {
				height += parseInt(cs.marginTop) + parseInt(cs.marginBottom);
			}
		} else if (element.currentStyle) {		// before IE8
			height = element.offsetHeight;
		}
		return height;
	},
	getCurrentWidth: function(element, withMargin) {
		var width = 0;
		var cs;
		if (document.defaultView) {		// Firefox,Opera,Safari,after IE9
			cs = document.defaultView.getComputedStyle(element, null);
			width = parseInt(cs.width) + parseInt(cs.paddingLeft) + parseInt(cs.paddingRight) + parseInt(cs.borderLeftWidth) + parseInt(cs.borderRightWidth);
			if (withMargin == true) {
				width += parseInt(cs.marginLeft) + parseInt(cs.marginRight);
			}
		} else if (element.currentStyle) {		// before IE8
			width = element.offsetWidth;
		}
		return width;
	},
	getAllSelectors: function() {
		var ret = [];
		for(var i = 0; i < document.styleSheets.length; i++) {
			var rules = [];
			try {
				rules = document.styleSheets[i].rules || document.styleSheets[i].cssRules;
			} catch (e) {
				if(e.name !== 'SecurityError') {
					throw e;
				}
				continue;
			}
			for(var x in rules) {
				if(typeof rules[x].selectorText == 'string') ret.push(rules[x].selectorText);
			}
		}
		return ret;
	},
	selectorExists: function(selector) { 
		var selectors = NPSuggest.Util.getAllSelectors();
		for(var i = 0; i < selectors.length; i++) {
			if(selectors[i] == selector) return true;
		}
		return false;
	},
	isVisible: function(element) {
		if (element == "undefined" || element == null) {
			return null;
		}
		var cs;
		if (document.defaultView) {		// Firefox,Opera,Safari,after IE9
			cs = document.defaultView.getComputedStyle(element, null);
		} else if (element.currentStyle) {		// before IE8
			cs = element.currentStyle;
		}
		if (cs.display == "none") {
			return false;
		} else if (cs.visibility == "hidden" || cs.visibility == "collapse") {
			return false;
		} else if (parseInt(cs.height) <= 0) {
			return false;
		}
		return true;
	},
	getKeyEvent: function() {
		var keyevent = 'keydown';
		if (window.opera) {
			keyevent = 'keypress';
		} else if (navigator.userAgent.indexOf('Gecko') >= 0) {
			if(navigator.userAgent.indexOf('KHTML') == -1 && navigator.userAgent.indexOf('Trident') == -1) {
				keyevent = 'keypress';
			}
		}
		return keyevent;
	}
}

NPSuggest.bind = function(options) {
	NPSuggest.Event.add(window ,'load' ,function(){new NPSuggest.Controller(options);});
}

/*-- NPSuggest.Browser ---------------------------*/
NPSuggest.Browser = {
	IE:     !!(window.attachEvent && navigator.userAgent.indexOf('Opera') === -1),
	IE6:    (!!(window.attachEvent && navigator.userAgent.indexOf('Opera') === -1) && typeof document.documentElement.style.maxHeight == "undefined"),
	Opera:  navigator.userAgent.indexOf('Opera') > -1,
	WebKit: navigator.userAgent.indexOf('AppleWebKit/') > -1,
	Gecko:  navigator.userAgent.indexOf('Gecko') > -1 && navigator.userAgent.indexOf('KHTML') === -1,
	Firefox: navigator.userAgent.indexOf('Firefox') > -1,
	MobileSafari: !!navigator.userAgent.match(/Apple.*Mobile.*Safari/),
	getVersion : function() {
		if (NPSuggest.Browser.IE) {
			return parseFloat(navigator.appVersion.toLowerCase().replace(/.*msie[ ]?/,'').match(/^[0-9]+[.]?[0-9]?/));
		}
		if (NPSuggest.Browser.Firefox) {
			return parseFloat(navigator.userAgent.toLowerCase().replace(/.*firefox\/[ ]?/,'').match(/^[0-9]+[.]?[0-9]?/));
		}
		return 0;
	},

	// Mobile端末かどうかを判別
	// from http://detectmobilebrowsers.com/
	isMobile: function() {
		var a = navigator.userAgent||navigator.vendor||window.opera;
		if(/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino/i.test(a)||/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0,4))) {
			return true;
		}
		return false;
	}
}

NPSuggest.KanaRomaConverter = {
	kana1: [
      'キャ', 'キィ', 'キュ', 'キェ', 'キョ',
      'ギャ', 'ギィ', 'ギュ', 'ギェ', 'ギョ',
      'クァ', 'クィ', 'クゥ', 'クェ', 'クォ',
      'グァ', 'グィ', 'グゥ', 'グェ', 'グォ',
      'シャ', 'シャ', 'シュ', 'シュ', 'シェ', 'シェ', 'ショ', 'ショ',
      'ジャ', 'ジィ', 'ジュ', 'ジェ', 'ジョ',
      'チャ', 'チィ', 'チュ', 'チェ', 'チョ',
      'ヂャ', 'ヂィ', 'ヂュ', 'ヂェ', 'ヂョ',
      //'ツァ', 'ツィ', 'ツェ', 'ツォ',
      //'テャ', 'ティ', 'テュ', 'テェ', 'テョ',
      //'デャ', 'ディ', 'デゥ', 'デェ', 'デョ',
      'トァ', 'トィ', 'トゥ', 'トェ', 'トォ',
      'ニャ', 'ニィ', 'ニュ', 'ニェ', 'ニョ',
      'ヴァ', 'ヴィ', 'ヴェ', 'ヴォ',
      'ヒャ', 'ヒィ', 'ヒュ', 'ヒェ', 'ヒョ',
      'ファ', 'フィ', 'フェ', 'フォ',
      'フャ', 'フュ', 'フョ',
      'ビャ', 'ビィ', 'ビュ', 'ビェ', 'ビョ',
      'ヴャ', 'ヴィ', 'ヴュ', 'ヴェ', 'ヴョ', 
      'ピャ', 'ピィ', 'ピュ', 'ピェ', 'ピョ',
      'ミャ', 'ミィ', 'ミュ', 'ミェ', 'ミョ', 
      'リャ', 'リィ', 'リュ', 'リェ', 'リョ',
      'ウィ', 'ウェ', 'イェ'
    ],
    roma1: [
      'kya', 'kyi', 'kyu', 'kye', 'kyo',
      'gya', 'gyi', 'gyu', 'gye', 'gyo',
      'qwa', 'qwi', 'qwu', 'qwe', 'qwo',
      'gwa', 'gwi', 'gwu', 'gwe', 'gwo',
      'sya', 'sha', 'syu', 'shu', 'sye', 'she', 'syo', 'sho',
      'ja', 'jyi', 'ju', 'je', 'jo',
      'cha', 'cyi', 'chu', 'che', 'cho',
      'dya', 'dyi', 'dyu', 'dye', 'dyo',
      //'tsa', 'tsi', 'tse', 'tso',
      //'tha', 'ti', 'thu', 'the', 'tho',
      //'dha', 'di', 'dhu', 'dhe', 'dho',
      'twa', 'twi', 'twu', 'twe', 'two',
      'nya', 'nyi', 'nyu', 'nye', 'nyo',
      'va', 'vi', 've', 'vo',
      'hya', 'hyi', 'hyu', 'hye', 'hyo',
      'fa', 'fi', 'fe', 'fo',
      'fya', 'fyu', 'fyo',
      'bya', 'byi', 'byu', 'bye', 'byo',
      'vya', 'vyi', 'vyu', 'vye', 'vyo',
      'pya', 'pyi', 'pyu', 'pye', 'pyo',
      'mya', 'myi', 'myu', 'mye', 'myo',
      'rya', 'ryi', 'ryu', 'rye', 'ryo',
      'wi', 'we', 'ye'
    ],
    kana2: [
      'シャ', 'シュ', 'シェ', 'ショ',
      'カ', 'キ', 'ク', 'ケ', 'コ',
      'タ', 'チ', 'チ', 'ツ', 'ツ', 'テ', 'ト',
      'サ', 'シ', 'シ', 'ス', 'セ', 'ソ',
      'ナ', 'ニ', 'ヌ', 'ネ', 'ノ',
      'ハ', 'ヒ', 'フ', 'フ', 'ヘ', 'ホ',
      'マ', 'ミ', 'ム', 'メ', 'モ',
      'ヤ', 'ユ', 'ヨ',
      'ラ', 'リ', 'ル', 'レ', 'ロ',
      'ワ', 'ヰ', 'ヱ', 'ヲ', 'ン',
      'ガ', 'ギ', 'グ', 'ゲ', 'ゴ',
      'ザ', 'ジ', 'ズ', 'ゼ', 'ゾ',
      'ダ', 'ヂ', 'ヅ', 'デ', 'ド',
      'バ', 'ビ', 'ブ', 'ベ', 'ボ',
      'パ', 'ピ', 'プ', 'ペ', 'ポ',
      'ア', 'イ', 'ウ', 'エ', 'オ'
    ],
    roma2: [
      'sya', 'syu', 'sye', 'syo',
      'ka', 'ki', 'ku', 'ke', 'ko',
      'ta', 'chi', 'ti', 'tsu', 'tu', 'te', 'to',
      'sa', 'shi', 'si', 'su', 'se', 'so',
      'na', 'ni', 'nu', 'ne', 'no',
      'ha', 'hi', 'fu', 'hu', 'he', 'ho',
      'ma', 'mi', 'mu', 'me', 'mo',
      'ya', 'yu', 'yo',
      'ra', 'ri', 'ru', 're', 'ro',
      'wa', 'wyi', 'wye', 'wo', 'n',
      'ga', 'gi', 'gu', 'ge', 'go',
      'za', 'ji', 'zu', 'ze', 'zo',
      'da', 'ji', 'du', 'de', 'do',
      'ba', 'bi', 'bu', 'be', 'bo',
      'pa', 'pi', 'pu', 'pe', 'po',
      'a', 'i', 'u', 'e', 'o'
    ],

    init: function() {
    	if (!this.initialized) {
    		var roma = this.roma1.concat(this.roma2);
    		var sokuRoma = [];
    		for (var i = 0; i < this.roma2.length - 5; i++) {
    			sokuRoma.push(this.roma2[i].substr(0, 1) + this.roma2[i]);
    		}
    		roma = sokuRoma.concat(roma);
    		this.romaPattern = [];
    		for (var i = 0; i < roma.length; i++) {
    			this.romaPattern.push(new RegExp(roma[i], 'g'));
    		}

    		var kana = this.kana1.concat(this.kana2);
    		var sokuKana = [];
    		for (var i = 0; i < this.kana2.length - 5; i++) {
    			sokuKana.push('ッ' + this.kana2[i]);
    		}
    		this.kanaReplacement = sokuKana.concat(kana);

    		this.initialized = true;
    	}
    },

    _replaceEach: function(from, to, str) {
    	for (var i = 0; i < from.length; i++) {
    		str = str.replace(from[i], to[i]);
    	}
    	return str;
    },

	romaToKanaExpandSuffix: function(str) {
		return this.expandRomaSuffix(this.romaToKana(str));
	},

	romaToKana: function(str) {
		this.init();
		str = this._replaceEach(this.romaPattern, this.kanaReplacement, str);
		str = str.replace(/([ァ-ヺ])-/g, '$1ー');
		return str;
	},

	expandRomaSuffix: function(str) {
		return this._expandRomaSuffix(str, [[this.roma2, this.kana2], [this.roma1, this.kana1]]);
	},

	_expandRomaSuffix: function(str, pairs) {
		var match = /(.*?)([a-z]{1,2})$/.exec(str);
		if (match) {
			var result = [];
			var body = match[1];
			var suffix = match[2];
			for (var p = 0; p < pairs.length; p++) {
				var pair = pairs[p];
				var roma = pair[0];
				var kana = pair[1];
				for (var i = 0; i < roma.length; i++) {
					if (roma[i].indexOf(suffix) == 0) {
						var term = body + kana[i];
						var j = result.length - 1;
						for (; j >= 0; j--) {
							if (result[j] == term) break;
						}
						if (j < 0) result.push(term);
					}
				}
			}
			if (result.length > 0) {
				if (body.length > 0 && suffix.length == 1)
					result.push(body + 'ッ');
				return result;
			}
		}
		return [str];
	}
}
