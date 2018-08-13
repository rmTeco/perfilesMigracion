@IsTest
public class CustomerHistoryHandler_test {
     @IsTest static void invoke_getDummyData(){
         String methodName = 'getDummyData';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
    
        CustomerHistoryHandler historyHandler = new CustomerHistoryHandler();
        
    Test.startTest();
        historyHandler.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        Map<String, Object> result =(Map<String, Object>)outMap.get('Result');
        
        system.assertNotEquals(null,result.get('RefillsSOSList'));
        system.assertNotEquals(null,result.get('PacksList'));
        system.assertNotEquals(null,result.get('RefillsList'));
        system.assertNotEquals(null,result.get('AdjustmentList'));
        
     }
  
}