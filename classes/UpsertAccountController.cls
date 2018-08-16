global class UpsertAccountController implements vlocity_cmt.VlocityOpenInterface {
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        if (methodName == 'UpsertAccount')
            UpsertAccount(inputMap);
            
        return true;
    }
    
    private void UpsertAccount(Map<String,Object> inputMap) {
        Map<String,Object> accountData = (Map<String,Object>) inputMap.get('Account');
        
        Account account = new Account(
            Id = (Id) accountData.get('Id'),
            Name = (String) accountData.get('Name'),
            vlocity_cmt__Status__c = (String) accountData.get('Status')
        );
        
        upsert account;
    }
}