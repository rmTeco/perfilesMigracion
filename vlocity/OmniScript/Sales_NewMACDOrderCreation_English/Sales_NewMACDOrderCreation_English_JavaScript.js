var temp = window.location.hostname.replace('--vlocity-cmt', '');
var temp2 = temp.replace('visual.force','my.salesforce');
//alert(temp2);
baseCtrl.prototype.$scope.bpTree.response.pageurl = temp2;

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
        baseCtrl.prototype.$scope.bpTree.response.IsNewSalesPackOrServices = obj.IsNewSalesPackOrServices;
        baseCtrl.prototype.$scope.bpTree.response.operationCode = obj.operationCode;
        baseCtrl.prototype.$scope.bpTree.response.lineNumber = obj.lineNumber;
        baseCtrl.prototype.$scope.$apply();
    }
});

baseCtrl.prototype.$scope.redirect = function() {  //Access to Data JSON with baseCtrl.prototype.$scope.bpTree.response  
    var id = baseCtrl.prototype.$scope.bpTree.response.fdoId;
    var operationCode = baseCtrl.prototype.$scope.bpTree.response.operationCode;
    var ContextId = baseCtrl.prototype.$scope.bpTree.response.ContextId;
    var ContactId = baseCtrl.prototype.$scope.bpTree.response.ContactId;
    var accountId = baseCtrl.prototype.$scope.bpTree.response.accountId;
    var ChannelType = baseCtrl.prototype.$scope.bpTree.response.ChannelType;
    var lineNumber = baseCtrl.prototype.$scope.bpTree.response.lineNumber;

    window.top.location.href = '/clientes/s/compra-packs?cartId=' + id + '&operationCode=' + operationCode + '&assetId=' + ContextId + '&contactId=' + ContactId + '&accountId=' + accountId + '&type=' + ChannelType + '&lineNumber=' + lineNumber;

}