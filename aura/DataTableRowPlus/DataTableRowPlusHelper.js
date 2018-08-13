({
	// This method is called from the Renderer class when
	// the row renders and rerenders. This method is responsible
	// for showing or hiding the row.
	displayRow : function (component) {	
		var row = component.find("row");
		var record = component.get("v.record");
		var page = Number(component.get("v.page"));
		var itemsperpage = Number(component.get("v.itemsperpage"));
		var index = Number(component.get("v.index"));
		var highindex = Number(component.get("v.highindex"));
		var lowindex = Number(component.get("v.lowindex"));
		if(row){
			if(highindex > index && (index + 1) >= lowindex ) {
				$A.util.removeClass(row, 'hide');
			}else{
				$A.util.addClass(row, 'hide');
			}
		}
	}
})