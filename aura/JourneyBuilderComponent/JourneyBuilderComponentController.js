({    
    openAddToJourneyDialog : function(component, event, helper) {
        component.set('v.showAddToJourneyDialog', true);
    },
        
    addToJourneyDialogClose : function(component, event) {        
        component.set('v.showAddToJourneyDialog', false);        
    }
})