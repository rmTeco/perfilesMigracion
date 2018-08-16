({
	doInit: function (cmp, event, helper)
	{  
		helper.apexMethod(cmp);  
	},  
	handleSelect: function (cmp, event, helper) {
   
	   //Find the text value of the component with aura:id set to "address"
	   var myName = event.getParam('name');

	   console.log("You selected: " + myName); 

        //This is important.  Notice how i get the event.
        var updateEvent = $A.get("e.c:treeLightningWorkTeamEvent");
        updateEvent.setParams({"idSelectedRecord": myName});
        updateEvent.fire(); 
   }  
})