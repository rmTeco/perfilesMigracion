@IsTest
public class RefillsHistorySOSHandlerTest {
    @IsTest static void invoke_getDummyData(){
        String methodName = 'getDummyData';
        
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        input.put('startDateFilter','2018/11/21');
        input.put('endDateFilter','2018/13/21');
        
        RefillsHistorySOSHandler refillsHistorySOS = new RefillsHistorySOSHandler();
        
        Test.startTest();
        refillsHistorySOS.invokeMethod(methodName, input, outMap, options);
    Test.stopTest();
        
        system.debug('outMap.get(Result) = '+outMap.get('Result'));
        Map<String, Object> resultList = (Map<String, Object>)outMap.get('Result');
        List<Object> RefillsSOSList = (List<Object>)resultList.get('RefillsSOSList');
        
        system.debug('String.valueOf((system.now()).format()) = '+String.valueOf((system.now()).format()));
        system.debug('RefillsSOSList = '+RefillsSOSList);
        
        system.assertEquals(String.valueOf((system.now()).format()),((Map<String, Object>)RefillsSOSList[0]).get('Fecha'));
    
    }
}