({
    isLanguageRTL: function(component) {
        var action = component.get('c.isLanguageRTL');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === 'SUCCESS') {
                var isLanguageRTL = response.getReturnValue();
                component.set('v.isLanguageRTL', isLanguageRTL);
            } else if (component.isValid() && state === 'ERROR') {
                console.error('Profiler - failed to detect if user is RTL, therefore setting to false', response.getError());
                component.set('v.isLanguageRTL', false);
            }
        });
        $A.enqueueAction(action);
    },

    getNamespacePrefix: function(component) {
        var helper = this;
        var action = component.get('c.getNameSpacePrefix');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === 'SUCCESS') {
                component.set('v.nsPrefix', response.getReturnValue());
            } else if (component.isValid() && state === 'ERROR') {
                console.error('Profiler - failed to get Namespace prefix', response.getError());
            }
            helper.updateIsFullyLoaded(component);
        });
        $A.enqueueAction(action);
    },

    updateIsFullyLoaded: function(component) {
        var nsPrefix = component.get('v.nsPrefix');
        var entityId = component.get('v.entityId');
        if (nsPrefix != null && entityId != null) {
            component.set('v.isFullyLoaded', true);
        }
    }

})