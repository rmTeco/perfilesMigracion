({
    doneRendering: function(cmp, event, helper) {
    	if(!cmp.get("v.isDoneRendering")){
    		//Flip the flag so the logic below is only fired once
    		cmp.set("v.isDoneRendering", true);
    		//Get the JSON passed from parent
    		var json = cmp.get("v.json");
    		var entries = json.entries;
    		// Check to make sure there is at least 1 entry
    		if(entries.length > 0){
    			// Set the text area to the first entry in JSON
    			var optTextArea = cmp.find("optTextArea");
    			if(optTextArea){
    				optTextArea.set("v.value", entries[0].content);
    			}
    		}
    	}        		
	},

	setTextArea : function(component, event, helper) {
		// Get the HTML object that was clicked on (Set in Controller)
		var selectedLabel = event.getSource();		
		// Get the label of the HTML element
		var labelText = selectedLabel.get("v.label");
		// Get the JSON the Component is built on
		var json = component.get("v.json");
        var entries = json.entries;
		// Loop through the entries in the JSON
		entries.forEach( function (entry) {
			// Check if the entry in the JSON equals the Selected label
            if(entry.label == labelText) {
				// Set the attribute for the Textarea (rerender fires)
				component.set("v.selectedContent", entry.content); 
				component.set("v.selectedLabel", entry.label); 
			}
        });	
		// Set the selected html elements style to active (ist-group-item active)
		selectedLabel.set("v.class", "list-group-item active");
        
        //Set the not selected html elements style to inactive
        var allLinks = component.find("sbsOption");
        for(var i = 0; i < allLinks.length; i++) {
            if(allLinks[i].get("v.label") !== component.get("v.selectedLabel"))
                allLinks[i].set("v.class", "list-group-item");
        }
	}
})