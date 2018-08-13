({
	doInit : function(component) {
		var searchField = component.get("v.searchField");
        var request = component.get("v.request");
        if(request.searchFieldsLabelTypeMap[searchField]) {
            var datatype = request.searchFieldsLabelTypeMap[searchField].datatype;
            var label = request.searchFieldsLabelTypeMap[searchField].label;
            component.set("v.datatype", datatype);
            component.set("v.label", label);
        }
        
        if(datatype && datatype !== "picklist" && datatype !== "checkbox" && datatype !== "date") {
            $A.createComponent(
                "lightning:input",
                {
                    "aura:id": searchField,
                    "type" : datatype,
                    "label": label,
                    "data-field" : searchField,
                    "value": request.searchValueMap[searchField],
                    "onchange": component.getReference("c.onChangeComp")
                },
                function(newComp, status, errorMessage){
                    if (status === "SUCCESS") {
                        var body = component.get("v.body");
                        body.push(newComp);
                        component.set("v.body", body);
                    }
                }
            );
        } else if(datatype === "date") {
            $A.createComponent(
                "ui:inputDate",
                {
                    "aura:id": searchField,
                    "label": label,
                    "data-field" : searchField,
                    "displayDatePicker": true,
                    "class":"slds-input",
                    "labelClass":"slds-form-element__label",
                    "value": request.searchValueMap[searchField],
                    "change": component.getReference("c.onChangeComp")
                },
                function(newComp, status, errorMessage){
                    if (status === "SUCCESS") {
                        var body = component.get("v.body");
                        $A.util.addClass(newComp, 'changeMe');
                        body.push(newComp);
                        component.set("v.body", body);
                    }
                }
            );
        }
	},
    onChangeComp : function(component, event, action) {
       var searchField = component.get("v.searchField");
       var request = component.get("v.request");
       request.searchValueMap[searchField] = event.getSource().get("v.value") ? event.getSource().get("v.value") : null;
    }
})