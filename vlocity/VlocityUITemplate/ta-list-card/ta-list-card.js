function openCasesInNewTab() {
 sforce.console.openPrimaryTab(null, '/500', true, '', true);
        
         
            var primaryTab = exchangeForPromise(sforce.console.getEnclosingPrimaryTabId);
            // 1. Get tab ids.
            $.when(primaryTab)
                .done(function(primaryTabResult) {
                    sforce.console.closeTab(primaryTabResult.id);
                });
                
        
}