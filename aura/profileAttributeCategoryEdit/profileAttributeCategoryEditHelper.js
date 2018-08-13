({
    getUnappliedAttributes: function(component, clientId, attributeCategoryCode) {
        var action = component.get("c.getUnappliedAttributes");
        action.setParams({"clientId" : clientId,
                          "categoryCode" : attributeCategoryCode});

        action.setCallback(this, function(response) {

            var state = response.getState();

            if (component.isValid() && state === "SUCCESS") {

                var returnObjects = this.parseResultSet2JSON(response.getReturnValue());

                returnObjects.sort(function(a, b){
                    if(a.Name < b.Name) {
                        return -1;
                    }
                    if(a.Name > b.Name) {
                        return 1;
                    }
                    return 0;
                });

                component.set("v.unappliedAttributes", returnObjects);

                // clone unappliedAttributes
                var unappliedAttributesForDisplay = this.parseResultSet2JSON(response.getReturnValue());
                unappliedAttributesForDisplay.sort(function(a, b){
                    if(a.Name < b.Name) {
                        return -1;
                    }
                    if(a.Name > b.Name) {
                        return 1;
                    }
                    return 0;
                });
                component.set("v.unappliedAttributesForDisplay", unappliedAttributesForDisplay);

            } else if (component.isValid() && state === "ERROR") {

                var errors = response.getError();
                if (errors) {
                    console.error("profileAttributeCategoryEditHelper: getUnappliedAttributes encountered error:");
                    console.error(errors);
                    if (errors[0] && errors[0].message) {
                        console.error("profileAttributeCategoryEditHelper: getUnappliedAttributes: Error message: " +
                                 errors[0].message);
                    }
                } else {
                    console.error("profileAttributeCategoryEditHelper: getUnappliedAttributes: Unknown error");
                }

            }

        });
        $A.enqueueAction(action);
	},

    applyAttribute: function(component, entityId, segmentCode) {
        var i;
        var action = component.get("c.upsertAttribute");
        // for update, must follow the following pattern: ONLY clientIdApplied, segmentCode are REQUIRED
        action.setParams({"clientIdApplied" : entityId,
                          "categoryCode" : "",
                          "segmentName" : "",
                          "segmentCode" : segmentCode,
                          "segmentValue" : "",
                          "segmentData" : "",
                          "storyId" : ""});

        // make sure rapid clicks from the user would only take the last click
        action.setAbortable();

        action.setCallback(this, function(response) {

            var state = response.getState();

            if (component.isValid() && state === "SUCCESS") {

                var attributeApplied;
                var unappliedAttributes = component.get("v.unappliedAttributes");
                for (i=0; i<unappliedAttributes.length; i+=1) {
                    if (segmentCode === unappliedAttributes[i].SegmentCode) {
                        attributeApplied = unappliedAttributes[i];
                        unappliedAttributes.splice(i, 1);
                        break;
                    }
                }
                component.set("v.unappliedAttributes", unappliedAttributes);
                // clone unappliedAttributes
                var unappliedAttributesCloned = JSON.parse( JSON.stringify( unappliedAttributes ) );
                component.set("v.unappliedAttributesForDisplay", unappliedAttributesCloned);

           		var appliedAttributes = component.get("v.appliedAttributes");
                appliedAttributes.push(attributeApplied);
                appliedAttributes.sort(function(a, b){
                    if(a.Name < b.Name) {
                        return -1;
                    }
                    if(a.Name > b.Name) {
                        return 1;
                    }
                    return 0;
                });
                component.set("v.appliedAttributes", appliedAttributes);

                // notify both applied and unapplied attributes list that attribute has been successfully applied
                // in case they need to take action
                var applyAttributeSucceededEvent = $A.get("e.vlocity_cmt:profileApplyAttributeSucceededEvent");
                applyAttributeSucceededEvent.fire();

                // notify previous screen that the attribute category has been updated, such that the latter
                // can refresh its view for the attribute category
                var attributeCategoryUpdatedEvent = $A.get("e.vlocity_cmt:profileAttributeCategoryUpdatedEvent");
                attributeCategoryUpdatedEvent.setParams({
                    "attributeCategoryCode" : component.get("v.attributeCategoryCode")
                });
                attributeCategoryUpdatedEvent.fire();

                // fire application wide event
                $A.get("e.vlocity_cmt:profileUpdatedEvent").fire();

            } else if (component.isValid() && state === "ERROR") {

                var errors = response.getError();
                if (errors) {
                    console.error("profileAttributeCategoryEditHelper: applyAttribute encountered error:");
                    console.error(errors);
                    if (errors[0] && errors[0].message) {
                        console.error("profileAttributeCategoryEditHelper: applyAttribute: Error message: " +
                                 errors[0].message);
                    }
                } else {
                    console.error("profileAttributeCategoryEditHelper: applyAttribute: Unknown error");
                }
                var applyAttributeFailedEvent = $A.get("e.vlocity_cmt:profileApplyAttributeFailedEvent");
                applyAttributeFailedEvent.fire();

            }

        });
        $A.enqueueAction(action);
    },

    unapplyAttribute: function(component, entityId, segmentCode) {
        var i, j;
        var action = component.get("c.removeSegment");
        action.setParams({"clientId" : entityId,
                          "segmentCode" : segmentCode,
                          "storyId" : ""});

        // make sure rapid clicks from the user would only take the last click
        action.setAbortable();

        action.setCallback(this, function(response) {

            var state = response.getState();

            if (component.isValid() && state === "SUCCESS") {

                var attributeUnapplied,
                    appliedAttributes = component.get("v.appliedAttributes");
                for (j=0; j<appliedAttributes.length; j+=1) {
                    if (segmentCode === appliedAttributes[j].SegmentCode) {
                        attributeUnapplied = appliedAttributes[j];
                        appliedAttributes.splice(j, 1);
                        break;
                    }
                }
                component.set("v.appliedAttributes", appliedAttributes);

                var unappliedAttributes = component.get("v.unappliedAttributes");
                unappliedAttributes.push(attributeUnapplied);
                unappliedAttributes.sort(function(a, b){
                    if(a.Name < b.Name) {
                        return -1;
                    }
                    if(a.Name > b.Name) {
                        return 1;
                    }
                    return 0;
                });
                component.set("v.unappliedAttributes", unappliedAttributes);
                // clone unappliedAttributes
                var unappliedAttributesCloned = JSON.parse( JSON.stringify( unappliedAttributes ) );
                component.set("v.unappliedAttributesForDisplay", unappliedAttributesCloned);

                // notify both applied and unapplied attributes list that attribute has been successfully applied
                // in case they need to take action
                var unapplyAttributeSucceededEvent = $A.get("e.vlocity_cmt:profileUnapplyAttributeSucceededEvent");
                unapplyAttributeSucceededEvent.fire();


                // notify previous screen that the attribute category has been updated, such that the latter
                // can refresh its view for the attribute category
                var attributeCategoryUpdatedEvent = $A.get("e.vlocity_cmt:profileAttributeCategoryUpdatedEvent");
                attributeCategoryUpdatedEvent.setParams({
                    "attributeCategoryCode" : component.get("v.attributeCategoryCode")
                });
                attributeCategoryUpdatedEvent.fire();

                // fire application wide event
                $A.get("e.vlocity_cmt:profileUpdatedEvent").fire();

            } else if (component.isValid() && state === "ERROR") {

                var errors = response.getError();
                if (errors) {
                    console.error("profileAttributeCategoryEditHelper: unapplyAttribute encountered error:");
                    console.error(errors);
                    if (errors[0] && errors[0].message) {
                        console.error("profileAttributeCategoryEditHelper: unapplyAttribute: Error message: " +
                                 errors[0].message);
                    }
                } else {
                    console.error("profileAttributeCategoryEditHelper: unapplyAttribute: Unknown error");
                }
                var unapplyAttributeFailedEvent = $A.get("e.vlocity_cmt:profileUnapplyAttributeFailedEvent");
                unapplyAttributeFailedEvent.fire();
            }

        });
        $A.enqueueAction(action);
    },

    addAttribute: function(component, entityId, attributeNameToBeAdded, attributeCategoryCode) {
        var action = component.get("c.upsertAttribute");
        // for insert, must follow the following pattern: ONLY clientIdApplied, segmentName, categoryCode are REQUIRED
        action.setParams({"clientIdApplied" : entityId,
                          "categoryCode" : attributeCategoryCode,
                          "segmentName" : attributeNameToBeAdded,
                          "segmentCode" : "",
                          "segmentValue" : "",
                          "segmentData" : "",
                          "storyId" : ""});

        // make sure rapid clicks from the user would only take the last click
        action.setAbortable();

        action.setCallback(this, function(response) {

            var state = response.getState();

            if (component.isValid() && state === "SUCCESS") {
                if (response.getReturnValue() !== null) {
                    var attributeAdded = this.parseResultSet2JSON(response.getReturnValue());
                    var appliedAttributes = component.get("v.appliedAttributes");
                    appliedAttributes.push(attributeAdded);
                    appliedAttributes.sort(function(a, b){
                        if(a.Name < b.Name) {
                            return -1;
                        }
                        if(a.Name > b.Name) {
                            return 1;
                        }
                        return 0;
                    });
                    component.set("v.appliedAttributes", appliedAttributes);
                }

                // notify both applied and unapplied attributes list that attribute has been successfully applied
                // in case they need to take action
                var applyAttributeSucceededEvent = $A.get("e.vlocity_cmt:profileApplyAttributeSucceededEvent");
                applyAttributeSucceededEvent.fire();

                // notify previous screen that the attribute category has been updated, such that the latter
                // can refresh its view for the attribute category
                var attributeCategoryUpdatedEvent = $A.get("e.vlocity_cmt:profileAttributeCategoryUpdatedEvent");
                attributeCategoryUpdatedEvent.setParams({
                    "attributeCategoryCode" : component.get("v.attributeCategoryCode")
                });
                attributeCategoryUpdatedEvent.fire();

                // fire application wide event
                $A.get("e.vlocity_cmt:profileUpdatedEvent").fire();

            } else if (component.isValid() && state === "ERROR") {

                var errors = response.getError();
                if (errors) {
                    console.error("profileAttributeCategoryEditHelper: addAttribute encountered error:");
                    console.error(errors);
                    if (errors[0] && errors[0].pageErrors[0].message) {
                        console.error("profileAttributeCategoryEditHelper: addAttribute: Error message: " +
                                 errors[0].pageErrors[0].message);
                    }
                } else {
                    console.error("profileAttributeCategoryEditHelper: addAttribute: Unknown error");
                }
                var applyAttributeFailedEvent = $A.get("e.vlocity_cmt:profileApplyAttributeFailedEvent");
                applyAttributeFailedEvent.fire();

            }

        });
        $A.enqueueAction(action);
    },

    parseResultSet2JSON: function(resultSetString) {
        if (typeof resultSetString === 'undefined' || !resultSetString) {
            console.error("profileAttributeCategoryEditHelper: resultSetString null or empty.  resultSetString skipped!");
            return null;
        }

        try {
            var obj = JSON.parse(resultSetString);
            if (obj && typeof obj === "object" && obj !== null) {
                return obj;
            } else {
                return null;
            }
        } catch (e) {
            console.error("profileAttributeCategoryEditHelper: resultSetString has INVALID json format and is skipped: " + resultSetString);
            console.error(e);
            return null;
        }
    }

})