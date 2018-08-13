$( function() {    
    var urlCoded = window.parent.location.search.split('=')[1].replace(/(%3D)/g,'');
    var urlDecoded = decodeURIComponent(escape(window.atob(urlCoded)));
    var urlParams = urlDecoded.indexOf('?') == '0' ? urlDecoded.substring(1) : urlDecoded;
    var obj = urlParams.split("&").reduce(function(prev, curr, i, arr) {
        var p = curr.split("=");
        prev[decodeURIComponent(p[0])] = decodeURIComponent(p[1]);
        return prev;
    }, {});
    baseCtrl.prototype.$scope.bpTree.response.contactId = obj.contactId;
    baseCtrl.prototype.$scope.bpTree.response.Origin = obj.Origin;
    baseCtrl.prototype.$scope.bpTree.response.ValidationMethod = obj.ValidationMethod;
    baseCtrl.prototype.$scope.bpTree.response.emailRegister = obj.emailRegister;
    baseCtrl.prototype.$scope.$apply();
});
baseCtrl.prototype.$scope.redirect = function() {  //Access to Data JSON with baseCtrl.prototype.$scope.bpTree.response  
    var contactId = baseCtrl.prototype.$scope.bpTree.response.contactId;
    var email = baseCtrl.prototype.$scope.bpTree.response.emailRegister;
    var validationResult = baseCtrl.prototype.$scope.bpTree.response.Contact.Validated;
    var info = window.btoa(unescape(encodeURIComponent('contactId=' + contactId + '&ValidationResult=' + validationResult + '&emailRegister=' + email)));
//
   
  if (baseCtrl.prototype.$scope.bpTree.response.IdentityValidated) {
          window.top.location.href = "/clientes/s/login/SelfRegister?info="+info;
    }
}