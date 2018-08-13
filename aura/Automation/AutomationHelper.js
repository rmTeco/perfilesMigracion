({
	// Method called from the Rerenderer class when the component rerenders
	// This method shows the results of running the setAutomations method within the Modal Dialog
	showAutomationResult : function(component) {
		var showResult = $A.util.getBooleanValue(component.get("v.showResult"));
		if (showResult) {
            var resultError = $A.util.getBooleanValue(component.get("v.resultError"));

            if (resultError) {
	            component.set("v.okLabel", $A.get("$Label.et4ae5.okay"));
                component.set("v.serverResponse", $A.get("$Label.et4ae5.msg0212"));
            } else {
                component.set("v.serverResponse", $A.get("$Label.et4ae5.configSuccess") + "!");
            }
            
            $A.util.removeClass(component.find("ok_done_btn"), "hide");
            $A.util.addClass(component.find("buffer"), "hide");
		}else{
            $A.util.addClass(component.find("basicModal"), "hide");
		}
	},

	// Method called from the Rerenderer class when the component rerenders
	// This method shows the Modal Dialog and spinner while running the setAutomations method
	showModal : function(component) {
        var showModal = $A.util.getBooleanValue(component.get("v.showModal"));
		if (showModal) {
			$A.util.addClass(component.find("buffer"), "spinner uiSpinner");
            $A.util.removeClass(component.find("basicModal"), "hide");
            component.set("v.serverResponse", $A.get("$Label.et4ae5.configMCCC"));
		}
	},

    getMessagingModalJSON : function () {
        return {
            "entries" : [
                {
                    "title" : $A.get("$Label.et4ae5.preInstDefWfUsr"),
                    "body" : $A.get("$Label.et4ae5.msg0191")
                },
                {
                    "title" : $A.get("$Label.et4ae5.preInstSessSets"),
                    "body"  : $A.get("$Label.et4ae5.msg0192")

                },
                {
                    "title" : $A.get("$Label.et4ae5.preInstFLS"),
                    "body"  : $A.get("$Label.et4ae5.msg0193") + $A.get("$Label.et4ae5.msg0193a")
                },
                {
                    "title" : $A.get("$Label.et4ae5.preInstUpdtPgLyts"),
                    "body"  : $A.get("$Label.et4ae5.msg0194")

                }
            ]
        };
    },

    getSidebySideJSON : function() {
        return {
            title : $A.get("$Label.et4ae5.sbSCmp"),
            entries : [
                {
                    label : $A.get("$Label.et4ae5.ipAdrsses"),
                    content : $A.get("$Label.et4ae5.msg0195")
                },
                {
                    label : $A.get("$Label.et4ae5.workflows"),
                    content : $A.get("$Label.et4ae5.msg0196") + $A.get("$Label.et4ae5.msg0196a") + $A.get("$Label.et4ae5.msg0196b")
                },
                {
                    label : $A.get("$Label.et4ae5.permSets"),
                    content : $A.get("$Label.et4ae5.msg0197") + $A.get("$Label.et4ae5.msg0197a")
                }
            ]
        };
    },

    setAutomations : function (component, helper) {
        var action = component.get("c.finishConfiguration");
        action.setCallback(this, function(response) {
            var state = response.getState();            
            if(component.isValid() && state === "SUCCESS") {
            	component.set("v.configurationStateLoaded", true);            				    
			    var data = JSON.parse(response.getReturnValue());
			    component.set("v.configurationStateResponse", data);                                                
				var flag = data.hasErrors;
				component.set("v.resultError", flag);
				component.set("v.showResult", true);
            }else{
                var errorEvent = $A.get("e.et4ae5:ThrowErrorMessage");
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message)
                        errorEvent.setParams({"title" : $A.get("$Label.et4ae5.unkError"), "message" : errors[0].message});
                }
                else
                    errorEvent.setParams({"title" : $A.get("$Label.et4ae5.unkError"), "message" : $A.get("$Label.et4ae5.unkError")});

                errorEvent.fire();
				component.set("v.showResult", false);
            }
        });
        $A.enqueueAction(action);
	},
	
	setAutomationDom : function (component) {	
		if($A.util.getBooleanValue(component.get("v.configurationStateLoaded")))
		{					
			var data = component.get("v.configurationStateResponse");
			if(data)
			{																							
				var entries = (data).automations;
                var pass = '<div class="pass_check">\
                            <svg version="1.1" id="Layer_1" class="svg_image" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"\
                            viewBox="0 0 600 600" enable-background="new 0 0 600 600" xml:space="preserve">\
                                <path fill-rule="evenodd" clip-rule="evenodd" fill="#49AC4A" d="M237.4,359.8c-6.1-13.6,1-8.5-9.4-18.6\
                                    c-10.6-10-91.3-87.6-91.3-87.6c-30.5-29.2-31.3-28.5-59.9,1.2l-23.7,24.4c-29,30-24.1,35.2,1,59.6l60.9,58.3\
                                    c16.6,16.1,44.1,42.3,60.9,58.4l30.4,29.1c30.3,29.3,30.3,29.1,59.8-1l29.3-30.3c16.2-16.6,42.5-43.8,58.7-60.5l192.4-198.6\
                                    c29.3-30.2,29.3-30.2-1.1-59.5l-21-20c-29-28-30.3-29.4-59.8,1.1L272.3,314.3c-12.6,10.7-19.8,20.4-25.7,26.6\
                                    c-6.1,6.2-9.2,18-9.2,18V359.8z"/>\
                            </svg>\
                        </div>';
                var fail = '<div class="fail_check">\
                            <svg version="1.1" id="Layer_2" class="svg_image" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"\
                            viewBox="0 0 600 600" enable-background="new 0 0 600 600" xml:space="preserve">\
                                <g>\
                                    <defs>\
                                        <path id="SVGID_1_" d="M462.6,51.1L299.8,213.9L137,51.1c-4.7-4.7-12.4-4.7-17.2,0l-68.5,68.6c-4.7,4.7-4.7,12.4,0,17.1\
                                            l162.9,162.8L51.3,462.4c-4.7,4.7-4.7,12.4,0,17.1l68.6,68.5c4.7,4.7,12.4,4.7,17.1,0l162.8-162.8L462.6,548\
                                            c4.7,4.7,12.4,4.7,17,0l68.5-68.5c4.8-4.7,4.8-12.4,0.1-17.1L385.4,299.6l162.8-162.8c4.7-4.7,4.7-12.4,0-17.1l-68.5-68.6\
                                            C475,46.4,467.3,46.4,462.6,51.1z"/>\
                                    </defs>\
                                    <clipPath id="SVGID_2_">\
                                        <use xlink:href="#SVGID_1_"  overflow="visible"/>\
                                    </clipPath>\
                                    <rect x="-103.7" y="-103.9" clip-path="url(#SVGID_2_)" fill="#ABABAB" width="806.9" height="806.9"/>\
                                </g>\
                            </svg>\
                        </div>';
                var htmlString = '';
                for(var i = 0; i < entries.length; i++) {
                	htmlString = htmlString + 
                     "<div class='row_container'>\
                            <div class='workflow_entry'>\
                                <div class='title'>\
                                    <p>" + entries[i].title + "</p>\
                                 </div>\
                                <div " + (!entries[i].errored ? "hidden='true'" : "") + " class='flow_description'>" +
                                 entries[i].message +
                            "</div>\
                        </div>" +
                       (!entries[i].errored ? pass : fail) +
                    "</div>";
                }
                component.set("v.htmlResults", htmlString);
			}		
		}		
	}
})