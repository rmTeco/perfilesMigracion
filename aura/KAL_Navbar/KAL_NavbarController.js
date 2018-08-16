({
	
    obtenerPromosFinancieras : function(component, event, helper) {
        
        console.log('obtenerPromosFinancieras entre');
        var action = component.get("c.conseguirPromocionesFinancieras");
        
        action.setCallback(this, function(response) {
        	
        	if(response.getState() === 'SUCCESS'){
        		
        		var jsonString = JSON.parse(response.getReturnValue());
                console.log(jsonString);
                console.log(jsonString['options'].length);
                
                var maxCantCuotas = 1;
                var cantCuotas = 0;
                for (var i = 0; i < jsonString['options'].length; i++) {
                    cantCuotas = parseInt(jsonString['options'][i]['Instalment__c']);
                    if(cantCuotas > maxCantCuotas){
                        maxCantCuotas = cantCuotas;
                    }
                 }
        		
        		component.set("v.maxCantCuotas", maxCantCuotas);
        		
        	}else {
        		if(response.getError()){
        			alert('Error: ' + response.getError());
        		}
        	}
        	
        });
        
        $A.enqueueAction(action);
    }
    
})