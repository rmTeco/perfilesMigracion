({
	rerender : function(cmp, helper){
		this.superRerender();
		helper.showModal(cmp);
		helper.setAutomationDom(cmp);
		helper.showAutomationResult(cmp);
	}
})