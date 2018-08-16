({
	handleChange : function(component, event, helper) {
		var picklistValue = component.find("picklistId").get("v.value");
        component.set("v.picklistValue", picklistValue);
        var regularValue = component.get("v.envioRegularValue");
        var expressValue = component.get("v.envioExpressValue");
        var subtotal = component.get("v.subtotalValue");
        var total;
        if(picklistValue == 'Regular'){
            total = subtotal + regularValue;
            component.set("v.totalValue", total);
        }else if(picklistValue == 'Express'){
            total = subtotal + expressValue;
            component.set("v.totalValue", total);
        }else{
            total = subtotal;
            component.set("v.totalValue", total);
        }
	},
    
    setSubtotal : function(component, event, helper) {
		var action = component.get("c.getSubtotal");
        action.setCallback(this, function(data) {
		component.set("v.subtotalValue", data.getReturnValue());
		});
		$A.enqueueAction(action);
	},
    
    setTotal : function(component, event, helper) {
		var action = component.get("c.getSubtotal");
        action.setCallback(this, function(data) {
		component.set("v.totalValue", data.getReturnValue());
		});
		$A.enqueueAction(action);
	},
})