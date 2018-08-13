({
    doInit : function (component, event, helper) {
        var json = component.get("v.json");
        if(json  === null || json === "undefined") {
            component.set("v.json", helper.setJSON());
        }
		var settings = component.get("v.json");        
		var environmentsLabel = settings.environments;		
                
        var environments = environmentsLabel.split(",");                        
 		component.set("v.environments", environments);
        
        var qaenvironmentsLabel = settings.qaenvironments;                        
        var qaenvironments = qaenvironmentsLabel.split(","); 
        
        component.set("v.qaenvironments", qaenvironments);
        
		if(environments.length > 0){
			if(component.find("environments_dropdown")){
				component.find("environments_dropdown").set("v.value", environments[0]);
			}
		}
        //Check QA Mode
        var action = component.get(settings.qa_mode);                
        action.setCallback(this, function(response){
            var state = response.getState();
			if(component.isValid() && state === "SUCCESS") {                
				var data = JSON.parse(response.getReturnValue());
				if(data != null) {                    
                    if(!data.hasErrors) {						
                        component.set("v.qamode", data.qamode);                                               
                    }
                }}});
	 	$A.enqueueAction(action);                        		
	},

	advancedClicked : function(component, event) {
        var showAdvanced = component.get("v.showAdvanced");
		if(showAdvanced){
			component.set("v.showAdvanced", false);
		}else{
			component.set("v.showAdvanced", true);
		}
    },
	connectClicked : function (component, event, helper) {
		var json = component.get("v.json");
		var environment;       
		if(component.find("environments_dropdown")){
			environment = component.find("environments_dropdown").get("v.value");
		}else{
			environment = null;
		}
		var action = component.get(json.retrieve_oauth_url);
		action.setParams({
			"sEnvironment" : environment,
			"bIsAPI": json.is_api_user
		});
        action.setCallback(this, function(response){
            var state = response.getState();
			if(component.isValid() && state === "SUCCESS") {
				var data = JSON.parse(response.getReturnValue());
				if(data != null) {
                    if(data.hasErrors) {
						var message;
						if (data.message) {
							message = data.message;
						}else{
							message = $A.get("$Label.et4ae5.unkError");
						}
						var errorEvent = $A.get(json.error);
						errorEvent.setParams({"title" : $A.get("$Label.et4ae5.connError"), "message" : message});
						errorEvent.fire();
					}else{
						if(data.destination){
							window.location.href = data.destination;
						}else{
							var errorEvent = $A.get(json.error);
							errorEvent.setParams({"title" : $A.get("$Label.et4ae5.connError"), "message" : $A.get("$Label.et4ae5.unkError")});
							errorEvent.fire();
						}
					}
                }else{
                    var errorEvent = $A.get(json.error);
					errorEvent.setParams({"title" : $A.get("$Label.et4ae5.connError"), "message" : $A.get("$Label.et4ae5.unkError")});
					errorEvent.fire();
                }
			}else{
                var errorEvent = $A.get(json.error);
                errorEvent.setParams({"title" : $A.get("$Label.et4ae5.connError"), "message" : $A.get("$Label.et4ae5.unkError")});
                errorEvent.fire();
            }
        });
	 	$A.enqueueAction(action);
	}
})