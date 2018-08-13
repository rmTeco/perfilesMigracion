({

    handleUnappliedAttributeClicked: function(component, event) {
        var i;
        if (component.hasPendingUpdate === true) {
            return;
        }

        var segmentCode = event.target.getAttribute('data-code');
        // only apply attribute if it is legit
        if (segmentCode) {
            var applyAttributeEvent = component.getEvent('applyAttribute');
            applyAttributeEvent.setParams({
                'segmentCode': segmentCode
            });
            applyAttributeEvent.fire();
            var loadingSpinner = component.find('loading-spinner');
            $A.util.removeClass(loadingSpinner.getElement(), 'slds-hidden');
            component.hasPendingUpdate = true;
        }
    },

    handleFilteredEvent: function(component, event) {
        var undoFilteringFlag = event.getParam('undoFilteringFlag');

        if (undoFilteringFlag) {
            var unappliedAttributesOriginalList = component.get('v.unappliedAttributesOriginalList');
            // clone unappliedAttributesOriginalList
            var unappliedAttributesOriginalListCloned = unappliedAttributesOriginalList.map(function (obj) {
                return Object.assign({}, obj);
            });
            component.set('v.unappliedAttributesForDisplay', unappliedAttributesOriginalListCloned);
        } else {
            var filteredList = event.getParam('filteredList');
            var unappliedAttributesOriginalListCloned = filteredList.map(function (obj) {
                return Object.assign({}, obj);
            });
            component.set('v.unappliedAttributesForDisplay', unappliedAttributesOriginalListCloned);
        }
    },

    handleApplyAttributeSucceededEvent: function(component) {
        var unappliedAttributesOriginalList = component.get('v.unappliedAttributesOriginalList');
        // clone unappliedAttributesOriginalList
        var unappliedAttributesOriginalListCloned = JSON.parse(JSON.stringify(unappliedAttributesOriginalList));
        component.set('v.unappliedAttributesForDisplay', unappliedAttributesOriginalListCloned);

        var loadingSpinner = component.find('loading-spinner');
        $A.util.addClass(loadingSpinner.getElement(), 'slds-hidden');
        component.hasPendingUpdate = false;
    },

    handleApplyAttributeFailedEvent: function(component) {
        var loadingSpinner = component.find('loading-spinner');
        $A.util.addClass(loadingSpinner.getElement(), 'slds-hidden');
        component.hasPendingUpdate = false;
    }

})