({
    getAppliedAttributes: function(component, entityId, attributeCategoryCode) {
        var action = component.get('c.getAppliedAttributes');
        action.setParams({
            'clientId': entityId,
            'categoryCode': attributeCategoryCode
        });
        action.setCallback(this, function(response) {
            var returnObjects;
            var state = response.getState();
            if (component.isValid() && state === 'SUCCESS') {
                var returnObjects = this.parseResultSet2JSON(response.getReturnValue());
                component.set('v.appliedAttributes', returnObjects);
            } else if (component.isValid() && state === 'ERROR') {
                console.error('getAppliedAttributes failed', response.getError());
            }
        });
        $A.enqueueAction(action);
    },

    updateAppliedAttribute: function(component, entityId, attributeCategoryCode, attributeName, appliedAttributeCode, changedValue) {
        var action = component.get('c.upsertAttribute');
        // for update, must follow the following pattern: ONLY clientIdApplied, segmentCode, segmentValue are REQUIRED
        action.setParams({
            'clientIdApplied': entityId,
            'segmentCode': appliedAttributeCode,
            'segmentValue': changedValue,
            'categoryCode': '',
            'segmentName': '',
            'segmentData': '',
            'storyId': ''
        });
        action.setCallback(this, function(response) {
            var profileAttributeValueUpdatedEvent;
            var state = response.getState();
            if (component.isValid() && state === 'SUCCESS') {
                profileAttributeValueUpdatedEvent = $A.get('e.vlocity_cmt:profileAttributeValueUpdatedEvent');
                profileAttributeValueUpdatedEvent.setParams({
                    'attributeCategoryCode': appliedAttributeCode
                });
                profileAttributeValueUpdatedEvent.fire();
                // fire application wide event
                $A.get('e.vlocity_cmt:profileUpdatedEvent').fire();
            } else if (component.isValid() && state === 'ERROR') {
                console.error('upsertAttribute failed', response.getError());
            }

        });
        $A.enqueueAction(action);
    },

    parseResultSet2JSON: function(resultSetString) {
        var obj = null;
        if (typeof resultSetString === 'string') {
            try {
                obj = JSON.parse(resultSetString);
            } catch (e) {
                console.error('failed to parse JSON String: ' + resultSetString, e);
            }
        }
        return obj;
    }
})