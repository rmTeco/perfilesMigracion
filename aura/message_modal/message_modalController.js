({  
    doInit : function(component, event, helper) {
        var json = component.get("v.step_json");

        if(json  === null || json === "undefined") {
            component.set("v.step_json",helper.setJSON());
        }
        
        component.set("v.page", 1);
    },
    
    move : function(component, event, helper) {
        component.set("v.aur_id",event.getSource().getLocalId());
        var entries = component.get("v.step_json").entries;
        var val = component.get("v.page");
        switch(component.get("v.aur_id")) {
            case "next_btn": 
                component.set("v.cont", entries[val].body);
                component.set("v.head", entries[val].title);
                val++;
                break;
            case "prev_btn": 
                val--;
                component.set("v.cont", entries[val - 1].body);
                component.set("v.head", entries[val - 1].title);
                break;
        }
        component.set("v.page", val);
    },
})