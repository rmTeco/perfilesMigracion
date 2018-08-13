({
    handleProfileAttributeValueChangedEvent : function(component, event, helper) {
        var entityId = component.get("v.entityId");
        var attributeCategoryCode = component.get("v.attributeCategoryCode");
        var attributeName = event.getParam("attributeName");
        var appliedAttributeCode = event.getParam("appliedAttributeCode");
        var changedValue = event.getParam("changedValue");
        helper.updateAppliedAttribute(component, entityId, attributeCategoryCode, attributeName, appliedAttributeCode, changedValue);
    }
})