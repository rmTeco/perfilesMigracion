({     
    afterRender : function(cmp,helper) {          
        this.superAfterRender();                
        helper.afterLoad(cmp);        
    },    

    rerender : function(cmp, helper) {
        this.superRerender();
        helper.showHideElements(cmp);
        helper.setLog(cmp);                    
        helper.startLog(cmp);
        helper.checksendTypes(cmp);
		helper.cancelSaveSettings(cmp);
        helper.editMCSetting(cmp);       
		helper.advancedSettings(cmp);  
    }
})