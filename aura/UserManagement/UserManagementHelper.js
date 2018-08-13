({
	// Checks to make sure at least one User is an Admin
	// before attempting to update records
    preUpdateProcess : function(component, helper) {
		// Flag indicating if there are errors 
		var errors = true;
		// Get the rows in the table
		var records = component.get("v.records");
        for (var i = 0; i < records.length; i++) {
            var checkbox = records[i].et4ae5__ExactTargetForAppExchangeAdmin__c;

            // If the admin checkbox is true for at least one record, save the changes
            if (checkbox == true) {
            	// Flip flag indicating there are no errors
            	errors = false;
				// Call the parent helper class method updateRecords
                helper.updateRecords(component, helper);
				// Get out of loop
                return;
            }
        }
		// Check to see if there are errors
		if(errors) {
			// There were errors, get the message and lable
			var saveErrorTitleLabel = component.get("v.saveErrorTitleLabel");
			var saveErrorLabel = component.get("v.saveErrorLabel");
			// Get the BaseComponent Message Event
			var cmpMessageEvent = component.getEvent("BCMessage");
			// Set the Title and Message 
			cmpMessageEvent.setParams({
				"messageTitle" : saveErrorTitleLabel,
				"errorMessage" : saveErrorLabel
			});
			// Fire the Event which will be caught by BaseComponent and displayed
			cmpMessageEvent.fire();
        }
    },

	// Fires out and event to all rows in table to display or hide them
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
			if((record.Name.indexOf(searchvalue) > -1) || (record.Username.indexOf(searchvalue) > -1)){
				var recordId = record.Id + "";
				// Set the new index for the object id
				indexes[recordId] = newindex;
				// increment the new row index counter
				newindex++;
			}
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
		component.set("v.recordcount", newindex);
		// Set the page back to 1
		component.set("v.currentpage", 1);
	}
})