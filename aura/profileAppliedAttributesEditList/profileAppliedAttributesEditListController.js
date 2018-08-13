({
    handleAppliedAttributeClicked: function (component, event) {
        if (component.hasPendingUpdate === true) {
            return;
        }

        var segmentCode = event.target.getAttribute('data-code');
        var unapplyAttributeEvent = component.getEvent("unapplyAttribute");
        unapplyAttributeEvent.setParams({
            "segmentCode": segmentCode
        });
        unapplyAttributeEvent.fire();
        var loadingSpinner = component.find("loading-spinner");
        $A.util.removeClass(loadingSpinner.getElement(), "slds-hidden");
        component.hasPendingUpdate = true;
    },

    filterUnappliedAttributes: function (component, event) {
        var i, j, k;
        var src = event.getSource();
        var searchPattern = src.get("v.value");

        var unappliedAttributesFilteredEvent = $A.get("e.vlocity_cmt:profileUnappliedAttributesFilteredEvent");

        if (searchPattern === null || searchPattern === "") {

            unappliedAttributesFilteredEvent.setParams({
                "undoFilteringFlag": true,
                "filteredList": [],
                "searchPattern": searchPattern,
                "searchPatternExistAsAttributeFlag": false
            });
            unappliedAttributesFilteredEvent.fire();

        } else {

            var unappliedAttributesToBeSearched = component.get("v.unappliedAttributesToBeSearched");
            var unappliedAttributesFilteredList = [];
            for (i = 0; i < unappliedAttributesToBeSearched.length; i += 1) {
                var n = unappliedAttributesToBeSearched[i].Name.toLowerCase().indexOf(searchPattern.toLowerCase())
                if (n >= 0) {
                    unappliedAttributesFilteredList.push(unappliedAttributesToBeSearched[i]);
                }
            }

            // determine if searchPattern exist as an attribute before
            var searchPatternExistAsAttributeFlag = false;

            // determine if searchPattern exist as an applied attribute
            var appliedAttributes = component.get("v.appliedAttributes");
            for (j = 0; j < appliedAttributes.length; j += 1) {
                if (searchPattern.toUpperCase() === appliedAttributes[j].Name.toUpperCase()) {
                    searchPatternExistAsAttributeFlag = true;
                    break;
                }
            }

            // determine if searchPattern exist as an unapplied attribute
            if (!searchPatternExistAsAttributeFlag) {
                for (k = 0; k < unappliedAttributesToBeSearched.length; k += 1) {
                    if (searchPattern.toUpperCase() === unappliedAttributesToBeSearched[k].Name.toUpperCase()) {
                        searchPatternExistAsAttributeFlag = true;
                        break;
                    }
                }
            }

            unappliedAttributesFilteredEvent.setParams({
                "undoFilteringFlag": false,
                "filteredList": unappliedAttributesFilteredList,
                "searchPattern": searchPattern,
                "searchPatternExistAsAttributeFlag": searchPatternExistAsAttributeFlag
            });
            unappliedAttributesFilteredEvent.fire();
        }
    },

    handleApplyAttributeSucceededEvent: function (component) {
        var typeAheadInputCmp = component.find("type-ahead-input");
        // reset input text to blank and unappliedAttributesToBeSearched to empty array when attribute has been successfully applied
        typeAheadInputCmp.set("v.value", "");
    },

    handleProfileUnapplyAttributeSucceededFailedEvent: function (component) {
        var loadingSpinner = component.find("loading-spinner");
        $A.util.addClass(loadingSpinner.getElement(), "slds-hidden");
        component.hasPendingUpdate = false;
    }

})