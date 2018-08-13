({
    doInit : function(component, event, helper) {
        if (component.get('v.entityLookupField')) {
            var lookupField = component.get('v.entityLookupField');
            component.set('v.entityLookupFields', ['Id', 'Name', lookupField]);
            var recordComponent = component.find('forceRecordCmp');
            recordComponent.reloadRecord();
        } else if (component.get("v.record")) {
            component.set("v.entityId", component.get("v.record.Id")); // Lightning Extension
        } else if (component.get("v.recordId")) {
            component.set("v.entityId", component.get("v.recordId")); // Lightning Experience
        } else if (!component.get("v.entityId")) {
            console.error('No objectId is passed into Lightning Profiler'); // if none of the above, then VF page has to pass in objectId
        }
        helper.isLanguageRTL(component);
        helper.getNamespacePrefix(component);
    },

    handleRecordUpdated: function(component, event, helper) {
        var eventParams = event.getParams();
        var fieldValue = component.get("v.customFields." + component.get('v.entityLookupField'));
        var existingEntityId = component.get("v.entityId");
        if ((eventParams.changeType === "LOADED" || eventParams.changeType === "CHANGED") && existingEntityId !== fieldValue) {
            component.set('v.entityId', fieldValue);
            helper.updateIsFullyLoaded(component);
        }
    },

    handleNavigationEvent : function(component, event) {
        var navigateFrom = event.getParam("navigateFrom");
        var navigateTo = event.getParam("navigateTo");
        var wrapperCmp = component.find('wrapper');
        $A.util.removeClass(wrapperCmp.getElement(), navigateFrom);
        $A.util.addClass(wrapperCmp.getElement(), navigateTo);
    }
})