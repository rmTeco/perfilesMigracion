({
    inputValueChanged: function(component, event) {
        var changeEvent = component.getEvent('change');
        changeEvent.setParams({
            'attributeName': component.get('v.attributeName'),
            'appliedAttributeCode': component.get('v.appliedAttributeCode'),
            'changedValue': event.getSource().get('v.value')});
        changeEvent.fire();
    },

    cancelOnclick: function(component, event) {
        event.preventDefault();
        event.stopPropagation();
    }

})