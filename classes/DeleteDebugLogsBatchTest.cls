@isTest
public class DeleteDebugLogsBatchTest{
  
    static testmethod void test() {  
       Map<String, Object> input = new Map<String, Object>();
       input.put('nodo1','test1');
       input.put('nodo2','test2');
        
       for(Integer i=0; i<10; i++)
           DebugInfo.AddDebugInfoEntry('Suspensions', 'GenerateAssetToOrderInputJSON', String.valueOf(input));
        
       Test.startTest();
        
       DeleteDebugLogsBatch myDebugLog = new DeleteDebugLogsBatch();
       ID batchId = Database.executeBatch(myDebugLog);
    
       System.debug('Id: '+batchId);
       
       //String sch = '0 0 23 * * ?';
       //System.schedule('Test Territory Check', sch, taSalesChecTest);
        
       Test.stopTest();
       //System.debug('Here code new'+ taSalesChecTest);
       // after the testing stops, assert records were updated properly
       //System.assertEquals(10, [select count() from contact where MailingCity = 'New York']);
    }

}