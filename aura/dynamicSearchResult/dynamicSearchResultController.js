({
	doInit : function(component) {
		var result = component.get("v.result");
        var field = component.get("v.field");
        if(result.resultFieldsLabelTypeMap[field]) {
            component.set("v.value",result.resultValueMap[field]);
            component.set("v.label",result.resultFieldsLabelTypeMap[field].label);
        }
        
        var isLabelActive = result.resultFieldsLabelTypeMap[field] && result.resultFieldsLabelTypeMap[field].label && field.indexOf('Name') < 0 && field.toLowerCase().indexOf('address') < 0;
		component.set("v.isLabelActive",isLabelActive);
    }
})