({
	doInit : function(component, event, helper) {
		var tableHeaderLabels = component.get("v.tableHeaderLabels");
		var tableHeaders = tableHeaderLabels.split(",");
 		component.set("v.tableHeaders", tableHeaders);
		helper.getRecords(component, helper);
    },

	// Executed when a row sends out a UpdateRecord event
    updateEvent : function(component, event, helper) {
        var record = event.getParam("record");
        var action = event.getParam("action");
        var updatedRecords = component.get("v.updatedRecords");
		for (var i = 0; i < updatedRecords.length; i++) {
			if (updatedRecords[i].Id === record.Id) {
				updatedRecords.splice(i, 1);
				break;
			}
		}
		if(action == "add"){
			updatedRecords.push(record);
		}
		component.set("v.updatedRecords", updatedRecords);
    },

	// Called when the Next pagination button is pressed
	nextPage : function(component, event, helper) {
		var page = Number(component.get("v.currentpage"));
		var newpage = page + 1;
		component.set("v.currentpage", newpage);
		helper.pageChange(component, helper);
	},

	// Called when the Previous button is pressed
	previousPage : function(component, event, helper) {
		var page = Number(component.get("v.currentpage"));
		var newpage = page - 1;
		component.set("v.currentpage", newpage);
		helper.pageChange(component, helper);
	},

	// Called when the Items per Page drop down changes value
	itemsPerPageChange : function(component, event, helper) {
		var itemsperpage = component.find("itemsperpage");
		var newitemsperpage = itemsperpage.get("v.value", itemsperpage);
		var recordcount = Number(component.get("v.recordcount"));
		var newmaxpage = recordcount / newitemsperpage;
		var remainder = recordcount % newitemsperpage;
		if(remainder == 0){
			newmaxpage--;
		}
		component.set("v.maxpage", newmaxpage);
		component.set("v.currentpage", 1);
		component.set("v.itemsperpage", newitemsperpage);
		helper.pageChange(component, helper);
	},

	// Called when Cancel button is pressed
	cancel : function(component, event, helper) {
		window.location.href = "/apex/MarketingCloudSettings";
    },

	// Called when the Search button is pressed
	search : function(component, event, helper) {
		helper.searchRecords(component, helper);
    },

	// Called when the Save button is pressed
	update : function(component, event, helper) {
		helper.sendUpdateRecordEvent(component, helper);
    },

	// Called when the Select All checkbox changes value
	selectAllChange : function(component, event, helper) {
		helper.sendSelectAllEvent(component, helper);
	}
})