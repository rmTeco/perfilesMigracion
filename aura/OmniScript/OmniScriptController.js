({
    doInit : function(cmp, event, helper) {
        helper.makeUrl(cmp, cmp.get('v.recordId'), cmp.get('v.type'), cmp.get('v.subtype'), cmp.get('v.language'));
    }
})