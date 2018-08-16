({  
   apexMethod : function(cmp) {
     
     var action = cmp.get("c.TreeWorkTeamController");
          
     action.setParams({ "str_workTeamId" : cmp.get("v.recordId") });  
     
     action.setCallback(this, function(response) {
     
    	 //debugger;
     
    	 var state = response.getState();
    	  
    	 if (state === "SUCCESS") {
    	  
    		 cmp.set( "v.items", response.getReturnValue());  
    	 }  
     });
 
     //var cmpTarget = cmp.find('changeIt');

     //$A.util.addClass(cmpTarget, 'changeMe');
    
     $A.enqueueAction(action);  
   }  
})