@IsTest
public class ConsumptionDetailsHandlerTest {
    @IsTest static void filterDataFamilyInternetTest(){
      System.debug('ENTRO ConsumptionDetailsHandlerTest.filterDataFamilyInternetTest'); 
        
        String methodName = 'filterDataByFamily';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        input.put('familyFilter', 'Internet');
    input.put('startDateFilter','21/01/2018');
    input.put('endDateFilter','21/03/2018');
        input.put('facturaFilter','A');
        
        ConsumptionDetailsHandler consumption = new ConsumptionDetailsHandler();
        
        Test.startTest();
        consumption.invokeMethod(methodName, input, outMap, options);
    Test.stopTest();
    
    List<Object> outputList = (List<Object>)outMap.get('Result');
        if(outputList.size() > 0){
          Map<String, String> t1 = (Map<String, String>)outputList.get(0);
          String t2 = t1.get('Family');
          system.assertEquals('Internet',t2); 
        }

    }
    
    @IsTest static void filterDataFamilyPrepaidTest(){
      System.debug('ENTRO ConsumptionDetailsHandlerTest.filterDataFamilyPrepaidTest'); 
        
        String methodName = 'filterDataByFamily';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        input.put('familyFilter', 'Prepaid');
    input.put('startDateFilter','21/01/2018');
    input.put('endDateFilter','21/03/2018');
        input.put('facturaFilter','A');
        
        ConsumptionDetailsHandler consumption = new ConsumptionDetailsHandler();
        
        Test.startTest();
        consumption.invokeMethod(methodName, input, outMap, options);
    Test.stopTest();
    
    List<Object> outputList = (List<Object>)outMap.get('Result');
    
    Map<String, String> t1 = (Map<String, String>)outputList[0];
    
    String t2 = t1.get('Family');
    
    system.assertEquals('Prepaid',t2);
    }
    
    @IsTest static void filterDataFamilyFixedTest(){
      System.debug('ENTRO ConsumptionDetailsHandlerTest.filterDataFamilyFixedTest'); 
        
        String methodName = 'filterDataByFamily';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        input.put('familyFilter', 'Fixed');
    input.put('startDateFilter','21/01/2018');
    input.put('endDateFilter','21/03/2018');
        input.put('facturaFilter','A');
        
        ConsumptionDetailsHandler consumption = new ConsumptionDetailsHandler();
        
        Test.startTest();
        consumption.invokeMethod(methodName, input, outMap, options);
    Test.stopTest();
    
    List<Object> outputList = (List<Object>)outMap.get('Result');
    
    Map<String, String> t1 = (Map<String, String>)outputList[0];
    
    String t2 = t1.get('Family');
    
    system.assertEquals('Fixed',t2);
    }
    
    @IsTest static void filterDataFamilyPospaidTest(){
      System.debug('ENTRO ConsumptionDetailsHandlerTest.filterDataFamilyPospaidTest'); 
        
        String methodName = 'filterDataByFamily';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        input.put('familyFilter', 'Pospaid');
    input.put('startDateFilter','21/01/2018');
    input.put('endDateFilter','21/03/2018');
        input.put('facturaFilter','A');
        
        ConsumptionDetailsHandler consumption = new ConsumptionDetailsHandler();
        
        Test.startTest();
        consumption.invokeMethod(methodName, input, outMap, options);
    Test.stopTest();
    
    system.debug('outMap = '+outMap);
    
    List<Object> outputList = (List<Object>)outMap.get('Result');
    
    system.debug('outputList = '+outputList);
    
    if(outputList !=null){
          Map<String, String> t1 = (Map<String, String>)outputList.get(0);
          system.debug('t1 = '+t1);
          String t2 = t1.get('Family');
         system.assertEquals('Pospaid',t2);
    }    
 }  
}