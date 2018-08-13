({        
    getJourneyList : function(component, recordType) {                
        var action = component.get("c.fetchAvailableJourneys");
        action.setParams({recordType: recordType});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var result = JSON.parse(response.getReturnValue());
                
                if(!result.hasErrors && !!result.journeyList){
                    component.set("v.journeys", result.journeyList.interactionList);                    
                }
                else{
                    component.set("v.showError", true);
                    component.set("v.errorMessage", result.message);
                    component.set("v.errorLevel", result.errorLevel);                    
                }
            }
            else if (state === "ERROR" || state === "INCOMPLETE") {
                component.set("v.showError", true);
                component.set("v.errorMessage", $A.get("$Label.et4ae5.unkError"));
                component.set("v.errorLevel", "Error");
            }
            component.set('v.journeysLoaded', true);
        });
        
        $A.enqueueAction(action);        
    },
    
    addToJourney : function(component, fireParamsMap){
        var action = component.get("c.addRecordToJourney");
        action.setParams({fireParamsMap : fireParamsMap});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var result = JSON.parse(response.getReturnValue());
                
                if(!result.hasErrors){        
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({          
                        "type": "success",
                        "title": "Success!",            
                        "message": $A.get("$Label.et4ae5.AddToJourneySuccess")
                    });        
                    toastEvent.fire();
                    
                    this.hideAddToJourneyDialog(component);
                }
                else{
                    component.set("v.showError", true);
                    component.set("v.errorMessage", result.message);
                    component.set("v.errorLevel", result.errorLevel);
                    
                    if(result.emptyFields != null){
                        component.set("v.errorSubMessage", this.getEmptyFieldsErrorMessage(result.emptyFields));
                        component.set("v.emptyFieldErrorShown", true);
                        component.set("v.emptyFieldErrorShownForEventDefnKey", fireParamsMap.EventDefinitionKey);                        
                    }
                    else{
                        component.set("v.errorSubMessage", "");
                    }                    
                }                
            }
            else if (state === "ERROR" || state === "INCOMPLETE") {
                component.set("v.showError", true);
                component.set("v.errorMessage", $A.get("$Label.et4ae5.unkError"));
                component.set("v.errorLevel", "Error");
            }            
        });
        
        $A.enqueueAction(action);  
    },
    
    getEmptyFieldsErrorMessage: function(emptyFields){
        var msg = "Empty Fields: ";        
        
        for(var i=0; i<emptyFields.length; i++){
            msg += emptyFields[i] + ", ";
        }
        
        return msg.substring(0, msg.length-2 ) + '.';
    },
    
    showModal: function(component){                
        var showError = $A.util.getBooleanValue(component.get("v.showError"));
        var errorLevel = component.get("v.errorLevel") || 'Error';
        
        this.toggleClass(component,'AddToJourneyDialogBackdrop','slds-backdrop--');
        this.toggleClass(component,'AddToJourneyDialog','slds-fade-in-');            
        
        if(showError){
            this.toggleClass(component,'AddToJourneyError','slds-');    
            
            var addCmp = component.find('AddToJourneyErrorMessage');
            //need to remove all previous error classes
            $A.util.removeClass(addCmp, 'slds-theme--info');
            $A.util.removeClass(addCmp, 'slds-theme--warning');
            $A.util.removeClass(addCmp, 'slds-theme--error');
            $A.util.addClass(addCmp, 'slds-theme--' + errorLevel.toLowerCase());
        }
        else{
            this.toggleClassInverse(component,'AddToJourneyError','slds-');
            component.set("v.errorMessage", "");
            component.set("v.errorSubMessage", "");
        }                
    },
    
    hideAddToJourneyDialog : function(component) {
        var addEvent = component.getEvent('AddToJourneyDialogCloseEvent');        
        addEvent.fire();
    },
    
    toggleClass: function(component,componentId,className) {
        var childComponent = component.find(componentId);
        $A.util.removeClass(childComponent,className+'hide');
        $A.util.addClass(childComponent,className+'open');
    },
    
    toggleClassInverse: function(component,componentId,className) {
        var childComponent = component.find(componentId);
        $A.util.addClass(childComponent,className+'hide');
        $A.util.removeClass(childComponent,className+'open');
    }
    
})