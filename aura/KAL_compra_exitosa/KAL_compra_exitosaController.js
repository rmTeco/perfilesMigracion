({
	getProducts : function(component, event, helper) {                

        var action = component.get("c.getProductsCart");			 				 		 	
         
         action.setCallback(this, function(response) {
         if(response.getState() === 'SUCCESS') {  
                var jsonString = response.getReturnValue();
                component.set("v.productos", jsonString.Productos); 
                component.set("v.subtotal", jsonString.Subtotal);
                component.set("v.total", jsonString.Subtotal);
                
            } else {
                if(response.getError()) {
                    console.warn('Error: ' + response.getError());
                }
            }
     });             
        $A.enqueueAction(action);                  	 					        
    },
    
    getOrden : function(component, event, helper) {                

        var action = component.get("c.getOrdenActualDelUSuario");		 				 		 	
         
        action.setCallback(this, function(response) {
        if(response.getState() === 'SUCCESS') {  
            var orden = response.getReturnValue();   
            component.set("v.email", orden.ShippingEmailContact__c);                            
            component.set("v.nroOrden", orden.OrderNumber);                
        } else {
            if(response.getError()) {
                console.warn('Error: ' + response.getError());
            }
        }
    });             
        $A.enqueueAction(action);                  	 					        
    },

    volverATiendaPersonal: function (component, event, helper) {
        window.location.href = 'https://mocks-mockfan.cs59.force.com/vtexMock/s/kal-vtexmock';
    }
})