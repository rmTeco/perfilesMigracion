({    
    getHierarchyWorkTeam : function (cmp) {
        var spinner = cmp.find("spnr");
        var workTeamId = cmp.get("v.workTeamId"); 
        var vlcActionId = cmp.get("v.vlcActionId"); 

        var action = cmp.get("c.getHierarchyWorkTeam");

        action.setParams({ "teamId" : workTeamId, "permissionId" : vlcActionId });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var selectedRows = new Array();
                var data = response.getReturnValue();
                cmp.set('v.originalData', data);

                for(var i=0; i<data.length;i++) {
                    if(data[i].checked){
                        selectedRows[i] = data[i].parentTeam;
                    }                                                                              
                }

                this.clearData(data);            
                cmp.set('v.gridData', data);
                
                if(selectedRows.length > 0){
                    cmp.set('v.gridSelectedRows', selectedRows);
                }                
                
                var treeGridCmp = cmp.find('workTeamTree');
                treeGridCmp.expandAll();
                
				$A.util.toggleClass(spinner, "slds-hide");
            }else{
                var error = response.getError();
                console.log('ERROR: ' + error);
                $A.util.toggleClass(spinner, "slds-hide");
			}
         });
         $A.enqueueAction(action);
    },
    clearData: function (data) {
        for(var i=0; i<data.length;i++) {
            data[i]._children = data[i]['children'];
            var data_children = data[i].children;
            if(data_children.length > 0){
                this.clearData(data_children);
            }                                                           
        }
    },
    saveHierarchyPermission : function (cmp) {
        var spinner = cmp.find("spnr");
        var workTeamId = cmp.get("v.workTeamId"); 
        var vlcActionId = cmp.get("v.vlcActionId"); 
        var vlcActionName = cmp.get("v.vlcActionName");
        var treeGridCmp = cmp.find('workTeamTree');
        var selectedRows = treeGridCmp.getSelectedRows();
        var selectedTeams = new Array();

        for(var i=0; i<selectedRows.length;i++) {
            selectedTeams[i] = selectedRows[i].teamId;                                                          
        }
        
        console.log(selectedTeams);

        var action = cmp.get("c.getPermissionAsigmentResult");
        action.setParams({ "teamId" : workTeamId, "permissionId" : vlcActionId , "vlcActionName" : vlcActionName, "selectedTeams" : selectedTeams });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                if(data){
                    alert('Datos guardados satisfactoriamente.');
                }else{
                    alert('Ha ocurrido un error al guardar los datos.');
                }
				$A.util.toggleClass(spinner, "slds-hide");
            }else{
                var error = response.getError();
                console.log('ERROR: ' + error);
                $A.util.toggleClass(spinner, "slds-hide");
            }
            $A.util.toggleClass(spinner, "slds-hide");
         });
         $A.enqueueAction(action);
    },     
})