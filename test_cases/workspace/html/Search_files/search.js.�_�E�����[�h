/*
				<div class="suggestlist">
					<h3>Search suggestions</h3>
					<ul class="termlist">
						<li><em>sugg</em>est #1</li>
						<li>suggest #2</li>
						<li>suggest #3</li>
					</ul>
					<h3>Products</h3>
					<ul class="productlist">
						<li>
							<div class="graphic">
								<img src="media/images/product.png" width="36" height="50" alt="" />
							</div>
							<div class="info">
								<h2>Pro<em>duct</em> name goes her</h2>
								<div class="sku">SKU</div>
								<div class="price">$9.95</div>
							</div>
							<div class="clear">&nbsp;</div>
						</li>
					</ul>
					<a href="#" class="viewall">See more results for "<strong>key</strong>" &gt;&gt;</a>
				</div>


*/


ss_jQuery( document ).ready(function(){
	
	var html = '<div class="suggestlist">';
	html += '		<h3 class="t">Search suggestions</h3>';
	html += '		<ul class="termlist">';
	html += '		</ul>';
	html += '		<h3 class="p">Products</h3>';
	html += '		<ul class="productlist">';
	html += '		</ul>';
	html += '		<a href="#" class="viewall">See more results for "<strong>key</strong>" &gt;&gt;</a>';
	html += '	</div>';
	
	ss_jQuery(".searchfrm").append(html);
	
	
	function showSearchResults(){
		ss_jQuery(".termlist li, .productlist li").remove();
		var val = ss_jQuery(".searchfrm-text").val();
		var index = -1;
		for(var i = 0; i < cacheTerms.length; i++){
			if(cacheTerms[i] == val){
				index = i;
				break;
			}
		}
		if(index >= 0){
			//console.log(cacheData[index])
			if(cacheData[index] == "loading..."){
				return;
			}
			if(cacheData[index].t.length == 0 && cacheData[index].p.length == 0){
				return;
			}
			
			if(cacheData[index].t.length == 0){
				ss_jQuery("h3.t").hide();
			}else{
				ss_jQuery("h3.t").show();
			}
			for(var i = 0; i < cacheData[index].t.length; i++){
				ss_jQuery(".termlist").append("<li>" + cacheData[index].t[i].t + "</li>");
			}
			ss_jQuery(".termlist li").click(function(){
				document.location.href = baseUrl + "/search.php?q=" + encodeURIComponent( ss_jQuery(this).text().trim() );
			})
			
			
			if(cacheData[index].p.length == 0){
				ss_jQuery("h3.p").hide();
			}else{
				ss_jQuery("h3.p").show();
			}
			
			for(var i = 0; i < cacheData[index].p.length; i++){
				var html = '<li href="' + cacheData[index].p[i].l +'">';
				html += '<div class="graphic">'
				html += '<img src="http://www.mtgotraders.com/media/' + cacheData[index].p[i].g + '" alt="" />';
				html += '</div>';
				html += '<div class="info">';
				html += '<h2>' + cacheData[index].p[i].n + '</h2> ';
				html += '<div class="sku">' + cacheData[index].p[i].s + '</div>';
				html += '<div class="price">' + cacheData[index].p[i].p + '</div>';
				html += "</div>"
				html += '<div class="clear">&nbsp;</div>';
				html += "</li>";
				ss_jQuery(".productlist").append(html);
			}
			ss_jQuery(".productlist li").click(function(){
				document.location.href = baseUrl + "/" + ss_jQuery(this).attr("href");
			})
		}
		ss_jQuery(".suggestlist a.viewall strong").text(val);
		ss_jQuery(".suggestlist a.viewall").attr("href", baseUrl + "/search.php?q=" + encodeURIComponent(val)) + "&sortby=name&sorting=asc";
				
		ss_jQuery(".suggestlist").show();
		
	}

	ss_jQuery("body").click(function(event){
		ss_jQuery(".suggestlist").hide();
	})
	
	ss_jQuery(".searchfrm input[name='q'], .suggestlist").bind("click", function(event){
		event.stopPropagation();
	})
	
	var cacheTerms = [];
	var cacheData = [];
	
	ss_jQuery(".searchfrm input[name='q']").bind("keyup focus", (function(e){
				
		if (e.which == 38 || e.which == 40 || e.which == 13)
			return;
		
		if( ss_jQuery(this).val().length < 3){
			ss_jQuery(".suggestlist").hide();
		}else{			
			var val = ss_jQuery(this).val();
			for(var i = 0; i < cacheTerms.length; i++){
				
				if(cacheTerms[i] == val){
					showSearchResults()
					return;
				}
			}
			
			
			cacheTerms.push( val );
			cacheData.push("loading...");
			
			var parameters = "q=" + encodeURIComponent(val) + "&r=" + Math.random();
			
			ss_jQuery.ajax({
				type: "POST",
				url: baseUrl + "/s.php",
				data: parameters,
				success: function(response){
					var data = ss_jQuery.parseJSON(response)
					var q = data.q
					var index = -1;
					for(var i = 0; i < cacheTerms.length; i++){
						if(cacheTerms[i] == q){
							index = i;
							break;
						}
					}
					cacheData[index] = {t: data.t, p: data.p}
					showSearchResults()
				}
			})
		}
	}))
})