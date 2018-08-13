({
	// Executes when the row renders. Calls the
	// helper method displayRow to show or hide
	// row
	render : function(component, helper) {
		var ret = this.superRender();
		helper.displayRow(component);
		return ret;
	},

	// Executes when the row rerenders. Calls the
	// helper method displayRow to show or hide
	// row
	rerender : function(component, helper){
		this.superRerender();
		helper.displayRow(component);
	}
})