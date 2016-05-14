var leaveHistory = jQuery('#js_leave_History').val();

jQuery(function() {

    ChangeButton(leaveHistory);
    CautionChange(leaveHistory);

});

function ChangeButton(leaveHistory) {
    var buttondiv = jQuery("#itemHistoryButton");
    var buttonspan;

    if (leaveHistory == 1) {
        buttondiv.find("a").remove();
        buttonspan = jQuery("<a href=\"javascript:void(0);\" class=\"item_history_link_\">履歴を残す</a>");
        buttonspan.bind("click", DisplayCookie);
    }
    else {
        buttondiv.find("a").remove();
        buttonspan = jQuery("<a href=\"javascript:void(0);\" class=\"item_history_link_\">履歴を残さない</a>");
        buttonspan.bind("click", DestroyCookie);
    }
    buttondiv.html(buttonspan.css({ cursor: "pointer" }));

}

function CautionChange(leaveHistory) {
    var itemHistory = "";

    jQuery("#historyCaution").css({ display: "block" });
    
    jQuery.ajax({
     async: true,
     type: "POST",
     url: EC_WWW_ROOT + "/jp/goods/ajaxitemhistory.aspx",
     cache: false,
     dataType: "text",
     success: function(data){
     	itemHistory = data.replace("\r\n","");
     	
     	if (leaveHistory == 0) {
     		jQuery("#messRedraw").css({ display: "none" });
     		jQuery("#messNothing").css({ display: "block" });
     		
     		if (itemHistory == "True") {
     			jQuery("#historyCaution").css({ display: "none" });
     		}
     		
     	}
     	else {
     		jQuery("#messRedraw").css({ display: "block" });
     		jQuery("#messNothing").css({ display: "none" });
     	}
     }
    }); 
    
}

function DisplayCookie(event) {

    jQuery.ajax({
     type: "POST",
     url: EC_WWW_ROOT + "/jp/goods/ajaxhistorycookie.aspx",
     cache: false
    }); 
     
    jQuery("#itemHistory").slideToggle("fast", function() {

        CautionChange(0);

        ChangeButton(0);
        jQuery("#itemHistory").slideToggle("fast");
    });

}

function DestroyCookie(event) {
    var historydiv = jQuery("#itemHistoryDetail");

    jQuery.ajax({
     type: "POST",
     url: EC_WWW_ROOT + "/jp/goods/ajaxhistorycookie.aspx",
     cache: false
    }); 

    jQuery("#itemHistory").slideToggle("fast", function() {
        historydiv.html("");

        CautionChange(1);

        ChangeButton(1);
        jQuery("#itemHistory").slideToggle("fast");
    });

}