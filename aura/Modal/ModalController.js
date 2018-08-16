({
	"destroypopover" : function(cmp, evt, helper) {
		var compEvent = cmp.getEvent("ModalBehavior");
		compEvent.fire();
	},
	"setup" : function(cmp, evt, helper){
		var left = cmp.get("v.JSONLeft");
		var right = cmp.get("v.JSONRight");
		var delta = jsondiffpatch.diff(left, right);
		delta = jsondiffpatch.formatters.html.format(delta, right);
		cmp.set("v.HTMLdifference", delta);
		console.info("delta: ", delta)
	},
})