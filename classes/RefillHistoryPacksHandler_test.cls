@IsTest
public class RefillHistoryPacksHandler_test {
  @IsTest static void invoke_getDummyData_PlanNacional(){
      String methodName = 'getDummyData';

      Map<String, Object> input = new Map<String, Object>();
      Map<String, Object> outMap = new Map<String, Object>();
      Map<String, Object> options = new Map<String, Object>();
    
      RefillHistoryPacksHandler refillHistory = new RefillHistoryPacksHandler();

        
        input.put('namePack','Plan Nacional 4G');
        String stringStartDate = string.valueOfGmt((system.today()-2));
        String stringEndDate = string.valueOfGmt((system.today()+2));
        input.put('startDateFilter',stringStartDate);
        input.put('endDateFilter',stringEndDate);
      Test.startTest();
      refillHistory.invokeMethod(methodName, input, outMap, options);
      Test.stopTest();
        
        Map<String, Object> mapNode = (Map<String, Object>)outMap.get('Result');
        system.assertNotEquals(null,mapNode.get('PacksList'));
        
    }
    
    @IsTest static void invoke_getDummyData_PlanInternacional(){
      String methodName = 'getDummyData';

      Map<String, Object> input = new Map<String, Object>();
      Map<String, Object> outMap = new Map<String, Object>();
      Map<String, Object> options = new Map<String, Object>();
    
      RefillHistoryPacksHandler refillHistory = new RefillHistoryPacksHandler();

        
        input.put('namePack','Plan Internacional');
        String stringStartDate = string.valueOfGmt((system.today()-2));
        String stringEndDate = string.valueOfGmt((system.today()+2));
        input.put('startDateFilter',stringStartDate);
        input.put('endDateFilter',stringEndDate);
      Test.startTest();
      refillHistory.invokeMethod(methodName, input, outMap, options);
      Test.stopTest();
        
        Map<String, Object> mapNode = (Map<String, Object>)outMap.get('Result');
        system.assertNotEquals(null,mapNode.get('PacksList'));
    }
    
    @IsTest static void invoke_getDummyData_PlanFamilia(){
      String methodName = 'getDummyData';

      Map<String, Object> input = new Map<String, Object>();
      Map<String, Object> outMap = new Map<String, Object>();
      Map<String, Object> options = new Map<String, Object>();
    
      RefillHistoryPacksHandler refillHistory = new RefillHistoryPacksHandler();

        
        input.put('namePack','Plan Familia');
        String stringStartDate = string.valueOfGmt((system.today()-2));
        String stringEndDate = string.valueOfGmt((system.today()+2));
        input.put('startDateFilter',stringStartDate);
        input.put('endDateFilter',stringEndDate);
      Test.startTest();
      refillHistory.invokeMethod(methodName, input, outMap, options);
      Test.stopTest();
        
        Map<String, Object> mapNode = (Map<String, Object>)outMap.get('Result');
        system.assertNotEquals(null,mapNode.get('PacksList'));
    }
    
    @IsTest static void invoke_getDummyData_PlanNumeros(){
      String methodName = 'getDummyData';

      Map<String, Object> input = new Map<String, Object>();
      Map<String, Object> outMap = new Map<String, Object>();
      Map<String, Object> options = new Map<String, Object>();
    
      RefillHistoryPacksHandler refillHistory = new RefillHistoryPacksHandler();

        
        input.put('namePack','Plan Numeros Free');
        String stringStartDate = string.valueOfGmt((system.today()-2));
        String stringEndDate = string.valueOfGmt((system.today()+2));
        input.put('startDateFilter',stringStartDate);
        input.put('endDateFilter',stringEndDate);
      Test.startTest();
      refillHistory.invokeMethod(methodName, input, outMap, options);
      Test.stopTest();
        
        Map<String, Object> mapNode = (Map<String, Object>)outMap.get('Result');
        system.assertNotEquals(null,mapNode.get('PacksList'));
    }
    
    @IsTest static void invoke_getDummyData_Other(){
      String methodName = 'getDummyData';

      Map<String, Object> input = new Map<String, Object>();
      Map<String, Object> outMap = new Map<String, Object>();
      Map<String, Object> options = new Map<String, Object>();
    
      RefillHistoryPacksHandler refillHistory = new RefillHistoryPacksHandler();

        
        input.put('namePack','Other Test');
        String stringStartDate = string.valueOfGmt((system.today()-2));
        String stringEndDate = string.valueOfGmt((system.today()+2));
        input.put('startDateFilter',stringStartDate);
        input.put('endDateFilter',stringEndDate);
      Test.startTest();
      refillHistory.invokeMethod(methodName, input, outMap, options);
      Test.stopTest();
        
        Map<String, Object> mapNode = (Map<String, Object>)outMap.get('Result');
        system.assertNotEquals(null,mapNode.get('PacksList'));
    }
    
    @IsTest static void invoke_getDummyData_PlanInternet(){
      String methodName = 'getDummyData';

      Map<String, Object> input = new Map<String, Object>();
      Map<String, Object> outMap = new Map<String, Object>();
      Map<String, Object> options = new Map<String, Object>();
    
      RefillHistoryPacksHandler refillHistory = new RefillHistoryPacksHandler();

        
        input.put('namePack','Plan Internet 40MB');
        String stringStartDate = string.valueOfGmt((system.today()-2));
        String stringEndDate = string.valueOfGmt((system.today()+2));
        input.put('startDateFilter',stringStartDate);
        input.put('endDateFilter',stringEndDate);
      Test.startTest();
      refillHistory.invokeMethod(methodName, input, outMap, options);
      Test.stopTest();
        
        Map<String, Object> mapNode = (Map<String, Object>)outMap.get('Result');
        system.assertNotEquals(null,mapNode.get('PacksList'));
    }
}