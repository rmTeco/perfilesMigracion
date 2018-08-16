({
	handleEvent : function(component, event, helper) {
		var value = event.getParam("tipoEntrega");
        component.set("v.persistentTipoEntrega",value);
        var value2 = event.getParam("precioEntrega");
        component.set("v.persistentPrecioEntrega",value2);
	}
})