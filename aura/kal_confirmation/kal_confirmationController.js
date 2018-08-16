({
	doInit : function(component, event, helper) {                

        var action = component.get("c.getProductsCart");			 				 		 	
         
         action.setCallback(this, function(response) {
         if(response.getState() === 'SUCCESS') {  
                var jsonString = response.getReturnValue();
                console.log('Dentro de DOINIT.');    
                console.log(jsonString);
                component.set("v.items", jsonString.Productos); 
                component.set("v.subtotal", jsonString.Subtotal);
                component.set("v.total", jsonString.Subtotal);
                component.set("v.resumenCuotaSeleccionado", false);
                component.set("v.resumenCuotaDefault", true);
                
            } else {
                if(response.getError()) {
                    console.warn('Error: ' + response.getError());
                }
            }
     });
     helper.blockButton();
        
     $A.enqueueAction(action);                  	 					        
    },	    

	handleEvent : function(component, event, helper) {
		var value = event.getParam("cuotas");        
        component.set("v.numeroCuota",value);
        var value2 = event.getParam("precio");        
        component.set("v.montoCuota",value2);
        component.set("v.resumenCuotaDefault", false);
        component.set("v.resumenCuotaSeleccionado", true);

    }
})