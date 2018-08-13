({
	getWorkTeams : function(component, event) {
		component.set("v.WorkTeams",[]);
        var keyName = component.get("v.KeyName");
        var action = component.get("c.getWorkTeamsByKeyName");
        action.setParams({
            "keyName": keyName
        });
        
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.WorkTeamsTMP",response.getReturnValue().workteams);
                component.set("v.LabelsW",response.getReturnValue().labels);
                this.getSubList(component);
                component.set("v.isLoading","false");
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
        component.set("v.isLoading","true");
	},
    getSubList : function(component){
        var itemPorPage = 9;
        var start = 0;
        var list = component.get("v.WorkTeamsTMP");
        if (list && start <= list.length) {
          	var end = (list.length >= start + itemPorPage) ? start + itemPorPage : list.length;
            var card = document.querySelector(".card_item");
        	component.set("v.WorkTeams", component.get("v.WorkTeams").concat(list.slice(start,end)));
            component.set("v.nextItem",end);
            window.scrollTo(0, window.scrollY - 600);
        }
    },
    onScroll : function(component) {
        window.addEventListener("scroll", function(){
            var body = document.body;
            var html = document.documentElement;
        
        	var height = Math.max( body.scrollHeight, body.offsetHeight, 
                               html.clientHeight, html.scrollHeight, html.offsetHeight );
            
            if (html.clientHeight + window.scrollY >= height) {
                var itemPorPage = 9;
                var start = component.get("v.nextItem");
                var list = component.get("v.WorkTeamsTMP");
                if (list && start <= list.length) {
                    var end = (list.length >= start + itemPorPage) ? start + itemPorPage : list.length;
                    var card = document.querySelector(".card_item");
                    component.set("v.WorkTeams", component.get("v.WorkTeams").concat(list.slice(start,end)));
                    component.set("v.nextItem",end);
                    window.scrollTo(0, window.scrollY - 600);
                }
            }
        });
    },
    deleteRecord : function(component, event) {
        var id = event.getSource().get("v.name");
        var action = component.get("c.setInactiveWorkTeam");
        action.setParams({
            "id": id
        });
        
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                if(response.getReturnValue()) {
                    alert('Registro inactivado satisfactoriamente.!');
                    this.getWorkTeams(component, event);
                } else {
                    alert('No se puede inactivar el Work Team.\nVerifique que no tenga usuarios asociados activos.');
                }
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    }
})