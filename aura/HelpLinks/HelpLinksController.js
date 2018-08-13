({
	doInit : function (component, event, helper) {
        var json = component.get("v.json");
        
        if(json  === null || json === "undefined") {
            component.set("v.json",helper.setJSON());
        }
	},
})