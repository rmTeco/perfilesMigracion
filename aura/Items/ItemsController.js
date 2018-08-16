({
    "showpopover" : function(cmp, event, helper) {
        var popover = cmp.find("popover");
    },
    "copy" : function(cmp, event) {
        var selectedItem = event.currentTarget;
        var index = selectedItem.dataset.record;
        var data = cmp.get("v.OSElements")[index];
        try {
            var input = document.createElement("INPUT");
            input.setAttribute("type", "text");
            input.setAttribute("value", data.vlocity_cmt__PropertySet__c);
            var copyText = input;
            copyText.select();
            var successful = document.execCommand("copy");
            var msg = successful ? 'successful' : 'unsuccessful';  
            console.log('Copy email command was ' + msg);  
        } catch(err){
            console.log('Oops, unable to copy');
        }
    },
})