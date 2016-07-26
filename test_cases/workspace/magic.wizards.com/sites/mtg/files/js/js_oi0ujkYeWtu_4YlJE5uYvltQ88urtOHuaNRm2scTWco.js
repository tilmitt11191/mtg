(function(window){

/* !-- Static Properties -- */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
	ShareButton.socialMediaURLs = {
			FACEBOOK    : "http://www.facebook.com/sharer.php?u={URL}" /*  + "&media={IMAGE}&description={DESCRIPTION}" */,
			TWITTER     : "https://twitter.com/intent/tweet?url={URL}" /*  + "&amp;text={DESCRIPTION}" */,
			GOOGLE_PLUS : "https://plus.google.com/share?url={URL}"
		};




/* !-- Static Methods -- */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
	
	/* -- Shares an URL for a defined social media -- */
	/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
	ShareButton.shareURL = function(url, socialMedia) {
		window.open(ShareButton.getShareURL(url, socialMedia), socialMedia, "menubar=no,toolbar=no,resizable=no,scrollbars=no,height=400,width=600");
	};
	
	
	
	
	/* -- Gets the share URL -- */
	/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
	ShareButton.getShareURL = function(url, socialMedia) {
		return ShareButton.socialMediaURLs[socialMedia.toUpperCase()].replace(/\{URL\}/gi, encodeURIComponent(url))/* .replace(/\{IMAGE\}/gi, "").replace(/\{DESCRIPTION\}/gi, "") */;
	};
	
	
	
	
	/* !-- Creates a Base64 Object (Should be created in core.js, but causes a undefined exception) -- */
	/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
	if (Base64 == undefined) {
		var Base64 = {_keyStr:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",encode:function(e){var t="";var n,r,i,s,o,u,a;var f=0;e=Base64._utf8_encode(e);while(f<e.length){n=e.charCodeAt(f++);r=e.charCodeAt(f++);i=e.charCodeAt(f++);s=n>>2;o=(n&3)<<4|r>>4;u=(r&15)<<2|i>>6;a=i&63;if(isNaN(r)){u=a=64}else if(isNaN(i)){a=64}t=t+this._keyStr.charAt(s)+this._keyStr.charAt(o)+this._keyStr.charAt(u)+this._keyStr.charAt(a)}return t},decode:function(e){var t="";var n,r,i;var s,o,u,a;var f=0;e=e.replace(/[^A-Za-z0-9\+\/\=]/g,"");while(f<e.length){s=this._keyStr.indexOf(e.charAt(f++));o=this._keyStr.indexOf(e.charAt(f++));u=this._keyStr.indexOf(e.charAt(f++));a=this._keyStr.indexOf(e.charAt(f++));n=s<<2|o>>4;r=(o&15)<<4|u>>2;i=(u&3)<<6|a;t=t+String.fromCharCode(n);if(u!=64){t=t+String.fromCharCode(r)}if(a!=64){t=t+String.fromCharCode(i)}}t=Base64._utf8_decode(t);return t},_utf8_encode:function(e){e=e.replace(/\r\n/g,"\n");var t="";for(var n=0;n<e.length;n++){var r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r)}else if(r>127&&r<2048){t+=String.fromCharCode(r>>6|192);t+=String.fromCharCode(r&63|128)}else{t+=String.fromCharCode(r>>12|224);t+=String.fromCharCode(r>>6&63|128);t+=String.fromCharCode(r&63|128)}}return t},_utf8_decode:function(e){var t="";var n=0;var r=c1=c2=0;while(n<e.length){r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r);n++}else if(r>191&&r<224){c2=e.charCodeAt(n+1);t+=String.fromCharCode((r&31)<<6|c2&63);n+=2}else{c2=e.charCodeAt(n+1);c3=e.charCodeAt(n+2);t+=String.fromCharCode((r&15)<<12|(c2&63)<<6|c3&63);n+=3}}return t}};
	}
	
	
	
	
	/* -- Gets the shares for an URL -- */
	/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
	ShareButton.getShares = function(url, socialMedia, callback) {
		var getSharesURL;
		var base64URL = Base64.encode(url);
		
		switch(socialMedia) {
			case "FACEBOOK":
				getSharesURL = "/facebook/fbUrlLikes/" + base64URL;
				break;
			
			case "TWITTER":
				getSharesURL = "/twitter/tweets/" + base64URL;
				break;
			
			case "GOOGLE_PLUS":
				getSharesURL = "/gplus/plusCount/" + base64URL;
				break;
			
			default:
				break;
		}
		
		(new ark.Ajax).send(getSharesURL, function(response){
			if ( callback && response !== null )
				callback(!response.error ? getCountForSocialMediaData(response, socialMedia) : null);
		}, "JSON");
	}




/* !-- Constructor -- */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
	function ShareButton(button, socialMedia) {
		var _button = button,
			_socialMedia = socialMedia,
			_shareURL;
		
		this.button            = function() { return _button; }
		this.socialMedia       = function() { return _socialMedia.toUpperCase(); }
		this.urlToShare        = function() { return _button.attributes.getNamedItem("data-share-url") ? _button.attributes.getNamedItem("data-share-url").value : document.URL; }
		this.shareCountElement = function() { return _button.querySelector(".share-count"); };
		
		init(this);
	}




/* !-- Private Methods -- */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
	
	/* -- Initializes the button and its behavior -- */
	/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
	function init(context) {
		// Sets the button properties
		if (context.button().ark == null) context.button().ark = new Object();
		context.button().ark.shareButton = { context: context };
		
		// Sets the button's URL
		if (context.button().nodeName.toLowerCase() == "a")
			context.button().setAttribute("href", ShareButton.getShareURL(context.urlToShare(), context.socialMedia()));
		
		// Adds the click event on the button
		context.button().onclick = function() {
			ark.ShareButton.shareURL(this.ark.shareButton.context.urlToShare(), this.ark.shareButton.context.socialMedia());
			
			// Tracks shared buttons for article pages
			if ( document.getElementById("page") && ( (/\barticle_detail\b/).test(document.getElementById("page").className) ) ) {
				var socialMediaTrackingStrings = {
						"FACEBOOK"    : "Facebook",
						"TWITTER"     : "Twitter",
						"GOOGLE_PLUS" : "Googleplus"
					};
				var socialMediaTrackingUsedString = socialMediaTrackingStrings[this.ark.shareButton.context.socialMedia()] ? socialMediaTrackingStrings[this.ark.shareButton.context.socialMedia()] : this.ark.shareButton.context.socialMedia();
				
				try {
					_gaq.push(['_trackEvent', 'Article', 'Share', socialMediaTrackingUsedString]);
				} catch(e) {
					console.error(e, ['_trackEvent', 'Article', 'Share', socialMediaTrackingUsedString]);
				}
			}
			
			return false;
		};
		
		// Adds the share counter in the button
		if ( context.shareCountElement() ) {
			if ( !(/loading\s/).test(context.shareCountElement().className) )
				context.shareCountElement().className = "loading " + context.shareCountElement().className;
			
			ark.ShareButton.getShares(context.urlToShare(), context.socialMedia(), function(shares) {
				context.shareCountElement().className = context.shareCountElement().className.replace(/loading\s/gi, "");
				
				if (shares != null) {
					var shareCountText;
					if ( context.shareCountElement().attributes.getNamedItem("data-share-count-label") ) {
						shareCountText = context.shareCountElement().attributes.getNamedItem("data-share-count-label").value.replace(/\{COUNT\}/gi, String(shares));
					} else {
						shareCountText = String(shares);
					}

                    while(context.shareCountElement().hasChildNodes()) {
                        context.shareCountElement().removeChild(context.shareCountElement().lastChild);
                    }
					context.shareCountElement().appendChild(document.createTextNode(shareCountText));
				}
			});
		}
	}
	
	
	
	
	/* -- Gets the share count from a specific social media -- */
	/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
	function getCountForSocialMediaData(data, socialMedia) {
		return data ? String(data[0]) : String(0);
	}	




/* -- Adds the object -- */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
	if (!window.ark) window.ark = new Object();
	
	if (!window.ark.ShareButton)
		window.ark.ShareButton = ShareButton;
	
	
	// Initializes the page sharing buttons
	ark.Events.add(window, "load", function() {
		var i, shareMenuButton;
		
		var toggle = function() {
			if ( !(/\bopened\b/).test(this.className) ) {
				this.className = this.className + " opened";
			} else {
				this.className = this.className.replace(/\bopened\b/gi, "").trim();
			}
		}
		
		var shareMenuButtonClick = function() {
			this.parentNode.toggle();
		};
		
		// Manages the popup menu
		var shareMenus = document.querySelectorAll(".sharing");
		for ( i = 0; i < shareMenus.length; i++ ) {
			shareMenus[i].toggle = toggle;
			shareMenuButton = shareMenus[i].querySelector(".share-article");
			if (shareMenuButton) {
				ark.Events.add(shareMenuButton, "click", shareMenuButtonClick);
			}
		}
		
		// Manages Facebook buttons
		var facebookButtons = document.querySelectorAll(".social-share .facebook");
		for ( i = 0; i < facebookButtons.length; i++ ) {
			new ark.ShareButton(facebookButtons[i], "FACEBOOK");
		}
		
		// Manages Twitter buttons
		var twitterButtons = document.querySelectorAll(".social-share .twitter");
		for ( i = 0; i < twitterButtons.length; i++ ) {
			new ark.ShareButton(twitterButtons[i], "TWITTER");
		}
		
		// Manages Google Plus buttons
		var googlePlusButtons = document.querySelectorAll(".social-share .google");
		for ( i = 0; i < googlePlusButtons.length; i++ ) {
			new ark.ShareButton(googlePlusButtons[i], "GOOGLE_PLUS");
		}
		
		
		// Manages the decklist sharing buttons
		var decklistButtons = document.querySelectorAll(".st_twitter, .st_facebook");
		
		for ( i = 0; i < decklistButtons.length; i++ ) {
			decklistButtons[i].onclick = function() {
				var url = this.attributes.getNamedItem("st_url") ? this.attributes.getNamedItem("st_url").value : null;
				var socialMedia;
				
				if ( (/st_facebook/).test(this.className) )
					socialMedia = "FACEBOOK";
				if ( (/st_twitter/).test(this.className) )
					socialMedia = "TWITTER";
				
				if ( url && socialMedia )
					ark.ShareButton.shareURL(url, socialMedia);
					
				return false;
			};
		}
	});

    // Update sharing buttons after query ajax
    ark.updateSocialButton = function() {
        var i, shareMenuButton;

        var toggle = function() {
            if ( !(/\bopened\b/).test(this.className) ) {
                this.className = this.className + " opened";
            } else {
                this.className = this.className.replace(/\bopened\b/gi, "").trim();
            }
        }

        var shareMenuButtonClick = function() {
            this.parentNode.toggle();
        };
        // Manages the popup menu
        var shareMenus = document.querySelectorAll(".sharing");
        for ( i = 0; i < shareMenus.length; i++ ) {
            shareMenus[i].toggle = toggle;
            shareMenuButton = shareMenus[i].querySelector(".share-article");
            if (shareMenuButton) {
                ark.Events.add(shareMenuButton, "click", shareMenuButtonClick);
            }
        }

        // Manages Facebook buttons
        var facebookButtons = document.querySelectorAll(".social-share .facebook");
        for ( var i = 0; i < facebookButtons.length; i++ ) {
            new ark.ShareButton(facebookButtons[i], "FACEBOOK");
        }

        // Manages Twitter buttons
        var twitterButtons = document.querySelectorAll(".social-share .twitter");
        for ( var i = 0; i < twitterButtons.length; i++ ) {
            new ark.ShareButton(twitterButtons[i], "TWITTER");
        }

        // Manages Google Plus buttons
        var googlePlusButtons = document.querySelectorAll(".social-share .google");
        for ( var i = 0; i < googlePlusButtons.length; i++ ) {
            new ark.ShareButton(googlePlusButtons[i], "GOOGLE_PLUS");
        }


        // Manages the decklist sharing buttons
        var decklistButtons = document.querySelectorAll(".st_twitter, .st_facebook");

        for ( var i = 0; i < decklistButtons.length; i++ ) {
            decklistButtons[i].onclick = function() {
                var url = this.attributes.getNamedItem("st_url") ? this.attributes.getNamedItem("st_url").value : null;
                var socialMedia;

                if ( (/st_facebook/).test(this.className) )
                    socialMedia = "FACEBOOK";
                if ( (/st_twitter/).test(this.className) )
                    socialMedia = "TWITTER";

                if ( url && socialMedia )
                    ark.ShareButton.shareURL(url, socialMedia);

                return false;
            };
        }
    }
}(window));
;
(function ($) {
  Drupal.behaviors.decklist = {
    /**
     * Decklist Charts/Stats Builder
     * Method responsible for building the stats/graphs for the decklist stats feature.
     *
     * @param deck_name str
     *  The name of the deck that we're going to attach the stats to.
     */
    updateCharts: function (deck_name, subid) {
      var element = Drupal.behaviors.decklist.getElementByIdAndSubid(deck_name, subid);
      $(element).find(' .chart').each(function () {
        $(this).html('');
      });

      if(subid != undefined)  {
        // Double stuff fix
        // @todo must find the reason why these data are sometime doubled and fix it, instead of trapping it here.
        if(Drupal.settings.wiz_bean_content_deck_list_stats[deck_name].manacost.counts.length > 8) {
          var nb = Drupal.settings.wiz_bean_content_deck_list_stats[deck_name].manacost.counts.length;
          for(var i = nb - 1; i >= nb/2; i--) {
            Drupal.settings.wiz_bean_content_deck_list_stats[deck_name].manacost.counts.splice(i, 1);
            Drupal.settings.wiz_bean_content_deck_list_stats[deck_name].manacost.labels.splice(i, 1);
          }
        }
        if(Drupal.settings.wiz_bean_content_deck_list_stats[deck_name].color.counts.length > 8) {
          var nb = Drupal.settings.wiz_bean_content_deck_list_stats[deck_name].color.counts.length;
          for(var i = nb - 1; i >= nb/2; i--) {
            Drupal.settings.wiz_bean_content_deck_list_stats[deck_name].color.counts.splice(i, 1);
            Drupal.settings.wiz_bean_content_deck_list_stats[deck_name].color.labels.splice(i, 1);
          }
        }
        if(Drupal.settings.wiz_bean_content_deck_list_stats[deck_name].type.counts.length > 8) {
          var nb = Drupal.settings.wiz_bean_content_deck_list_stats[deck_name].type.counts.length;
          for(var i = nb - 1; i >= nb/2; i--) {
            Drupal.settings.wiz_bean_content_deck_list_stats[deck_name].type.counts.splice(i, 1);
            Drupal.settings.wiz_bean_content_deck_list_stats[deck_name].type.labels.splice(i, 1);
          }
        }

        var idStr = (deck_name != "") ? "#" + deck_name : "";
        wizBar(idStr+ '[subid="' +subid+ '"] .chart.by-manacost', Drupal.settings.wiz_bean_content_deck_list_stats[deck_name].manacost, Drupal.t(''));
        wizPie(idStr+ '[subid="' +subid+ '"] .chart.by-color', Drupal.settings.wiz_bean_content_deck_list_stats[deck_name].color, Drupal.t(''));
        wizPie(idStr+ '[subid="' +subid+ '"] .chart.by-type', Drupal.settings.wiz_bean_content_deck_list_stats[deck_name].type, Drupal.t(''));
      }
    },

    /**
     * Make the Decklist render appropriately with equal heights.
     * @param group
     * @returns {boolean}
     */
    equalHeight: function (deck_target, item) {

      if ($(window).width() < 760) {
        return false;
      }

      if (document.readyState == "complete") {
        var container = $('#' + deck_target);
        // initialize
        container.masonry({
          itemSelector: item
        });
      }
      else {
        $(window).load(function () {
          var container = $('#' + deck_target);
          // initialize
          container.masonry({
            itemSelector: item
          });
        });
      }
    },

    /**
     * Fetch a new samplehand by making an ajax call to an internal URL property.
     *
     * @param link dom
     *  Dom element containing a data-href parameter that we pull out for the ajax call.
     */
    dealSampleHand: function (link, deck_target, subid) {
      // Hid the sample hand that is currently on the screen.

      var targetBaseElement = $(Drupal.behaviors.decklist.getElementByIdAndSubid(deck_target, subid)).find(".toggle-samplehand");

      $(targetBaseElement).find(' a.sample-hand-redeal').html("Loading...");
      $(targetBaseElement).find(' #responsivDIV').remove();

      // Get the url we're going to used to make the ajax callback from the link object passed in.
      var url = link.attr('data-href');

      var callbackUrl = Drupal.settings.basePath + Drupal.settings.pathPrefix + url;

      // Make the ajax call to get the new sample hand so we can write it back to the page.
      $.ajax({
        url: callbackUrl,
        dataType: 'json',
        success: function (data) {
          // Success, yey, we have a response!
          $(targetBaseElement).html('' +
          '<a href="" class="button sample-hand-redeal" data-href="' + url + '">' + Drupal.t('Deal Another Hand') + '</a>' +
          '<div class="sample-hand-carousel"><ul></ul></div>');

          $(targetBaseElement).find(' a.sample-hand-redeal').bind('click', function (event) {
            event.preventDefault();
            Drupal.behaviors.decklist.dealSampleHand($(this), deck_target, subid);
          });

          // Creates each card elements
          for (var i = 0; i < data.length; i++) {
            $(targetBaseElement).find('.sample-hand-carousel ul').eq(0).append('<li data-title="' + data[i].featured_title + '">' + data[i].featured_image + '<br /><span class="label">' + data[i].featured_title + '</span></li>');
          }
		  
          // Creates the cards carousel
          jQuery(targetBaseElement).find('.sample-hand-carousel ul').eq(0).owlCarousel({
            center            : true,
            controlsClass     : "controls",
            dotClass          : "page",
            dots              : false,
            dotsClass         : "pager",
            loop              : false,
            mouseDrag         : false,
            nav               : true,
            navClass          : ["previous", "next"],
            navContainerClass : "nav",
            navText           : ["&lt;","&gt;"],
            responsive        : {
                0:    { items : 1, startPosition: 0 },
                480:  { items : 3, startPosition: 1 },
                768:  { items : 3, startPosition: 1 },
                1024: { items : 4, startPosition: 1 }
              }
          });
      
          // Removes the loading class on the container
          $(targetBaseElement).removeClass("loading");
        }
      });
    },

    /**
     * Toggle between multiple decks that currently live on the page. This method gets
     * invoked when the "Select Deck" select element is changed.
     *
     * @param deck_target string
     *  The option that was chosen during the select change. Tells us which deck to show.
     *
     * @see local method attach:
     */
    deckChange: function (selected_deck_name, subid) {
      var element = Drupal.behaviors.decklist.getElementByIdAndSubid(selected_deck_name, subid);

      // Hide all deck groups when this is initially activated.
      $(element).parent('.content').find('.deck-group').hide();

      // Show selected deck group passed in.
      $(element).show();

      $(element).find(' select.sort-decklist').each(function () {
        this.selectedIndex = 0;
      });

      $(element).find('div.sortedContainer').hide();
      $(element).find('div.sortedContainer:eq(0)').show();

      $(element).find('.toggle-text').show();
      $(element).find('.subNav .decklist').addClass('active');

      // HANDLE HOVER STATES FOR EACH CARD LINK
      $(element).find('.deck-list-link').hover(function (event) {
        event.preventDefault();
        Drupal.behaviors.decklist.cardHover(selected_deck_name, subid, $(this));
      },
      function () {
        Drupal.behaviors.decklist.cardUnhover(selected_deck_name, subid);
      });
      Drupal.behaviors.decklist.equalHeight(selected_deck_name + " .sorted-by-overview-container", '.masonry');
      Drupal.behaviors.decklist.updateCharts(selected_deck_name, subid);
      Drupal.behaviors.hoverFuncDecklist.attach();

      $('#' + selected_deck_name).find('a.sample-hand-redeal').on('click', function (event) {
        event.preventDefault();
        Drupal.behaviors.decklist.dealSampleHand($(this), selected_deck_name, subid);
      });
    },

    /**
     * Provides functionality that displays the card currently being hovered in the decklist.
     * @param card
     */
    cardHover: function (deck_target, subid, card) {
        var data_src = $(card).attr('data-src');
        var data_original = $(card).attr('data-src');
        var data_mp4 = $(card).attr('data-mp4');
        var data_webm = $(card).attr('data-webm');
        var data_gif = $(card).attr('data-gif');
        // Getting the element by its id AND subid to prevent problems with the same id multiple time
        var element = Drupal.behaviors.decklist.getElementByIdAndSubid(deck_target, subid);
        if (data_mp4.search(".mp4") < 0) {
            $(element).find('.deck-list-img .card-image video').remove();
            $(element).find('.deck-list-img .card-image img').remove();
            $(element).find('.deck-list-img .card-image').append('<img src="' + data_src + '" data-original="' + data_original + '">');
        } else {
            $(element).find('.deck-list-img .card-image video').remove();
            $(element).find('.deck-list-img .card-image img').remove();
            $(element).find('.deck-list-img .card-image').append('<video autoplay="autoplay" muted="muted" loop="loop" width="223px" poster="' + data_original + '"><source type="video/webm" src="' + data_webm + '"><source type="video/mp4" src="' + data_mp4 + '"><img src="' + data_gif + '" data-original="' + data_original + '"></video>');
            setTimeout(function() {
	            ark.handleVideoCards($(element).find(".deck-list-img")[0]);
            }, 1);
        }
    },

    cardUnhover: function (deck_target, subid) {
      var element = Drupal.behaviors.decklist.getElementByIdAndSubid(deck_target, subid);
      var data_original = $(element).find('.deck-list-img img').attr('data-original');
      if (data_original.length > 0) {
        // Getting the element by its id AND subid to prevent problems with the same id multiple time
        $(element).find('.deck-list-img img').attr('src', data_original);
        //$('#' + deck_target).find('.deck-list-img img').attr('src', data_original);
      }
    },

    /**
     * Implement attach method on this behavior.
     * @param context
     * @param settings
     */
    attach: function (context, settings) {

      // Iterate through all decks that are on the current page.
      $('div.bean_block_deck_list').each(function () {

        // Make sure the deck has some data before we attempt to parse it.
        if ($(this).length > 0) {

          // Obtain the deck ID for this deck group so we can target it directly. Works in parallel
          // with the parent_portal_wrapper where needed.
          var deck_name = $(this).find('.deck-group').attr('id');
          var subid = $(this).find('.deck-group').attr('subid');

          // UPDATE CHARTS FOR THIS DECK
          // ----------------------------------------------------------------------------
          Drupal.behaviors.decklist.updateCharts(deck_name, subid);

          // UPDATE EQUAL MASONRY HEIGHTS FOR THIS DECK
          // ----------------------------------------------------------------------------
          Drupal.behaviors.decklist.equalHeight(deck_name + " .sorted-by-overview-container", ".masonry");

          $(this).find('.deck-group:eq(0)').show();
          $(this).find('#edit-deck-list-sort-by option:eq(0)').attr("selected", "selected");

          // HANDLE DECKLIST DECK TOGGLE FROM SELECT LIST WHEN AVAILABLE (FOR MULTIPLE DECKS)
          // ----------------------------------------------------------------------------
          $(this).find('.selectDeck select').change(function () {
            var selected_deck_name = $(this).find('option:selected').attr('value');
            Drupal.behaviors.decklist.deckChange(selected_deck_name, subid);
          });

          // HANDLE DECKLIST TOGGLE FOR DISPLAY MODE (OVERVIEW, COLOR, COST, ETC)
          // ----------------------------------------------------------------------------
          $(this).find('select.form-select').change(function () {
            var display = $(this).find("option:selected").val().toLowerCase();
            var parent_group = $(this).closest('.deck-group');
            parent_group = $(parent_group).attr('id');
            $('#' + parent_group).find('div.sortedContainer').hide();
            $('#' + parent_group).find('.sorted-by-' + display + '-container').show();

            // Sideboard block display based on display type.
            if (display == 'overview') {
              $('#' + parent_group).find(".sorted-by-sideboard-container").show();
            }
            else {
              $('#' + parent_group).find(".sorted-by-sideboard-container").hide();
            }

            // Time to re-masonry the board.
            Drupal.behaviors.decklist.equalHeight(deck_name + " .sorted-by-" + display + "-container", ".masonry");
          });

          // HANDLE HOVER STATES FOR EACH CARD LINK
          // ----------------------------------------------------------------------------
          $(this).find('.deck-list-link').hover(function (event) {
            event.preventDefault();
            Drupal.behaviors.decklist.cardHover(deck_name, subid, $(this));
          },
          function () {
            Drupal.behaviors.decklist.cardUnhover(deck_name, subid);
          });

            // make commander title display image
          $(this).find('.commander-card-header').hover(function (event) {
            event.preventDefault();
             var data_original = $('#' + deck_name).find('.deck-list-img img').attr('data-original');
             if (data_original.length > 0) {
               $('#' + deck_name).find('.deck-list-img img').attr('src', data_original);
             }
          });
		
		
		// Adds a click event that opens the card in a lightbox when screen is too small
		// ----------------------------------------------------------------------------
		jQuery(this).find(".deck-list-link").click(function(e) {
			var showUnderWidth = 768;
			
			if ( document.documentElement.offsetWidth < showUnderWidth ) {
				
				var htmlContent   = '<a href="' + $(this).attr("href") + '" target="_blank">',
					data_src      = $(this).attr("data-src"),
					data_original = $(this).attr("data-src"),
					data_mp4      = $(this).attr("data-mp4"),
					data_webm     = $(this).attr("data-webm"),
					data_gif      = $(this).attr("data-gif");
				
				if (data_mp4.search(".mp4") < 0) {
					htmlContent += '<img src="' + data_src + '" data-original="' + data_original + '" alt="" />';
				} else {
					htmlContent += '<a href="' + $(this).attr("href") + '"><video autoplay="autoplay" muted="muted" loop="loop" width="223px" poster="' + data_original + '"><source type="video/webm" src="' + data_webm + '"><source type="video/mp4" src="' + data_mp4 + '"><img src="' + data_gif + '" data-original="' + data_original + '"></video>';
					setTimeout(function() {
						ark.handleVideoCards($(element).find(".deck-list-img")[0]);
					}, 1);
				}
				
				htmlContent += '</a>';
				
				
				jQuery.fancybox.open({
					content: htmlContent,
					padding: 0,
					wrapCSS: "decklist-mobile-lightbox"
				});
				
				e.preventDefault();
			} else {
				if ( ark.isMobile() && !(/iPhone|iPad|iPod/i).test(navigator.userAgent) ) {
					if ( $(this)[0] !== window.decklistClickedItem ) {
						window.decklistClickedItem = $(this)[0];
						e.preventDefault();
					} else {
						window.decklistClickedItem = null;
					}
				}
			}
		});
		
		
		// Tracks each link to the gatherer
		// ----------------------------------------------------------------------------
		$(this).find('.deck-list-link').click(function() {
			try {
				_gaq.push(['_trackEvent', 'Gatherer', $(this).html(), $(this).attr("href")]);
			} catch(e) {
				console.error(e, ['_trackEvent', 'Gatherer', $(this).html(), $(this).attr("href")]);
			}
		});

          // DISABLE ALL CARD LINKS
          // ----------------------------------------------------------------------------
          //$(this).find(".deck-list-link").on("click", function (event) {
          //  event.preventDefault();
          //});

          // HANDLE DECKLIST SUBNAV TOGGLE (DECKLIST, STATS, SAMPLE HAND)
          // ----------------------------------------------------------------------------
          $(this).find(".subNav a").bind("click", function (event) {
            event.preventDefault();
          });

          // HANDLE RE-DEAL BUTTON ACTION
          // ----------------------------------------------------------------------------
          $(this).find('a.sample-hand-redeal').bind('click', function (event) {
            event.preventDefault();
            Drupal.behaviors.decklist.dealSampleHand($(this), deck_name, subid);
          });
        }
      });
    },
    getElementByIdAndSubid: function(id, subid) {
      var idStr = (id != "") ? "#" + id : "";
      return $(idStr + "[subid='" +subid+ "']");
    }
  };


  Drupal.behaviors.hoverFuncDecklist = {
    attach: function (context, settings) {

      if ($(window).width() < 765) {
        return false;
      }

      $('div.chart.by-type, div.chart.by-color').each(function () {

        $(this).find('.tick').each(function (i) {
          $(this).attr('class', $(this).attr('class') + ' wizhvr_' + i).hide();
        });

        $(this).find('.icon-bg').each(function (i) {
          $(this).attr('class', $(this).attr('class') + ' wizhvr_' + i).hide();
        });

        $(this).find('text.label').each(function (i) {
          $(this).attr('class', $(this).attr('class') + ' wizhvr_' + i).hide();
        });

        $(this).find('text.data').each(function (i) {
          $(this).attr('class', $(this).attr('class') + ' wizhvr_' + i).hide();
        });

        $(this).find('.iconsimg').each(function (i) {
          $(this).attr('class', $(this).attr('class') + ' wizhvr_' + i).hide();
        });
        $(this).find('.multi-dots').each(function (i) {
          $(this).attr('class', $(this).attr('class') + ' wizhvr_' + i).hide();
        });

        $(this).find('path').each(function (i) {
          $(this).attr('class', 'wizhvr_' + i);
        });

      });

      $('div.chart.by-type, div.chart.by-color').find('path').hover(function () {

        var activeClass = $(this).attr('class');
        $(this).closest('div.chart').find('.' + activeClass).show();
      }, function () {
        var activeClass = $(this).attr('class');
        $(this).closest('div.chart').find('g.icons .' + activeClass).hide();
      });

    }
  };


  Drupal.behaviors.toggleDecklist = {
    attach: function (context, settings) {
      $('div.bean_block_deck_list').each(function () {
        // SHOW INITIAL GROUPS
        $(this).find('.toggle-subnav:eq(0)').show();
        $(this).find('.subNav > a:eq(0)').addClass('active');

        // HANDLE CLICK EVENTS TO TOGGLE TABS
        $(this).find('.subNav > a').bind("click", function (event) {
          if ($(this).hasClass("active")) return false;
          var parent_group = $(this).parents('.deck-group');
          var deck_name = parent_group.attr("id");
          $(parent_group).find('.subNav > a').removeClass('active');
          $(this).addClass('active');
          var currIndex = $(this).index();
          parent_group.children('.toggle-subnav').hide();
          parent_group.children('.toggle-subnav').eq(currIndex).show();
          $(parent_group).find('a.sample-hand-redeal').trigger("click");
          Drupal.behaviors.decklist.equalHeight(deck_name + " .sorted-by-overview-container", '.masonry');
        });
      });
    }
  };
})(jQuery);




window.addEventListener("load", function() {
	function placeDecklistCard() {
		var cards = document.querySelectorAll(".deck-list-img"),
			cardTopMargin = 65,
			cardBottomMargin = 15,
			cardRect, contentElement, contentElementRect, nextPos;
		
		for ( var i = 0; i < cards.length; i++ ) {
			contentElement = cards[i].parentNode.querySelector(".deck-list-text");
			cardRect = cards[i].getBoundingClientRect();
			contentElementRect = contentElement.getBoundingClientRect();
			
			if (cards[i].originalTop === undefined)
				cards[i].originalTop = cards[i].offsetTop;
			
			if ( contentElementRect.top < cardTopMargin ) {
				nextPos = -contentElementRect.top + cards[i].originalTop + cardTopMargin;
				
				if (nextPos + cardRect.height + cardBottomMargin >= contentElementRect.height + cards[i].originalTop)
					nextPos = contentElementRect.height - cardRect.height + cards[i].originalTop - cardBottomMargin;
			} else {
				nextPos = cards[i].originalTop;
			}
			
			cards[i].style.top = String(nextPos) + "px";
		}
	}

	
	if ( document.querySelector(".deck-list-img") ) {
		window.addEventListener("load", placeDecklistCard, false);
		window.addEventListener("scroll", placeDecklistCard, false);
		window.addEventListener("resize", placeDecklistCard, false);
	}	
}, false);

function wiz_bean_content_deck_list_generate_file(obj) {
  var breakStr = "[b]";
  var output = "";
  var decklist = obj.parentNode.parentNode;
  var vCard = decklist.querySelectorAll(".sorted-by-overview-container .row");
  var vSideboard = decklist.querySelectorAll(" .sorted-by-sideboard-container .row");
  for(var i = 0; i < vCard.length; i++)
  {
    var count = vCard[i].querySelector(".card-count").innerHTML;
    var name = vCard[i].querySelector(".card-name a").innerHTML;
    output += count + " " + name + breakStr;
  }
  output += breakStr + breakStr;
  for(var i = 0; i < vSideboard.length; i++)
  {
    var count = vSideboard[i].querySelector(".card-count").innerHTML;
    var name = vSideboard[i].querySelector(".card-name a").innerHTML;
    output += count + " " + name + breakStr;
  }
  var title = decklist.querySelector(".deck-meta h4").innerHTML;
     
  $form = jQuery(obj).prev("form");
  jQuery("input[name='title']",$form).val(encodeURIComponent(title));
  jQuery("input[name='content']",$form).val(encodeURIComponent(output));
  jQuery($form).submit();
}

function wiz_bean_content_deck_list_safe_str(str) {
  str = str.replace("/", "\/");
  return str;
};
/*!
 * Masonry PACKAGED v3.1.1
 * Cascading grid layout library
 * http://masonry.desandro.com
 * MIT License
 * by David DeSandro
 */

(function(t){"use strict";function e(t){if(t){if("string"==typeof n[t])return t;t=t.charAt(0).toUpperCase()+t.slice(1);for(var e,o=0,r=i.length;r>o;o++)if(e=i[o]+t,"string"==typeof n[e])return e}}var i="Webkit Moz ms Ms O".split(" "),n=document.documentElement.style;"function"==typeof define&&define.amd?define(function(){return e}):t.getStyleProperty=e})(window),function(t){"use strict";function e(t){var e=parseFloat(t),i=-1===t.indexOf("%")&&!isNaN(e);return i&&e}function i(){for(var t={width:0,height:0,innerWidth:0,innerHeight:0,outerWidth:0,outerHeight:0},e=0,i=s.length;i>e;e++){var n=s[e];t[n]=0}return t}function n(t){function n(t){if("string"==typeof t&&(t=document.querySelector(t)),t&&"object"==typeof t&&t.nodeType){var n=r(t);if("none"===n.display)return i();var h={};h.width=t.offsetWidth,h.height=t.offsetHeight;for(var u=h.isBorderBox=!(!a||!n[a]||"border-box"!==n[a]),p=0,f=s.length;f>p;p++){var d=s[p],c=n[d],l=parseFloat(c);h[d]=isNaN(l)?0:l}var m=h.paddingLeft+h.paddingRight,y=h.paddingTop+h.paddingBottom,g=h.marginLeft+h.marginRight,v=h.marginTop+h.marginBottom,_=h.borderLeftWidth+h.borderRightWidth,b=h.borderTopWidth+h.borderBottomWidth,E=u&&o,L=e(n.width);L!==!1&&(h.width=L+(E?0:m+_));var S=e(n.height);return S!==!1&&(h.height=S+(E?0:y+b)),h.innerWidth=h.width-(m+_),h.innerHeight=h.height-(y+b),h.outerWidth=h.width+g,h.outerHeight=h.height+v,h}}var o,a=t("boxSizing");return function(){if(a){var t=document.createElement("div");t.style.width="200px",t.style.padding="1px 2px 3px 4px",t.style.borderStyle="solid",t.style.borderWidth="1px 2px 3px 4px",t.style[a]="border-box";var i=document.body||document.documentElement;i.appendChild(t);var n=r(t);o=200===e(n.width),i.removeChild(t)}}(),n}var o=document.defaultView,r=o&&o.getComputedStyle?function(t){return o.getComputedStyle(t,null)}:function(t){return t.currentStyle},s=["paddingLeft","paddingRight","paddingTop","paddingBottom","marginLeft","marginRight","marginTop","marginBottom","borderLeftWidth","borderRightWidth","borderTopWidth","borderBottomWidth"];"function"==typeof define&&define.amd?define(["get-style-property/get-style-property"],n):t.getSize=n(t.getStyleProperty)}(window),function(t){"use strict";var e=document.documentElement,i=function(){};e.addEventListener?i=function(t,e,i){t.addEventListener(e,i,!1)}:e.attachEvent&&(i=function(e,i,n){e[i+n]=n.handleEvent?function(){var e=t.event;e.target=e.target||e.srcElement,n.handleEvent.call(n,e)}:function(){var i=t.event;i.target=i.target||i.srcElement,n.call(e,i)},e.attachEvent("on"+i,e[i+n])});var n=function(){};e.removeEventListener?n=function(t,e,i){t.removeEventListener(e,i,!1)}:e.detachEvent&&(n=function(t,e,i){t.detachEvent("on"+e,t[e+i]);try{delete t[e+i]}catch(n){t[e+i]=void 0}});var o={bind:i,unbind:n};"function"==typeof define&&define.amd?define(o):t.eventie=o}(this),function(t){"use strict";function e(t){"function"==typeof t&&(e.isReady?t():r.push(t))}function i(t){var i="readystatechange"===t.type&&"complete"!==o.readyState;if(!e.isReady&&!i){e.isReady=!0;for(var n=0,s=r.length;s>n;n++){var a=r[n];a()}}}function n(n){return n.bind(o,"DOMContentLoaded",i),n.bind(o,"readystatechange",i),n.bind(t,"load",i),e}var o=t.document,r=[];e.isReady=!1,"function"==typeof define&&define.amd?(e.isReady="function"==typeof requirejs,define(["eventie/eventie"],n)):t.docReady=n(t.eventie)}(this),function(){"use strict";function t(){}function e(t,e){for(var i=t.length;i--;)if(t[i].listener===e)return i;return-1}var i=t.prototype;i.getListeners=function(t){var e,i,n=this._getEvents();if("object"==typeof t){e={};for(i in n)n.hasOwnProperty(i)&&t.test(i)&&(e[i]=n[i])}else e=n[t]||(n[t]=[]);return e},i.flattenListeners=function(t){var e,i=[];for(e=0;t.length>e;e+=1)i.push(t[e].listener);return i},i.getListenersAsObject=function(t){var e,i=this.getListeners(t);return i instanceof Array&&(e={},e[t]=i),e||i},i.addListener=function(t,i){var n,o=this.getListenersAsObject(t),r="object"==typeof i;for(n in o)o.hasOwnProperty(n)&&-1===e(o[n],i)&&o[n].push(r?i:{listener:i,once:!1});return this},i.on=i.addListener,i.addOnceListener=function(t,e){return this.addListener(t,{listener:e,once:!0})},i.once=i.addOnceListener,i.defineEvent=function(t){return this.getListeners(t),this},i.defineEvents=function(t){for(var e=0;t.length>e;e+=1)this.defineEvent(t[e]);return this},i.removeListener=function(t,i){var n,o,r=this.getListenersAsObject(t);for(o in r)r.hasOwnProperty(o)&&(n=e(r[o],i),-1!==n&&r[o].splice(n,1));return this},i.off=i.removeListener,i.addListeners=function(t,e){return this.manipulateListeners(!1,t,e)},i.removeListeners=function(t,e){return this.manipulateListeners(!0,t,e)},i.manipulateListeners=function(t,e,i){var n,o,r=t?this.removeListener:this.addListener,s=t?this.removeListeners:this.addListeners;if("object"!=typeof e||e instanceof RegExp)for(n=i.length;n--;)r.call(this,e,i[n]);else for(n in e)e.hasOwnProperty(n)&&(o=e[n])&&("function"==typeof o?r.call(this,n,o):s.call(this,n,o));return this},i.removeEvent=function(t){var e,i=typeof t,n=this._getEvents();if("string"===i)delete n[t];else if("object"===i)for(e in n)n.hasOwnProperty(e)&&t.test(e)&&delete n[e];else delete this._events;return this},i.emitEvent=function(t,e){var i,n,o,r,s=this.getListenersAsObject(t);for(o in s)if(s.hasOwnProperty(o))for(n=s[o].length;n--;)i=s[o][n],r=i.listener.apply(this,e||[]),(r===this._getOnceReturnValue()||i.once===!0)&&this.removeListener(t,i.listener);return this},i.trigger=i.emitEvent,i.emit=function(t){var e=Array.prototype.slice.call(arguments,1);return this.emitEvent(t,e)},i.setOnceReturnValue=function(t){return this._onceReturnValue=t,this},i._getOnceReturnValue=function(){return this.hasOwnProperty("_onceReturnValue")?this._onceReturnValue:!0},i._getEvents=function(){return this._events||(this._events={})},"function"==typeof define&&define.amd?define(function(){return t}):"undefined"!=typeof module&&module.exports?module.exports=t:this.EventEmitter=t}.call(this),function(t){"use strict";function e(){}function i(t){function i(e){e.prototype.option||(e.prototype.option=function(e){t.isPlainObject(e)&&(this.options=t.extend(!0,this.options,e))})}function o(e,i){t.fn[e]=function(o){if("string"==typeof o){for(var s=n.call(arguments,1),a=0,h=this.length;h>a;a++){var u=this[a],p=t.data(u,e);if(p)if(t.isFunction(p[o])&&"_"!==o.charAt(0)){var f=p[o].apply(p,s);if(void 0!==f)return f}else r("no such method '"+o+"' for "+e+" instance");else r("cannot call methods on "+e+" prior to initialization; "+"attempted to call '"+o+"'")}return this}return this.each(function(){var n=t.data(this,e);n?(n.option(o),n._init()):(n=new i(this,o),t.data(this,e,n))})}}if(t){var r="undefined"==typeof console?e:function(t){console.error(t)};t.bridget=function(t,e){i(e),o(t,e)}}}var n=Array.prototype.slice;"function"==typeof define&&define.amd?define(["jquery"],i):i(t.jQuery)}(window),function(t,e){"use strict";function i(t,e){return t[a](e)}function n(t){if(!t.parentNode){var e=document.createDocumentFragment();e.appendChild(t)}}function o(t,e){n(t);for(var i=t.parentNode.querySelectorAll(e),o=0,r=i.length;r>o;o++)if(i[o]===t)return!0;return!1}function r(t,e){return n(t),i(t,e)}var s,a=function(){if(e.matchesSelector)return"matchesSelector";for(var t=["webkit","moz","ms","o"],i=0,n=t.length;n>i;i++){var o=t[i],r=o+"MatchesSelector";if(e[r])return r}}();if(a){var h=document.createElement("div"),u=i(h,"div");s=u?i:r}else s=o;"function"==typeof define&&define.amd?define(function(){return s}):window.matchesSelector=s}(this,Element.prototype),function(t){"use strict";function e(t,e){for(var i in e)t[i]=e[i];return t}function i(t,i,n){function r(t,e){t&&(this.element=t,this.layout=e,this.position={x:0,y:0},this._create())}var s=n("transition"),a=n("transform"),h=s&&a,u=!!n("perspective"),p={WebkitTransition:"webkitTransitionEnd",MozTransition:"transitionend",OTransition:"otransitionend",transition:"transitionend"}[s],f=["transform","transition","transitionDuration","transitionProperty"],d=function(){for(var t={},e=0,i=f.length;i>e;e++){var o=f[e],r=n(o);r&&r!==o&&(t[o]=r)}return t}();e(r.prototype,t.prototype),r.prototype._create=function(){this.css({position:"absolute"})},r.prototype.handleEvent=function(t){var e="on"+t.type;this[e]&&this[e](t)},r.prototype.getSize=function(){this.size=i(this.element)},r.prototype.css=function(t){var e=this.element.style;for(var i in t){var n=d[i]||i;e[n]=t[i]}},r.prototype.getPosition=function(){var t=o(this.element),e=this.layout.options,i=e.isOriginLeft,n=e.isOriginTop,r=parseInt(t[i?"left":"right"],10),s=parseInt(t[n?"top":"bottom"],10);r=isNaN(r)?0:r,s=isNaN(s)?0:s;var a=this.layout.size;r-=i?a.paddingLeft:a.paddingRight,s-=n?a.paddingTop:a.paddingBottom,this.position.x=r,this.position.y=s},r.prototype.layoutPosition=function(){var t=this.layout.size,e=this.layout.options,i={};e.isOriginLeft?(i.left=this.position.x+t.paddingLeft+"px",i.right=""):(i.right=this.position.x+t.paddingRight+"px",i.left=""),e.isOriginTop?(i.top=this.position.y+t.paddingTop+"px",i.bottom=""):(i.bottom=this.position.y+t.paddingBottom+"px",i.top=""),this.css(i),this.emitEvent("layout",[this])};var c=u?function(t,e){return"translate3d("+t+"px, "+e+"px, 0)"}:function(t,e){return"translate("+t+"px, "+e+"px)"};r.prototype._transitionTo=function(t,e){this.getPosition();var i=this.position.x,n=this.position.y,o=parseInt(t,10),r=parseInt(e,10),s=o===this.position.x&&r===this.position.y;if(this.setPosition(t,e),s&&!this.isTransitioning)return this.layoutPosition(),void 0;var a=t-i,h=e-n,u={},p=this.layout.options;a=p.isOriginLeft?a:-a,h=p.isOriginTop?h:-h,u.transform=c(a,h),this.transition({to:u,onTransitionEnd:this.layoutPosition,isCleaning:!0})},r.prototype.goTo=function(t,e){this.setPosition(t,e),this.layoutPosition()},r.prototype.moveTo=h?r.prototype._transitionTo:r.prototype.goTo,r.prototype.setPosition=function(t,e){this.position.x=parseInt(t,10),this.position.y=parseInt(e,10)},r.prototype._nonTransition=function(t){this.css(t.to),t.isCleaning&&this._removeStyles(t.to),t.onTransitionEnd&&t.onTransitionEnd.call(this)},r.prototype._transition=function(t){var e=this.layout.options.transitionDuration;if(!parseFloat(e))return this._nonTransition(t),void 0;var i=t.to,n=[];for(var o in i)n.push(o);var r={};if(r.transitionProperty=n.join(","),r.transitionDuration=e,this.element.addEventListener(p,this,!1),(t.isCleaning||t.onTransitionEnd)&&this.on("transitionEnd",function(e){return t.isCleaning&&e._removeStyles(i),t.onTransitionEnd&&t.onTransitionEnd.call(e),!0}),t.from){this.css(t.from);var s=this.element.offsetHeight;s=null}this.css(r),this.css(i),this.isTransitioning=!0},r.prototype.transition=r.prototype[s?"_transition":"_nonTransition"],r.prototype.onwebkitTransitionEnd=function(t){this.ontransitionend(t)},r.prototype.onotransitionend=function(t){this.ontransitionend(t)},r.prototype.ontransitionend=function(t){t.target===this.element&&(this.removeTransitionStyles(),this.element.removeEventListener(p,this,!1),this.isTransitioning=!1,this.emitEvent("transitionEnd",[this]))},r.prototype._removeStyles=function(t){var e={};for(var i in t)e[i]="";this.css(e)};var l={transitionProperty:"",transitionDuration:""};return r.prototype.removeTransitionStyles=function(){this.css(l)},r.prototype.removeElem=function(){this.element.parentNode.removeChild(this.element),this.emitEvent("remove",[this])},r.prototype.remove=function(){if(!s||!parseFloat(this.layout.options.transitionDuration))return this.removeElem(),void 0;var t=this;this.on("transitionEnd",function(){return t.removeElem(),!0}),this.hide()},r.prototype.reveal=function(){delete this.isHidden,this.css({display:""});var t=this.layout.options;this.transition({from:t.hiddenStyle,to:t.visibleStyle,isCleaning:!0})},r.prototype.hide=function(){this.isHidden=!0,this.css({display:""});var t=this.layout.options;this.transition({from:t.visibleStyle,to:t.hiddenStyle,isCleaning:!0,onTransitionEnd:function(){this.css({display:"none"})}})},r.prototype.destroy=function(){this.css({position:"",left:"",right:"",top:"",bottom:"",transition:"",transform:""})},r}var n=document.defaultView,o=n&&n.getComputedStyle?function(t){return n.getComputedStyle(t,null)}:function(t){return t.currentStyle};"function"==typeof define&&define.amd?define(["eventEmitter/EventEmitter","get-size/get-size","get-style-property/get-style-property"],i):(t.Outlayer={},t.Outlayer.Item=i(t.EventEmitter,t.getSize,t.getStyleProperty))}(window),function(t){"use strict";function e(t,e){for(var i in e)t[i]=e[i];return t}function i(t){return"[object Array]"===p.call(t)}function n(t){var e=[];if(i(t))e=t;else if(t&&"number"==typeof t.length)for(var n=0,o=t.length;o>n;n++)e.push(t[n]);else e.push(t);return e}function o(t){return t.replace(/(.)([A-Z])/g,function(t,e,i){return e+"-"+i}).toLowerCase()}function r(i,r,p,c,l,m){function y(t,i){if("string"==typeof t&&(t=s.querySelector(t)),!t||!f(t))return a&&a.error("Bad "+this.settings.namespace+" element: "+t),void 0;this.element=t,this.options=e({},this.options),e(this.options,i);var n=++v;this.element.outlayerGUID=n,_[n]=this,this._create(),this.options.isInitLayout&&this.layout()}function g(t,i){t.prototype[i]=e({},y.prototype[i])}var v=0,_={};return y.prototype.settings={namespace:"outlayer",item:m},y.prototype.options={containerStyle:{position:"relative"},isInitLayout:!0,isOriginLeft:!0,isOriginTop:!0,isResizeBound:!0,transitionDuration:"0.4s",hiddenStyle:{opacity:0,transform:"scale(0.001)"},visibleStyle:{opacity:1,transform:"scale(1)"}},e(y.prototype,p.prototype),y.prototype._create=function(){this.reloadItems(),this.stamps=[],this.stamp(this.options.stamp),e(this.element.style,this.options.containerStyle),this.options.isResizeBound&&this.bindResize()},y.prototype.reloadItems=function(){this.items=this._getItems(this.element.children)},y.prototype._getItems=function(t){for(var e=this._filterFindItemElements(t),i=this.settings.item,n=[],o=0,r=e.length;r>o;o++){var s=e[o],a=new i(s,this,this.options.itemOptions);n.push(a)}return n},y.prototype._filterFindItemElements=function(t){t=n(t);for(var e=this.options.itemSelector,i=[],o=0,r=t.length;r>o;o++){var s=t[o];if(f(s))if(e){l(s,e)&&i.push(s);for(var a=s.querySelectorAll(e),h=0,u=a.length;u>h;h++)i.push(a[h])}else i.push(s)}return i},y.prototype.getItemElements=function(){for(var t=[],e=0,i=this.items.length;i>e;e++)t.push(this.items[e].element);return t},y.prototype.layout=function(){this._resetLayout(),this._manageStamps();var t=void 0!==this.options.isLayoutInstant?this.options.isLayoutInstant:!this._isLayoutInited;this.layoutItems(this.items,t),this._isLayoutInited=!0},y.prototype._init=y.prototype.layout,y.prototype._resetLayout=function(){this.getSize()},y.prototype.getSize=function(){this.size=c(this.element)},y.prototype._getMeasurement=function(t,e){var i,n=this.options[t];n?("string"==typeof n?i=this.element.querySelector(n):f(n)&&(i=n),this[t]=i?c(i)[e]:n):this[t]=0},y.prototype.layoutItems=function(t,e){t=this._getItemsForLayout(t),this._layoutItems(t,e),this._postLayout()},y.prototype._getItemsForLayout=function(t){for(var e=[],i=0,n=t.length;n>i;i++){var o=t[i];o.isIgnored||e.push(o)}return e},y.prototype._layoutItems=function(t,e){if(!t||!t.length)return this.emitEvent("layoutComplete",[this,t]),void 0;this._itemsOn(t,"layout",function(){this.emitEvent("layoutComplete",[this,t])});for(var i=[],n=0,o=t.length;o>n;n++){var r=t[n],s=this._getItemLayoutPosition(r);s.item=r,s.isInstant=e,i.push(s)}this._processLayoutQueue(i)},y.prototype._getItemLayoutPosition=function(){return{x:0,y:0}},y.prototype._processLayoutQueue=function(t){for(var e=0,i=t.length;i>e;e++){var n=t[e];this._positionItem(n.item,n.x,n.y,n.isInstant)}},y.prototype._positionItem=function(t,e,i,n){n?t.goTo(e,i):t.moveTo(e,i)},y.prototype._postLayout=function(){var t=this._getContainerSize();t&&(this._setContainerMeasure(t.width,!0),this._setContainerMeasure(t.height,!1))},y.prototype._getContainerSize=u,y.prototype._setContainerMeasure=function(t,e){if(void 0!==t){var i=this.size;i.isBorderBox&&(t+=e?i.paddingLeft+i.paddingRight+i.borderLeftWidth+i.borderRightWidth:i.paddingBottom+i.paddingTop+i.borderTopWidth+i.borderBottomWidth),t=Math.max(t,0),this.element.style[e?"width":"height"]=t+"px"}},y.prototype._itemsOn=function(t,e,i){function n(){return o++,o===r&&i.call(s),!0}for(var o=0,r=t.length,s=this,a=0,h=t.length;h>a;a++){var u=t[a];u.on(e,n)}},y.prototype.ignore=function(t){var e=this.getItem(t);e&&(e.isIgnored=!0)},y.prototype.unignore=function(t){var e=this.getItem(t);e&&delete e.isIgnored},y.prototype.stamp=function(t){if(t=this._find(t)){this.stamps=this.stamps.concat(t);for(var e=0,i=t.length;i>e;e++){var n=t[e];this.ignore(n)}}},y.prototype.unstamp=function(t){if(t=this._find(t))for(var e=0,i=t.length;i>e;e++){var n=t[e],o=d(this.stamps,n);-1!==o&&this.stamps.splice(o,1),this.unignore(n)}},y.prototype._find=function(t){return t?("string"==typeof t&&(t=this.element.querySelectorAll(t)),t=n(t)):void 0},y.prototype._manageStamps=function(){if(this.stamps&&this.stamps.length){this._getBoundingRect();for(var t=0,e=this.stamps.length;e>t;t++){var i=this.stamps[t];this._manageStamp(i)}}},y.prototype._getBoundingRect=function(){var t=this.element.getBoundingClientRect(),e=this.size;this._boundingRect={left:t.left+e.paddingLeft+e.borderLeftWidth,top:t.top+e.paddingTop+e.borderTopWidth,right:t.right-(e.paddingRight+e.borderRightWidth),bottom:t.bottom-(e.paddingBottom+e.borderBottomWidth)}},y.prototype._manageStamp=u,y.prototype._getElementOffset=function(t){var e=t.getBoundingClientRect(),i=this._boundingRect,n=c(t),o={left:e.left-i.left-n.marginLeft,top:e.top-i.top-n.marginTop,right:i.right-e.right-n.marginRight,bottom:i.bottom-e.bottom-n.marginBottom};return o},y.prototype.handleEvent=function(t){var e="on"+t.type;this[e]&&this[e](t)},y.prototype.bindResize=function(){this.isResizeBound||(i.bind(t,"resize",this),this.isResizeBound=!0)},y.prototype.unbindResize=function(){i.unbind(t,"resize",this),this.isResizeBound=!1},y.prototype.onresize=function(){function t(){e.resize()}this.resizeTimeout&&clearTimeout(this.resizeTimeout);var e=this;this.resizeTimeout=setTimeout(t,100)},y.prototype.resize=function(){var t=c(this.element),e=this.size&&t;e&&t.innerWidth===this.size.innerWidth||(this.layout(),delete this.resizeTimeout)},y.prototype.addItems=function(t){var e=this._getItems(t);if(e.length)return this.items=this.items.concat(e),e},y.prototype.appended=function(t){var e=this.addItems(t);e.length&&(this.layoutItems(e,!0),this.reveal(e))},y.prototype.prepended=function(t){var e=this._getItems(t);if(e.length){var i=this.items.slice(0);this.items=e.concat(i),this._resetLayout(),this.layoutItems(e,!0),this.reveal(e),this.layoutItems(i)}},y.prototype.reveal=function(t){if(t&&t.length)for(var e=0,i=t.length;i>e;e++){var n=t[e];n.reveal()}},y.prototype.hide=function(t){if(t&&t.length)for(var e=0,i=t.length;i>e;e++){var n=t[e];n.hide()}},y.prototype.getItem=function(t){for(var e=0,i=this.items.length;i>e;e++){var n=this.items[e];if(n.element===t)return n}},y.prototype.getItems=function(t){if(t&&t.length){for(var e=[],i=0,n=t.length;n>i;i++){var o=t[i],r=this.getItem(o);r&&e.push(r)}return e}},y.prototype.remove=function(t){t=n(t);var e=this.getItems(t);if(e&&e.length){this._itemsOn(e,"remove",function(){this.emitEvent("removeComplete",[this,e])});for(var i=0,o=e.length;o>i;i++){var r=e[i];r.remove();var s=d(this.items,r);this.items.splice(s,1)}}},y.prototype.destroy=function(){var t=this.element.style;t.height="",t.position="",t.width="";for(var e=0,i=this.items.length;i>e;e++){var n=this.items[e];n.destroy()}this.unbindResize(),delete this.element.outlayerGUID,h&&h.removeData(this.element,this.settings.namespace)},y.data=function(t){var e=t&&t.outlayerGUID;return e&&_[e]},y.create=function(t,i){function n(){y.apply(this,arguments)}return e(n.prototype,y.prototype),g(n,"options"),g(n,"settings"),e(n.prototype.options,i),n.prototype.settings.namespace=t,n.data=y.data,n.Item=function(){m.apply(this,arguments)},n.Item.prototype=new m,n.prototype.settings.item=n.Item,r(function(){for(var e=o(t),i=s.querySelectorAll(".js-"+e),r="data-"+e+"-options",u=0,p=i.length;p>u;u++){var f,d=i[u],c=d.getAttribute(r);try{f=c&&JSON.parse(c)}catch(l){a&&a.error("Error parsing "+r+" on "+d.nodeName.toLowerCase()+(d.id?"#"+d.id:"")+": "+l);continue}var m=new n(d,f);h&&h.data(d,t,m)}}),h&&h.bridget&&h.bridget(t,n),n},y.Item=m,y}var s=t.document,a=t.console,h=t.jQuery,u=function(){},p=Object.prototype.toString,f="object"==typeof HTMLElement?function(t){return t instanceof HTMLElement}:function(t){return t&&"object"==typeof t&&1===t.nodeType&&"string"==typeof t.nodeName},d=Array.prototype.indexOf?function(t,e){return t.indexOf(e)}:function(t,e){for(var i=0,n=t.length;n>i;i++)if(t[i]===e)return i;return-1};"function"==typeof define&&define.amd?define(["eventie/eventie","doc-ready/doc-ready","eventEmitter/EventEmitter","get-size/get-size","matches-selector/matches-selector","./item"],r):t.Outlayer=r(t.eventie,t.docReady,t.EventEmitter,t.getSize,t.matchesSelector,t.Outlayer.Item)}(window),function(t){"use strict";function e(t,e){var n=t.create("masonry");return n.prototype._resetLayout=function(){this.getSize(),this._getMeasurement("columnWidth","outerWidth"),this._getMeasurement("gutter","outerWidth"),this.measureColumns();var t=this.cols;for(this.colYs=[];t--;)this.colYs.push(0);this.maxY=0},n.prototype.measureColumns=function(){var t=this._getSizingContainer(),i=this.items[0],n=i&&i.element;this.columnWidth||(this.columnWidth=n?e(n).outerWidth:this.size.innerWidth),this.columnWidth+=this.gutter,this._containerWidth=e(t).innerWidth,this.cols=Math.floor((this._containerWidth+this.gutter)/this.columnWidth),this.cols=Math.max(this.cols,1)},n.prototype._getSizingContainer=function(){return this.options.isFitWidth?this.element.parentNode:this.element},n.prototype._getItemLayoutPosition=function(t){t.getSize();var e=Math.ceil(t.size.outerWidth/this.columnWidth);e=Math.min(e,this.cols);for(var n=this._getColGroup(e),o=Math.min.apply(Math,n),r=i(n,o),s={x:this.columnWidth*r,y:o},a=o+t.size.outerHeight,h=this.cols+1-n.length,u=0;h>u;u++)this.colYs[r+u]=a;return s},n.prototype._getColGroup=function(t){if(1===t)return this.colYs;for(var e=[],i=this.cols+1-t,n=0;i>n;n++){var o=this.colYs.slice(n,n+t);e[n]=Math.max.apply(Math,o)}return e},n.prototype._manageStamp=function(t){var i=e(t),n=this._getElementOffset(t),o=this.options.isOriginLeft?n.left:n.right,r=o+i.outerWidth,s=Math.floor(o/this.columnWidth);s=Math.max(0,s);var a=Math.floor(r/this.columnWidth);a=Math.min(this.cols-1,a);for(var h=(this.options.isOriginTop?n.top:n.bottom)+i.outerHeight,u=s;a>=u;u++)this.colYs[u]=Math.max(h,this.colYs[u])},n.prototype._getContainerSize=function(){this.maxY=Math.max.apply(Math,this.colYs);var t={height:this.maxY};return this.options.isFitWidth&&(t.width=this._getContainerFitWidth()),t},n.prototype._getContainerFitWidth=function(){for(var t=0,e=this.cols;--e&&0===this.colYs[e];)t++;return(this.cols-t)*this.columnWidth-this.gutter},n.prototype.resize=function(){var t=this._getSizingContainer(),i=e(t),n=this.size&&i;n&&i.innerWidth===this._containerWidth||(this.layout(),delete this.resizeTimeout)},n}var i=Array.prototype.indexOf?function(t,e){return t.indexOf(e)}:function(t,e){for(var i=0,n=t.length;n>i;i++){var o=t[i];if(o===e)return i}return-1};"function"==typeof define&&define.amd?define(["outlayer/outlayer","get-size/get-size"],e):t.Masonry=e(t.Outlayer,t.getSize)}(window);;
