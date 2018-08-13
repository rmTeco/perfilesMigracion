({
	render : function(cmp, helper) {
		var ret = this.superRender();
		helper.displayButton(cmp);
		return ret;
	},

	rerender : function(cmp, helper){
		this.superRerender();
		helper.displayButton(cmp);
	}
})