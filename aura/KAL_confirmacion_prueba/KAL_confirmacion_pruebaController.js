({
    doInit : function(component, event, helper) {
        helper.blockButton();
        var paramId = helper.getParameter();
        var action = component.get("c.agregarUnProducto");
        action.setParams({
            PriceBookId : paramId
        });
        action.setCallback(this, function(response) {
            console.log('Producto agregado: ' + response.getState());
        })
        var action2 = component.get("c.conseguirCarrito");
        action2.setCallback(this, function(response) {
            var jsonString = response.getReturnValue();
            component.set("v.items", jsonString);
        })
        $A.enqueueAction(action);
        $A.enqueueAction(action2);
        
        helper.changeURL();
    },

    volverATiendaPersonal : function(component, event, helper) {
        window.location.href = 'https://mocks-mockfan.cs59.force.com/vtexMock/s/kal-vtexmock';
    }
})