({
    runWizzard : function(component) {
		var divSetup = component.find("divSetup");
        $A.util.addClass(divSetup.getElement(), 'hide');
        var divAutomation = component.find("divAutomation");
        $A.util.removeClass(divAutomation.getElement(), 'hide');
	},
    skipWizzard : function(component) {
		var divSetup = component.find("divSetup");
        $A.util.addClass(divSetup.getElement(), 'hide');
        var divManual = component.find("divManual");
        $A.util.removeClass(divManual.getElement(), 'hide');
	},
    showSetup : function(component) {
        var divSetup = component.find("divSetup");
        $A.util.removeClass(divSetup.getElement(), 'hide');
    }
})