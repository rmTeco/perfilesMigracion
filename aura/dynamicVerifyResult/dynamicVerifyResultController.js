({
	doInit : function(component, event, helper) {
         var callerData = component.get("v.callerData");
         var vField = component.get("v.field");
         if(!callerData.verificationResult) {
             return;
         }
        if(callerData.verificationResult.fields === undefined) {
            callerData.verificationResult.fields = {};
        }
        component.set("v.isActive", callerData.verificationResult.fields[vField]);
        if(callerData.resultFieldsLabelTypeMap[vField]) {
        	component.set("v.label", callerData.resultFieldsLabelTypeMap[vField].label);
        }
        component.set("v.value",callerData.resultValueMap[vField]);
	},
    verifyField : function(component, event, helper) {
        var callerData = component.get("v.callerData"); 
        var verification = event.currentTarget.value; 
        var vField = component.get("v.field"); 
        verification = (verification === 'true' ? true : false); 
        if(callerData.verificationResult.fields === undefined) { 
            callerData.verificationResult.fields = {}; 
        } 
        callerData.verificationResult.fields[vField] = verification; 
        component.set("v.isActive", callerData.verificationResult.fields[vField]);
        component.set("v.callerData", callerData);
    }
})