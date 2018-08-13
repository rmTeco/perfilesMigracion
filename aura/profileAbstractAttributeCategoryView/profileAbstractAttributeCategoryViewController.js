({
    doInit: function(component, event, helper) {
        var entityId = component.get('v.entityId');
        var attributeCategoryCode = component.get('v.attributeCategoryCode');
        helper.getAppliedAttributes(component, entityId, attributeCategoryCode);
    },

    handleAttributeCategoryUpdatedEvent: function(component, event, helper) {
        var entityId;
        var attributeCategoryCode = event.getParam('attributeCategoryCode');
        if (attributeCategoryCode === component.get('v.attributeCategoryCode')) {
            entityId = component.get('v.entityId');
            helper.getAppliedAttributes(component, entityId, attributeCategoryCode);
        }
    },

    editAttributes: function(component) {
        var attributeCategoryCode = component.get('v.attributeCategoryCode');
        var attributeCategoryName = component.get('v.attributeCategoryName');
        var attributeCategoryLocked = component.get('v.attributeCategoryLocked');
        var appliedAttributes = component.get('v.appliedAttributes');
        var navigationEvent = $A.get('e.vlocity_cmt:profileNavigationEvent');
        navigationEvent.setParams({
            'navigateFrom': 'slide-to-profiler-view',
            'navigateTo': 'slide-to-profiler-edit',
            'attributeCategoryCode': attributeCategoryCode,
            'attributeCategoryName': attributeCategoryName,
            'attributeCategoryLocked': attributeCategoryLocked,
            'appliedAttributes': appliedAttributes
        });
        navigationEvent.fire();
    },

    handleExternalUpdate: function(component, event, helper) {
        var entityId = component.get('v.entityId')
        var params = event.getParams();
        var attributeCategoryCode = event.getParam('attributeCategoryCode');
        if (params.externalUpdate && (attributeCategoryCode == null || attributeCategoryCode == component.get('v.attributeCategoryCode'))) {
            helper.getAppliedAttributes(component, entityId, component.get('v.attributeCategoryCode'));
        }
    }
})