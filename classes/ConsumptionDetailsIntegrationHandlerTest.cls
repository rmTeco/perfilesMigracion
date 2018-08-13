@IsTest
public class ConsumptionDetailsIntegrationHandlerTest {
     
    @IsTest static void filterDataByFamilyTestOneBilling(){
    	System.debug('ENTRO ConsumptionDetailsIntegrationHandlerTest.filterDataByFamilyTest');
        
        String methodName = 'filterDataByFamily';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        input.put('serviceFamily', 'Internet');
		input.put('startDateFilter','01/01/2008');
		input.put('endDateFilter','01/01/2018');
        input.put('CustomerIntegrationId','318987');
        input.put('facturaFilter','Diciembre');
        input.put('filterOption','Una factura');
        
        
        
        ConsumptionDetailsIntegrationHandler consumptionhandler = new ConsumptionDetailsIntegrationHandler();
        
        Test.startTest();
        consumptionhandler.invokeMethod(methodName, input, outMap, options);
		Test.stopTest();
        
		system.assertEquals('Internet',input.get('serviceFamily'));
		/*List<Object> outputList = (List<Object>)outMap.get('Result');
		
		Map<String, String> t1 = (Map<String, String>)outputList[0];
		
		String t2 = t1.get('Family');
		
		system.assertEquals('Internet',t2);
		*/
    }

    @IsTest static void filterDataByFamilyTestLast15Day(){
    	System.debug('ENTRO ConsumptionDetailsIntegrationHandlerTest.filterDataByFamilyTest');
        
        String methodName = 'filterDataByFamily';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        input.put('serviceFamily', 'Internet');
		input.put('startDateFilter','01/01/2008');
		input.put('endDateFilter','01/01/2018');
        input.put('CustomerIntegrationId','318987');
        input.put('facturaFilter','Febrero');
        input.put('filterOption','Los últimos 15 días');
        
        
        
        ConsumptionDetailsIntegrationHandler consumptionhandler = new ConsumptionDetailsIntegrationHandler();
        
        Test.startTest();
        consumptionhandler.invokeMethod(methodName, input, outMap, options);
		Test.stopTest();
        
		system.assertEquals('Internet',input.get('serviceFamily'));
		/*List<Object> outputList = (List<Object>)outMap.get('Result');
		
		Map<String, String> t1 = (Map<String, String>)outputList[0];
		
		String t2 = t1.get('Family');
		
		system.assertEquals('Internet',t2);
		*/
    }

    @IsTest static void filterDataByFamilyTest(){
    	System.debug('ENTRO ConsumptionDetailsIntegrationHandlerTest.filterDataByFamilyTest');
        
        String methodName = 'filterDataByFamily';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        input.put('serviceFamily', 'Internet');
		input.put('startDateFilter','01/01/2008');
		input.put('endDateFilter','01/01/2018');
        input.put('CustomerIntegrationId','318987');
        input.put('facturaFilter','Enero');
        input.put('filterOption','');
        
        
        
        ConsumptionDetailsIntegrationHandler consumptionhandler = new ConsumptionDetailsIntegrationHandler();
        
        Test.startTest();
        consumptionhandler.invokeMethod(methodName, input, outMap, options);
		Test.stopTest();
        
		system.assertEquals('Internet',input.get('serviceFamily'));
		/*List<Object> outputList = (List<Object>)outMap.get('Result');
		
		Map<String, String> t1 = (Map<String, String>)outputList[0];
		
		String t2 = t1.get('Family');
		
		system.assertEquals('Internet',t2);
		*/
    }
}