({
	openAddToJourneyDialog : function(component) {
		$A.createComponent(
            "et4ae5:AddToJourneyDialog",
            {
                'aura:id' : 'AddToJourneyDialogComponent',
                'AddToJourneyDialogCloseEvent': component.getReference("c.addToJourneyDialogClose")                
            },
            function(dialog){                
                if (component.isValid()) {
                    var body = component.get("v.body");
                    body.push(dialog);
                    component.set("v.body", body);
                    dialog.initializeAddToJourneyDialog(component.get('v.recordId'), component.get('v.sObjectName'));
                }
            }
        );        
	}    
})