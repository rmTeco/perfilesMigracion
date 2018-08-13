({
	// This method calls the server to retrieve records and set the
	// v.records attribute. It is also responsible for setting all
	// the attributes for table pagination.
    getRecords : function(component, helper) {
        var action = component.get("c.getRecords");
        var sObjectAPIName = component.get("v.sObjectAPIName");
        var sObjectFields = component.get("v.sObjectFields");
        action.setParams({
            sObjectFields : sObjectFields,
	        sObjectAPIName : sObjectAPIName
		});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
            	var result = JSON.parse(response.getReturnValue());
                var records = result.records;
                
                // The serialized records include an extra 'attributes' property that breaks
                // the ability to update any modified records, so we need to go through and remove 
                // that property if it exists on the record.
                records.forEach(function(record) {
                    if (record.hasOwnProperty('attributes')) {
                        delete record['attributes'];
                    }
                });
				var recordcount = records.length;
				var currentpage = 1;
				var itemsperpage = 10;
				var highindex;
				var lowindex;
				var maxpage;
				if(recordcount > 0){
					highindex = currentpage * itemsperpage;
					lowindex = (highindex - itemsperpage) + 1;
					maxpage = recordcount / itemsperpage;
					var remainder = recordcount % itemsperpage;
					if(remainder == 0){
						maxpage--;
					}
				}else{
					lowindex = 0;
					highindex = 0;
					maxpage = 1;
				}
				component.set("v.maxpage", maxpage);
                component.set("v.currentpage", currentpage);
				component.set("v.itemsperpage", itemsperpage);
				component.set("v.highindex", highindex);
				component.set("v.lowindex", lowindex);
				component.set("v.records", records);
				component.set("v.recordcount", recordcount);
                if(records.length >= 4000){
                    var recordLimitLoadTitleLabel = component.get("v.recordLimitLoadTitleLabel");
            		var recordLimitLoadLabel = component.get("v.recordLimitLoadLabel");
                    helper.bc_throwEventMessage(component, recordLimitLoadLabel, recordLimitLoadTitleLabel, "info");
                }
                
                if (result.hasErrors) {
                    var recordLoadErrorTitleLabel = component.get("v.recordLoadErrorTitleLabel");
                    var recordLoadErrorLabel = component.get("v.recordLoadErrorLabel");
                    if (result.message) {
                        recordLoadErrorLabel = result.message;
                    }
                    component.set("v.saveDisabled", true);
                    helper.bc_throwEventMessage(component, recordLoadErrorLabel, recordLoadErrorTitleLabel, "error");
                }
            }
            if (component.isValid() && state === "ERROR") {
				component.set("v.currentpage", 1);
				component.set("v.maxpage", 0);
				component.set("v.itemsperpage", 10);
				component.set("v.highindex", 0);
				component.set("v.lowindex", 0);
				component.set("v.records", []);
				component.set("v.recordcount", 0);
                var recordLoadErrorTitleLabel = component.get("v.recordLoadErrorTitleLabel");
          		var recordLoadErrorLabel = component.get("v.recordLoadErrorLabel");
                helper.bc_throwEventMessage(component, recordLoadErrorLabel, recordLoadErrorTitleLabel, "error");
            }
        });
	 	$A.enqueueAction(action);
    },

	// This method is called when the page is changed
	pageChange : function(component, helper) {
		var itemsperpage = Number(component.get("v.itemsperpage"));
		var newpage = Number(component.get("v.currentpage"));
		var recordcount = Number(component.get("v.recordcount"));
		var newhighindex = newpage * itemsperpage;
		var	newlowindex = (newhighindex - itemsperpage) + 1;
		if(newhighindex > recordcount){
			newhighindex = recordcount;
		}
		component.set("v.highindex", newhighindex);
		component.set("v.lowindex", newlowindex);
		helper.sendPaginationEvent(component, helper);
	},

	// This method sends out the event to notify the rows that the page
	// or items per page has changed and they need to rerender
	sendPaginationEvent : function(component, helper) {
		var itemsperpage = Number(component.get("v.itemsperpage"));
		var currentpage = Number(component.get("v.currentpage"));
		var highindex = Number(component.get("v.highindex"));
		var lowindex = Number(component.get("v.lowindex"));
		var updatePaginationEvent = $A.get("e.et4ae5:DataTablePlusPaginationUpdate");
		updatePaginationEvent.setParams({
            "itemsperpage": itemsperpage,
            "page": currentpage,
			"highindex": highindex,
			"lowindex": lowindex
        }).fire();
	},

	// This method executes when the Search button is clicked. It then sends out
	// an event to the subcomponent to do the search if the search text is not blank.
	// If the search text is blank, this method sends out an event to the rows in the
	// table to display.
	searchRecords : function(component, helper) {
		// Get the search value
		var searchvalue = component.get("v.searchvalue");
		var overwritten;
		// Check to see if there is a search value
		if (searchvalue) {
			var dataTablePlusUpdate = $A.get("e.et4ae5:DataTablePlusStartSearch");
			dataTablePlusUpdate.fire();
		}else{
			// If no search value, display all records
			overwritten = true;
			// Get the reocords
			var records = component.get("v.records");
			// Create an object to keep track of the object id to new
			// row index mappings
			var indexes = {};
			indexes["SalesForceId"] = "New Idex";
			// Loop through the records and create a new index
			for(var i = 0; i < records.length; i++){
				// Get the record
				var record = records[i];
				// Get the record id
				var recordId = record.Id + "";
				// Set the new index for the object id
				indexes[recordId] = i;
			}
			// Send out the event to the rows that thier indexes
			// has chaned and they need to rerender.
			var dataTablePlusSearch = $A.get("e.et4ae5:DataTablePlusSearch");
			dataTablePlusSearch.setParams({
				"idexes": indexes
			}).fire();
			// Set the new record count to the number of records
			// found in search. Will be 0 if no records were found
			// to meet the search criteria
			component.set("v.recordcount", records.length);
			// Set the page back to 1
			component.set("v.currentpage", 1);
		}
		// Check to see if the method was overwritten or there was a search
		// with an empty search value
		if(overwritten){
			// Reset the new high and low index. This should be new information
			// if the searchProcess method was overwritten
			var recordcount = Number(component.get("v.recordcount"));
			var itemsperpage = Number(component.get("v.itemsperpage"));
			var newpage = Number(component.get("v.currentpage"));
			var newhighindex;
			var newlowindex;
			var maxpage;
			if(recordcount > 0){
				newhighindex = newpage * itemsperpage;
				newlowindex = (newhighindex - itemsperpage) + 1;
				maxpage = recordcount / itemsperpage;
				var remainder = recordcount % itemsperpage;
				if(remainder == 0){
					maxpage--;
				}
				if(newhighindex > recordcount){
					newhighindex = recordcount;
				}
			}else{
				newlowindex = 0;
				newhighindex = 0;
				maxpage = 0;
			}
			component.set("v.maxpage", maxpage);
			component.set("v.highindex", newhighindex);
			component.set("v.lowindex", newlowindex);
		}
	},

	// This method executes when the Save button is pressed
	// It sends out an event for the child components to do validations
	// to see if the records that have been changed can be updated
    sendUpdateRecordEvent : function(component, helper) {
		var dataTablePlusUpdate = $A.get("e.et4ae5:DataTablePlusUpdate");
		dataTablePlusUpdate.fire();
    },

	// This method updates the records that have changed in the table.
	// This method is called from subcomponents that have extended
	// the DataTablePlus component.
	updateRecords : function(component, helper) {
		var updatedRecords = component.get("v.updatedRecords");
        if(updatedRecords.length > 0){
            var action = component.get("c.updateRecords");
            action.setParams({
                sObjects : updatedRecords
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                var cmpMessageEvent = component.getEvent("BCMessage");
                if (component.isValid() && state === "SUCCESS") {
                    var result = JSON.parse(response.getReturnValue());
                    if(!result.hasErrors) {
                        component.set("v.updatedRecords", []);
        				var returnPage = component.get("v.returnPage");
						window.location.href = "/apex/MarketingCloudSettings";
                    }else{
                        var saveServerErrorTitleLabel = component.get("v.saveServerErrorTitleLabel");
                        var saveServerErrorLabel = component.get("v.saveServerErrorLabel");
                        helper.bc_throwEventMessage(component, result.message, saveServerErrorTitleLabel, "error");
                    }
                }
                if (component.isValid() && state === "ERROR") {
                    var saveServerErrorTitleLabel = component.get("v.saveServerErrorTitleLabel");
                    var saveServerErrorLabel = component.get("v.saveServerErrorLabel");
                    helper.bc_throwEventMessage(component, saveServerErrorLabel, saveServerErrorTitleLabel, "error");
                }
            });
            $A.enqueueAction(action);
        }else{
            var saveNoChangeTitleLabel = component.get("v.saveNoChangeTitleLabel");
            var saveNoChangeLabel = component.get("v.saveNoChangeLabel");
            helper.bc_throwEventMessage(component, saveNoChangeLabel, saveNoChangeTitleLabel, "error");
        }
	},

	// This method sends out the event to notfiy the rows that the
	// Select All check box has been clicked and they need to rerender
	sendSelectAllEvent : function(component, helper) {
		var selectall = component.find("selectall");
		var newselectall = selectall.get("v.value");
		var dataTablePlusSelectAll = $A.get("e.et4ae5:DataTablePlusSelectAll");
		dataTablePlusSelectAll.setParams({
			"selected": newselectall
        }).fire();
	}
})