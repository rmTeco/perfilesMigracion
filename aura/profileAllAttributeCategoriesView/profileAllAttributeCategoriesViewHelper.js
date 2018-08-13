({

    getAttributeCategories: function(component) {
        var helper = this;
        var action = component.get('c.getAttributeCategories');
        action.setParams({
            'entityId': component.get('v.entityId'),
            'applicableSubTypes': component.get('v.applicableSubTypes'),
            'ignoreApplicableTypes': component.get('v.ignoreApplicableTypes')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === 'SUCCESS') {
                helper.updateComponent(component, response);
            } else if (component.isValid() && state === 'ERROR') {
                console.error('Could not run getAttributeCategories', response.getError());
            }
        });
        $A.enqueueAction(action);
    },

    updateComponent: function(component, response) {
        var nsPrefix = component.get('v.nsPrefix');
        var attributeCategoriesInfo = [];
        for (var i = 0; i < response.getReturnValue().length; i += 1) {
            var attributeCategory = response.getReturnValue()[i];
            attributeCategoriesInfo.push({
                type: attributeCategory[nsPrefix + 'UIControlType__c'],
                code: attributeCategory[nsPrefix + 'Code__c'],
                locked: attributeCategory[nsPrefix + 'LockedFlg__c'],
                name: attributeCategory.Name,
                color: attributeCategory[nsPrefix + 'ColorCode__c']
            });
        }
        component.set('v.attributeCategoriesInfo', attributeCategoriesInfo);
    },

    startListening: function(component) {
        var helper = this;
        //Get a valid Session Id
        var sessionAction = component.get('c.getUserSession');
        sessionAction.setCallback(this, function(a) {
            var sid = a.getReturnValue();
            // Configure CometD
            var cometdUrl = window.location.protocol + '//' + window.location.hostname + '/cometd/40.0/';
            var cometd = component.get('v.cometd');
            cometd.configure({
                url: cometdUrl,
                requestHeaders: {Authorization: 'OAuth ' + sid},
                appendMessageTypeToURL: false
            });
            cometd.websocketEnabled = false;

            // Establish CometD connection
            cometd.addListener('/meta/handshake', $A.getCallback(function(message) {
                if (message.successful) {
                    cometd.batch($A.getCallback(function() {
                        var subscription;
                        var existingSubscription = component.get('v.subscription');
                        if (existingSubscription) {
                            cometd.unsubscribe(existingSubscription);
                        }
                        subscription = cometd.subscribe('/topic/vlocityProfileUpdates', $A.getCallback(function(platformEvent) {
                            helper.handlePushTopicUpdate(component, platformEvent);
                        }));
                        component.set('v.subscription', subscription);
                    }));
                } else {
                    helper.performCometdHandshake(component);
                }
            }));

            cometd.addListener('/meta/unsuccessful', function(message) {
                if (message) {
                    // Use this hook here to debug connection issues in the debugger
                    // simply set a breakpoint and inspect the message.
                }
            });

            helper.performCometdHandshake(component);
        });

        $A.enqueueAction(sessionAction);
    },

    performCometdHandshake: function(component) {
        component.get('v.cometd').handshake();
    },

    handlePushTopicUpdate: function(component, platformEvent) {
        var eventObjId;
        var event;
        var nsPrefix = component.get('v.nsPrefix');
        if (platformEvent.data && platformEvent.data.event && platformEvent.data.sobject) {
            eventObjId = platformEvent.data.sobject[nsPrefix + 'ObjectId__c'];
            if (eventObjId != component.get('v.entityId')) {
                return;
            }
        }
        event = $A.get('e.vlocity_cmt:profileUpdatedEvent');
        event.setParams({
            attributeCode: platformEvent.data.sobject[nsPrefix + 'Attribute__c'],
            attributeCategoryCode: platformEvent.data.sobject[nsPrefix + 'AttributeCategory__c'],
            externalUpdate: true
        });
        event.fire();
    }
})