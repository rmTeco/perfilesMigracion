({
	// Makes sure at least one Business Unit is enabled
	// before updating records
	preUpdateProcess : function(component, helper) {
		// Flag if errors are found
		var errors = true;
		// Get the records
		var records = component.get("v.records");
		// Loop through the records
		for(var i = 0; i < records.length; i++){
			// Get the record
			var record = records[i];
			// Check to see if the record has been checked
			if(record.et4ae5__Enabled__c == true){
				// Flip flag indicating there are no errors
				errors = false;
				// Call parent helper class updateRecords method
				helper.updateRecords(component, helper);
				// exit loop
				return;
			}
		}
		// Check to see if there were errors
		if(errors) {
			// Get title and message error
			var saveErrorTitleLabel = component.get("v.saveErrorTitleLabel");
			var saveErrorLabel = component.get("v.saveErrorLabel");
			// Get BaseComponent Message event
			var cmpMessageEvent = component.getEvent("BCMessage");
			// Set Message and title
			cmpMessageEvent.setParams({
				"messageTitle" : saveErrorTitleLabel,
				"errorMessage" : saveErrorLabel
			});
			// Fire event
			cmpMessageEvent.fire();
		}
    },

	// Fires out and event to all rows in the table to display or hide them
	// depending on the search text
	searchProcess : function(component, helper) {
		// Get the reocords from the DataTablePlus component
		var records = component.get("v.records");
		// Get the search value from the DataTable plus component
		var searchvalue = component.get("v.searchvalue");
		// Create an object to keep track of the object id to new
		// row index mappings
		var indexes = {};
		indexes["SalesForceId"] = "New Idex";
		// New row index counter
		var newindex = 0;
		// Loop through all the records
		for(var i = 0; i < records.length; i++){
			// Get the record
			var record = records[i];
			// Check to see if the record has the serach value in the specific fields
			if((record.et4ae5__Business_Unit_Name__c.indexOf(searchvalue) > -1) || (record.et4ae5__Business_Unit_ID__c.indexOf(searchvalue) > -1)){
				var recordId = record.Id + "";
				// Set the new index for the object id
				indexes[recordId] = newindex;
				// increment the new row index counter
				newindex++;
			}
		}
		// Send out the event to the rows that thier indexes
		// have chaned and they need to rerender.
		var dataTablePlusSearch = $A.get("e.et4ae5:DataTablePlusSearch");
		dataTablePlusSearch.setParams({
			"idexes": indexes
        }).fire();
		// Set the new record count to the number of records
		// found in search. Will be 0 if no records were found
		// to meet the search criteria
		component.set("v.recordcount", newindex);
		// Set the page back to 1
		component.set("v.currentpage", 1);
	}
})