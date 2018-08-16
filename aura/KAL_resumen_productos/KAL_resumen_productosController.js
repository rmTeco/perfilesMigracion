({
	setProducts : function(component, event, helper) {
		var action = component.get("c.getOneProduct");
        action.setCallback(this, function(data) {
		component.set("v.products", data.getReturnValue());
		});
		$A.enqueueAction(action);
	},
   
})