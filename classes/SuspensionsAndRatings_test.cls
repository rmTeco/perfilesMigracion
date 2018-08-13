@IsTest
public class SuspensionsAndRatings_test {
	
    @IsTest static void invoke_getHistoric(){
    	String methodName = 'getHistoric';

    	Map<String, Object> input = new Map<String, Object>();
    	Map<String, Object> outMap = new Map<String, Object>();
    	Map<String, Object> options = new Map<String, Object>();
		
    	SuspensionsAndRatings suspAndReco = new SuspensionsAndRatings();
        
        Id consumerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        Account acc = new Account(RecordTypeId = consumerRecordTypeId, Name = 'Sample Account', AccountNumber = '1234', DocumentType__c = 'DNI', DocumentNumber__c = '12345678');
        insert acc;
        
        Asset asset = new Asset(Name = 'asset1', vlocity_cmt__LineNumber__c = '1234567890', AccountId = acc.Id, Sub_Status__c = 'Siniestro');
        insert asset;
        
        Transaction_History__c transHist = new Transaction_History__c(Account__c = acc.Id, Asset__c =asset.Id);
        insert transHist;
        
        input.put('assetId',asset.Id);
        input.put('accountId',acc.Id);
        input.put('processTransaction','Todos'); 
        input.put('motiveTransaction','Siniestro');
     
    
    	Test.startTest();
    	suspAndReco.invokeMethod(methodName, input, outMap, options);
		Test.stopTest();
        
        system.assertNotEquals(null,outMap.get('Result'));
    }
}