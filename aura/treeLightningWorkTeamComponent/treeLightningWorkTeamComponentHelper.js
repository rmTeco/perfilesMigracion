({  
   apexMethod : function(cmp) {
     
     var action = cmp.get("c.getWorkTeamHierarchy");
          
     action.setParams({ str_workteamId : cmp.get("v.recordId") });  
     
     action.setCallback(this, function(response) {
     
    	 //debugger;
     
    	 var state = response.getState();
    	  
    	 if (state === "SUCCESS") {
    	  
    		 cmp.set( "v.items", response.getReturnValue());  
    	 }  
     });
    
     $A.enqueueAction(action);  
   }  
})