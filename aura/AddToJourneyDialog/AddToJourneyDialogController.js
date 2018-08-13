({  
    initializeAddToJourneyDialog : function(component, event, helper){
        var params = event.getParam('arguments');
        component.set('v.recordId', params.recordId);
        component.set('v.recordType', params.recordType);
        component.set("v.journeys", null);
        
        helper.getJourneyList(component, params.recordType);        
    },
    
    onRadioChange : function(component, event, helper){
        var selectJourneys = component.find('selectJourney');        
        for(var i=0; i< selectJourneys.length; i++){
            if(event.getSource() != selectJourneys[i]){
                selectJourneys[i].set('v.value', false);
            }
        }
        
        component.set("v.showError", false);
        component.set("v.emptyFieldErrorShown", false);        
    },
    
    addToJourney : function(component, event, helper){
        var selectJourneys = component.find('selectJourney');
        var selectedIndex = 0;
        for(var i=0; i< selectJourneys.length; i++){
            if(selectJourneys[i].get('v.value') === true){
                selectedIndex = i;
                break;
            }
        }
        
        var journeys = component.get('v.journeys');
        var selectedJourney = journeys[selectedIndex];
        
        var fireParamsMap = {
            SalesforceObjectName : component.get('v.recordType'), 
            SalesforceObjectId : component.get('v.recordId'),
            ContactKey : selectedJourney.contactKey,
            EventDefinitionKey : selectedJourney.eventDefinitionKey,            
            EventDataConfig : selectedJourney.evenDataConfig,
            OwnerMID : selectedJourney.mid,
            ContactPersonType : component.get('v.recordType'),
            VersionNumber: selectedJourney.version,            
            emptyFieldErrorShown: component.get('v.emptyFieldErrorShown').toString(),
            emptyFieldErrorShownForEventDefnKey: component.get('v.emptyFieldErrorShownForEventDefnKey')
        };
        
        helper.addToJourney(component, fireParamsMap); 
    },
    
    hideAddToJourneyDialog : function(component, event, helper) {
        helper.hideAddToJourneyDialog(component);
    },
    
    showSpinner : function (component, event, helper) {
        component.set('v.showSpinner', true);
    },
    
    hideSpinner : function(component, event, helper){
        component.set('v.showSpinner', false);
    }    
})