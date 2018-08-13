({
    doInit: function(component, event, helper) {
        //Automatic Configuration
        //TODO: Where should we put the HTML if we decide to remove the hard code from here?
        //Previously on start of .set <strong>Connecting to the Marketing Cloud</strong></br></br>\
        //  <p>Before connecting to the Marketing Cloud, you have a few things left to do.\
        //   <br/><br/>\
        component.find("titleDesc").set("v.value",$A.get("$Label.et4ae5.msg0198") + $A.get("$Label.et4ae5.msg0198a"));
        component.find("titleMain").set("v.value",$A.get("$Label.et4ae5.msg0199x"));
        component.find("titleSecMain").set("v.value",$A.get("$Label.et4ae5.msg0200"));

        //Automatic Links
        component.find("helpLeft").set("v.json",helper.getJson_help_left_automatic());
        component.find("helpRight").set("v.json",helper.getJson_help_right_automatic());
        component.find("oAuthConnectJSON").set("v.json",helper.getOAuthConnectJSON());


        //Manual Link (This is initiaized here even though it will be hidden until skipWiz runs)
        component.find("manualLinks").set("v.json",helper.getJson_help_left_manual());
    },

    skipWiz : function (component, event, helper) {
        //Manual Configuration
        component.find("titleDesc").set("v.value",$A.get("$Label.et4ae5.msg0201") + $A.get("$Label.et4ae5.msg0201a"));
        component.set("v.skipWiz", true);

    }
})