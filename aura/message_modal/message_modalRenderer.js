({
	afterRender : function (component, event, helper) {
        var ret = this.superAfterRender();

        var entries = component.get("v.step_json").entries;
        var pages = entries.length;
        component.set("v.head", entries[0].title);
        component.set("v.cont", entries[0].body);
        
        if(pages == 1) {
            $A.util.addClass(component.find("page_steps"), "hide");
            $A.util.removeClass(component.find("done_btn"), "hide");
        } else {
           $A.util.removeClass(component.find("next_btn"), "hide");
           component.set("v.total_pages", pages);
        }

        return ret;
    },

    rerender : function(component, helper) {
        this.superRerender();
        var aur_id = component.get("v.aur_id");
        if(aur_id === "next_btn" || aur_id === "prev_btn" || aur_id === "done_btn") {
            helper.move(component);        
        }
        
    } 
})