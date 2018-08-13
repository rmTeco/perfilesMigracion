({
    navigateTo : function(cmp) {
        var item = cmp.get('v.itemObj');
        var myEvent = cmp.getEvent('actionClick');
        myEvent.setParams({'item' : item});
        myEvent.fire();
    }
})