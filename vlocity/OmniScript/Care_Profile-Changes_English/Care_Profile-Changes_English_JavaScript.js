function txDate_Keyup()
 {
 	var d = new Date();
 	var Obj=event.srcElement;
		
	if (event.keyCode != 8)
	{
	 	if (Obj.value.length == 2)
			Obj.value += '/';
		
		if (Obj.value.length == 5)
			Obj.value += '/'		//+ d.getFullYear();
	}
 }

$( function() {    
    var urlParams = window.parent.location.search.indexOf('?') == '0' ? window.parent.location.search.substring(1) : window.parent.location.search;
    var obj = urlParams.split("&").reduce(function(prev, curr, i, arr) {
        var p = curr.split("=");
        prev[decodeURIComponent(p[0])] = decodeURIComponent(p[1]);
        return prev;
    }, {});
    if (obj.type && obj.type=='community') {
        baseCtrl.prototype.$scope.bpTree.response.ContextId = obj.ContextId;
        baseCtrl.prototype.$scope.bpTree.response.ChannelType = obj.type;
        baseCtrl.prototype.$scope.$apply();
    }
});

baseCtrl.prototype.$scope.redirect = function() {
    window.top.location.href = "/clientes/s/profile/" + baseCtrl.prototype.$scope.bpTree.response.userId; 
}