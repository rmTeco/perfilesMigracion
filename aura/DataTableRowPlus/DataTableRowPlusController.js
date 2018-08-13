({
	// This method executes when the Data Table updates the
	// current page or the items per page. The render then
	// rerenders the row.
	displayRowUpdate : function(component, event, helper) {
		var itemsperpage = event.getParam("itemsperpage");
		var page = event.getParam("page");
		var highindex = event.getParam("highindex");
		var lowindex = event.getParam("lowindex");
		component.set("v.itemsperpage", itemsperpage);
		component.set("v.page", page);
		component.set("v.highindex", highindex);
		component.set("v.lowindex", lowindex);
	},
	
	// This method executes when the Data Table updates the 
	// row's index. For example, when the Search button is 
	// clicked. The render then rerenders the row using a
	// helper method.
	upddateIndex : function(component, event, helper) {
		// Get the map of new indexes from the event
		var indexes = event.getParam("idexes");
		// Get the record for this row
		var record = component.get("v.record");
		// Get the records SalesForce record id
		var recordId = record.Id + "";
		// Check to see if the rows index has been updated
		// using the associated record id
		if (recordId in indexes) {
			// The rows index has been updated. Set the new
			// index and rerender the row.
			var newindex = indexes[recordId];
			component.set("v.index", newindex);
		} else {
			// The rows index has NOT been updated. Set the
			// index to -2 (hide) and rerender the row.
			component.set("v.index", -2);
		}			
	}				
})