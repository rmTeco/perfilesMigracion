({        
    afterRender: function (component, helper) {
        this.superAfterRender();
        helper.showModal(component);
    },
    
    rerender : function(component, helper){        
        this.superRerender();
        helper.showModal(component);
    }
})