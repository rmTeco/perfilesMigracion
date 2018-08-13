({
    handleevent: function(component, event, helper) {
        console.log('breadEvent called');
        component.set('v.myBreadcrumbsC', event.getParam('myBreadcrumbs'));
        component.set('v.activeElementC', event.getParam('activeElement'));
	}
})