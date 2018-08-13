({
    initialize: function(component, event, helper) {
        $A.get("e.siteforce:registerQueryEventMap").setParams({"qsToEvent" : helper.qsToEventMap}).fire();
        component.set("v.communityForgotPasswordUrl", helper.getCommunityForgotPasswordUrl(component, event, helper));
        
        if (window.location.search) {
            var urlCoded = window.location.search.split('=')[1].replace(/(%3D)/g,'');       //split('&')[1].
            var urlDecoded = decodeURIComponent(escape(window.atob(urlCoded)));
            //var urlCoded = window.btoa(window.location.search.replace(/(%3D)/g,'').replace(/(%40)/g,'@'));
            //var urlDecoded = decodeURIComponent(encodeURIComponent(window.atob(urlCoded)));
            var urlParams = urlDecoded.indexOf('?') == '0' ? urlDecoded.substring(1) : urlDecoded;
            var obj = urlParams.split("&").reduce(function(prev, curr, i, arr) {
                var p = curr.split("=");
                prev[decodeURIComponent(p[0])] = decodeURIComponent(p[1]);
                return prev;
            }, {});
            if (obj.ValidationResult) {
                var contactId = obj.contactId;
                var email = obj.emailRegister;
                helper.createCommunityUserByContactId(component, event, contactId, email);
            }
        } else {
            component.set("v.showForm", true);
        }
    },
    handleRegister: function (cmp, event, helper) {
        var document = cmp.find("document").get("v.value");
        var email = cmp.find("email").get("v.value");

        if ($A.util.isEmpty(document) == false && $A.util.isEmpty(email) == false) {
            helper.createCommunityUser(cmp, event, document, email);
        } 
    },
    setStartUrl: function (component, event, helpler) {
        var startUrl = event.getParam('startURL');
        if(startUrl) {
            component.set("v.startUrl", startUrl);
        }
    },
    handleContactSearch: function(cmp, evt, helper) {
        cmp.set('v.showError', false);
        cmp.set('v.errorMessage', '');
        
        var document = cmp.find("document").get("v.value");
        if ($A.util.isEmpty(document) == false) {
            helper.handleContactSearchByDNI(cmp, evt, document);  
        } else if($A.util.isEmpty(document)){
            cmp.set('v.showError', true);
            cmp.set('v.errorMessage', 'Ingrese <b>DNI</b>.');
        }
    },
    handleNextStep: function(cmp, evt, helper) {
        cmp.set('v.showError', false);
        cmp.set('v.errorMessage', '');
        var identityValUrl = cmp.get("v.identityValUrl");
        var contactId = cmp.get("v.contactId");
        var email = cmp.find("email").get("v.value");


        //USUARIO DUPLICADO
        var action = cmp.get("c.validateUsername");
        action.setParams({email : email});
        action.setCallback(this, function(a){
            var state = a.getState();
            if (state === "SUCCESS") {
                var resp = a.getReturnValue();
                if ($A.util.isEmpty(resp) == false) {

                    if ($A.util.isEmpty(document) == false && $A.util.isEmpty(email) == false && !resp) {
                        var ex = new RegExp(/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/);
                        if (ex.test(email)) {
                            var encodedData = window.btoa('contactId=' + contactId + '&ValidationMethod=QA&Origin=Customer&emailRegister=' + email);
                            window.open(identityValUrl + '?info=' + unescape(encodeURIComponent(encodedData)), '_self');
                        } else {
                            cmp.set('v.showError', true);
                            cmp.set('v.errorMessage', 'Correo electrónico inválido.');
                        }
                    } else if (resp){
                        cmp.set('v.showError', true);
                        cmp.set('v.errorMessage', 'El usuario ya existe.');
                    } else if($A.util.isEmpty(email)) {
                        cmp.set('v.showError', true);
                        cmp.set('v.errorMessage', 'Ingrese <b>Correo Electrónico</b>.');
                    }
                }
            } else if (state === "INCOMPLETE") {
                console.log(state);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
            
    },
})