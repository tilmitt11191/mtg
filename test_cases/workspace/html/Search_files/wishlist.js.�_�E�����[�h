ss_jQuery(function ($){
		var in_frame = (top.location != location), open = null,sd=200;
		$(document).click(function(){if(open != null){open.slideToggle(sd);open=null;}});
		if(in_frame)$(top.document).click(function(){if(open != null){open.slideToggle(sd);open=null;}});
		$('div.ss_wl_Lists').hide();
		$('div.ss_wl_Box').show().each(function(){
			var t=$(this),f=t.closest('form'),rnum=f.find('input[name="itemnum"]').val(),storeid=f.find('input[name="storeid"]').val(),sb_path=f.attr('action');
			if(in_frame)
				f.attr('target', '_top');
			t.children('span.ss_wl_Label,span.ss_wl_Button').click(function(){
				var c = t.children('div.ss_wl_Lists');
				if(c.is(':hidden'))
				{
					var error = '';
					x = rnum+':finoptnum';
					if($('[name="'+x+'"]').val() !== undefined) {
						$('<input type="hidden" name="'+x+'">').val($('[name="'+x+'"]').val()).appendTo(f);
						$('[name^="'+rnum+':finopt:"]').each(function(){
							if(/^.*;n$/.test($(this).val())) {
								$(this).addClass('field_warn').change(function(){$(this).removeClass('field_warn');});;
								error += "This product requires a menu selection";
							} else
								$('<input type="hidden" name="'+$(this).attr('name')+'">').val($(this).val()).appendTo(f);
						});
					}
					x = rnum+':freeopt';
					if($('[name="'+x+'"]').val() !== undefined)
						$('<input type="hidden" name="freeopt">').val($('[name="'+x+'"]').val()).appendTo(f);
					x = rnum+':qnty';
					if($('[name="'+x+'"]').val() !== undefined)
						$('<input type="hidden" name="qnty">').val($('[name="'+x+'"]').val()).appendTo(f);
					if(error == '')
					{
					} else {
						f.remove('[name^="'+rnum+':finopt:"]');
						f.remove('[name="'+rnum+':finoptnum"]');
						f.remove('[name="qnty"]');
						f.remove('[name="freeopt"]');
						alert(error.replace(/^\s*|\s*$/g,''));
						return false;
					}
					c.html("");
					$.ajax({data:{storeid:storeid,func:'gl'},
						success:function(rdata, stat) {
							var data = rdata.data, err = rdata.error;
							if(err != undefined)
							{
								if(rdata.error_code == 2)
								{
									/* change the action of the form to go to order. */
									var url = sb_path.substring(0,sb_path.lastIndexOf('wishlist.cgi')) + 'order.cgi';
									f.attr('action', url);
									f.find('[name="func"]').val('2');
									f.find('[name="wl"]').val('cr');
									$('<input type="hidden" name="html_reg" value="html">').appendTo(f);
									f.submit();
									return false;
									if(in_frame)
										top.location = url;
									else
										location = url;
								}
								return false;
							}
							for(i=0;i<data.length;i++){
								$('<span class="ss_wl_List" value="'+data[i].id+'"><span class="wl_name">'+data[i].name+'</span><span class="wl_priv">'+data[i].priv+'</span></span>').appendTo(c);
							}
							$('<span class="ss_wl_List" value="new list">Create new Wish List</span>').appendTo(c);
							open = c.slideToggle(sd);
							t.find('span.ss_wl_List').click(function(){
								c.slideToggle(sd);
								open = null;
								f.find('input[name="wl"]').attr('value',$(this).attr('value'));
								f.submit();
							});
						},
						url:sb_path,
						type:'GET',timeout:0,
						dataType:'jsonp', jsonp: 'callback', crossDomain: true,
						error: function (jqXHR, textStatus, errorThrown){console.log(errorThrown);}
					});
				}
				else{
					c.slideToggle(sd);
					open = null;
				}
			});
		});
});

