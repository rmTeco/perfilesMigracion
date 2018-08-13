({    
    rerender : function(component, helper){        
        this.superRerender();
        
        if(component.get('v.showAddToJourneyDialog')){            
            //only add dialog if it is not already added
            var body = component.get('v.body');
            if(body.length == 0){
                helper.openAddToJourneyDialog(component);
            }
        }
        else{
            component.set('v.body', []);
        }
    }
})