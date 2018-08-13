({
    setJSON : function () {
		return {
            "entries" : [
            	{
            		"title" : $A.get("$Label.et4ae5.TITLE"),
                    "body" : $A.get("$Label.et4ae5.msg0206")
        		},
                {
                    "title" : $A.get("$Label.et4ae5.TITLE"),
                    "body"  : $A.get("$Label.et4ae5.msg0206")
                }
    		]
      	};
    },

    move : function (component) {
        var entries = component.get("v.step_json").entries;
        var pages = entries.length;
        var val = component.get("v.page");

        switch(component.get("v.aur_id")) {
            case "next_btn": 
                if(val === 2 && val === pages) {
                    $A.util.removeClass(component.find("prev_btn"), "hide");
                    $A.util.addClass(component.find("next_btn"), "hide");
                    $A.util.removeClass(component.find("done_btn"), "hide");
                } else if(val === pages) {
                    $A.util.addClass(component.find("next_btn"), "hide");
                    $A.util.removeClass(component.find("done_btn"), "hide");
                } else if (val - 1 === 1) {
                    $A.util.removeClass(component.find("prev_btn"), "hide");
                }
                break;
            case "prev_btn": 
                if(val === 1) {
                    $A.util.addClass(component.find("prev_btn"), "hide");
                } 
                if(val + 1 === pages) {
                    $A.util.removeClass(component.find("next_btn"), "hide");
                    $A.util.addClass(component.find("done_btn"), "hide");
                }
                break;
            case "done_btn":
                $A.util.addClass(component.find("msg_modal"), "hide");
                break;
        }
    }
})