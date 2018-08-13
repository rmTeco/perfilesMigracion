({
    qsToEventMap: {
        'startURL'  : 'e.c:setStartUrl'
    },
    createCommunityUser: function (cmp, event, document, userEmail) {
        
        var regConfirmUrl = cmp.get("v.regConfirmUrl");
        
        var action = cmp.get("c.createUser");
        
        action.setParams({documentNumber : document, email : userEmail, regUrl : regConfirmUrl});
        action.setCallback(this, function(a){
            var state = a.getState();
            if (state === "SUCCESS") {
                var resp = a.getReturnValue();
                if ($A.util.isEmpty(resp) == false) {
                    switch (resp.code) {
                        case "05":
                            cmp.set('v.showError', true);
                            cmp.set('v.errorMessage', resp.message);
                            cmp.set('v.includeEmail', true);
                            break;
                        case "06":
                            cmp.set('v.showError', true);
                            cmp.set('v.errorMessage', resp.message);
                            cmp.set('v.includeEmail', true);
                            break;
                        default:
                            cmp.set('v.showError', true);
                            cmp.set('v.errorMessage', resp.message);
                            cmp.set('v.includeEmail', true);
                    }
                }
            }else if (state === "INCOMPLETE") {
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
    createCommunityUserByContactId: function (cmp, event, ctcId, userEmail) {
        var regConfirmUrl = './CheckPasswordResetEmail';
        
        var action = cmp.get("c.createUserByContactId");
        
        action.setParams({contactId : ctcId, email : userEmail, regUrl : regConfirmUrl});
        action.setCallback(this, function(a){
            var state = a.getState();
            if (state === "SUCCESS") {
                var resp = a.getReturnValue();
                if ($A.util.isEmpty(resp) == false) {
                    switch (resp.code) {
                        case "05":
                            cmp.set('v.showError', true);
                            cmp.set('v.errorMessage', resp.message);
                            cmp.set('v.includeEmail', true);
                            cmp.set("v.showForm", true);
                            break;
                        case "06":
                            cmp.set('v.showError', true);
                            cmp.set('v.errorMessage', resp.message);
                            cmp.set('v.includeEmail', true);
                            cmp.set("v.showForm", true);
                            break;
                        default:
                            cmp.set('v.showError', true);
                            cmp.set('v.errorMessage', resp.message);
                            cmp.set('v.includeEmail', true);
                            cmp.set("v.showForm", true);
                    }
                }
            }else if (state === "INCOMPLETE") {
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
    handleContactSearchByDNI: function(cmp, evt, document){
        var action = cmp.get('c.validateInfo');
        action.setParams({documentNumber : document});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                if ($A.util.isEmpty(resp) == false) {
                    switch (resp.code) {
                        case "01":
                            cmp.set('v.showError', true);
                            cmp.set('v.errorMessage', resp.message);
                            cmp.set('v.includeEmail', false);
                            break;
                        case "02":
                            cmp.set('v.showNextBtn', true);
                            cmp.set('v.showVerifyBtn', false);
                            //cmp.set('v.showError', true);
                            //cmp.set('v.errorMessage', resp.message);
                            cmp.set('v.includeEmail', true);
                            var docInput = cmp.find('document');
                            docInput.set('v.disabled', true);
                            cmp.set("v.contactId", resp.contactId);
                            break;
                        case "03":
                            cmp.set('v.showError', true);
                            cmp.set('v.errorMessage', resp.message);
                            break;
                        case "04":
                            cmp.set('v.showError', true);
                            cmp.set('v.errorMessage', resp.message);
                            break;
                        default:
                            cmp.set('v.showError', true);
                            cmp.set('v.errorMessage', resp.message);
                    }
                }
            }else if (state === "INCOMPLETE") {
                console.log(state);
            }else if (state === "ERROR") {
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
    getCommunityForgotPasswordUrl : function (component, event) {
        var action = component.get("c.getForgotPasswordUrl");
        action.setCallback(this, function(a){
            var rtnValue = a.getReturnValue();
            if (rtnValue !== null) {
                component.set('v.communityForgotPasswordUrl',rtnValue);
            }
        });
        $A.enqueueAction(action);
    },
})