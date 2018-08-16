@IsTest
public class RefillHistoryHandler_test {
	@IsTest static void invoke_filterDataByChannel_ROL(){
        String methodName = 'filterDataByChannel';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
		
        RefillHistoryHandler refil = new RefillHistoryHandler();
        String stringDateStart = string.valueOfGmt((system.today()-2));
        String stringDateEnd = string.valueOfGmt((system.today()+2));
        input.put('startDateFilter',stringDateStart);
        input.put('endDateFilter',stringDateEnd);
        input.put('channelFilter','ROL');
        input.put('benefitFilter','Con Beneficio');
        
    	Test.startTest();
        refil.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        system.assertNotEquals(null,outMap.get('Result'));
    }
    
    @IsTest static void invoke_filterDataByChannel_Web(){
    	String methodName = 'filterDataByChannel';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
		
        RefillHistoryHandler refil = new RefillHistoryHandler();
        String stringDateStart = string.valueOfGmt((system.today()-2));
        String stringDateEnd = string.valueOfGmt((system.today()+2));
        input.put('startDateFilter',stringDateStart);
        input.put('endDateFilter',stringDateEnd);
        input.put('channelFilter','Web');
        input.put('benefitFilter','Con Beneficio');
        
    	Test.startTest();
        refil.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        system.assertNotEquals(null,outMap.get('Result'));
    }
    
    @IsTest static void invoke_filterDataByChannel_SMS(){
    	String methodName = 'filterDataByChannel';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
		
        RefillHistoryHandler refil = new RefillHistoryHandler();
        String stringDateStart = string.valueOfGmt((system.today()-2));
        String stringDateEnd = string.valueOfGmt((system.today()+2));
        input.put('startDateFilter',stringDateStart);
        input.put('endDateFilter',stringDateEnd);
        input.put('channelFilter','SMS');
        input.put('benefitFilter','Con Beneficio');
        
    	Test.startTest();
        refil.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        system.assertNotEquals(null,outMap.get('Result'));   
    }
    
    @IsTest static void invoke_filterDataByChannel_IVR(){
    	String methodName = 'filterDataByChannel';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
		
        RefillHistoryHandler refil = new RefillHistoryHandler();
        String stringDateStart = string.valueOfGmt((system.today()-2));
        String stringDateEnd = string.valueOfGmt((system.today()+2));
        input.put('startDateFilter',stringDateStart);
        input.put('endDateFilter',stringDateEnd);
        input.put('channelFilter','IVR');
        input.put('benefitFilter','Con Beneficio');
        
    	Test.startTest();
        refil.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        system.assertNotEquals(null,outMap.get('Result'));   
    }
    
    @IsTest static void invoke_filterDataByChannel_OTHER(){
    	String methodName = 'filterDataByChannel';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
		
        RefillHistoryHandler refil = new RefillHistoryHandler();
        String stringDateStart = string.valueOfGmt((system.today()-2));
        String stringDateEnd = string.valueOfGmt((system.today()+2));
        input.put('startDateFilter',stringDateStart);
        input.put('endDateFilter',stringDateEnd);
        input.put('channelFilter','OTHER');
        input.put('benefitFilter','Con Beneficio');
        
    	Test.startTest();
        refil.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        system.assertNotEquals(null,outMap.get('Result'));   
    }
    
    @IsTest static void invoke_filterDataByChannel_ROL_EmptyDate(){
        String methodName = 'filterDataByChannel';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
		
        RefillHistoryHandler refil = new RefillHistoryHandler();
        String stringDateStart = string.valueOfGmt((system.today()-2));
        input.put('startDateFilter',stringDateStart);
        input.put('channelFilter','ROL');
        input.put('benefitFilter','Con Beneficio');
        
    	Test.startTest();
        refil.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        system.assertNotEquals(null,outMap.get('Result'));
    }
    
    @IsTest static void invoke_filterDataByChannel_ROL_EmptyBenefit(){
        String methodName = 'filterDataByChannel';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
		
        RefillHistoryHandler refil = new RefillHistoryHandler();
        String stringDateStart = string.valueOfGmt((system.today()-2));
        input.put('startDateFilter',stringDateStart);
        input.put('channelFilter','ROL');
        //input.put('benefitFilter','Con Beneficio');
        
    	Test.startTest();
        refil.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        system.assertNotEquals(null,outMap.get('Result'));
    }
    
    @IsTest static void invoke_filterDataByChannel_ROL_BenefitTest(){
        String methodName = 'filterDataByChannel';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
		
        RefillHistoryHandler refil = new RefillHistoryHandler();
        String stringDateStart = string.valueOfGmt((system.today()-2));
        String stringDateEnd = string.valueOfGmt((system.today()+2));
        input.put('startDateFilter',stringDateStart);
        input.put('endDateFilter',stringDateEnd);
        input.put('channelFilter','ROL');
        input.put('benefitFilter','Test');
        
    	Test.startTest();
        refil.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        system.assertNotEquals(null,outMap.get('Result'));
    }
    
    @IsTest static void invoke_filterDataByChannel_ROL_BenefitTest_EmptyDate(){
        String methodName = 'filterDataByChannel';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
		
        RefillHistoryHandler refil = new RefillHistoryHandler();
        String stringDateStart = string.valueOfGmt((system.today()-2));
        input.put('startDateFilter',stringDateStart);
        input.put('channelFilter','ROL');
        input.put('benefitFilter','Test');
        
    	Test.startTest();
        refil.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        system.assertNotEquals(null,outMap.get('Result'));
    }
    
    @IsTest static void invoke_filterDataByChannel_Web_BenefitTest(){
    	String methodName = 'filterDataByChannel';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
		
        RefillHistoryHandler refil = new RefillHistoryHandler();
        String stringDateStart = string.valueOfGmt((system.today()-2));
        String stringDateEnd = string.valueOfGmt((system.today()+2));
        input.put('startDateFilter',stringDateStart);
        input.put('endDateFilter',stringDateEnd);
        input.put('channelFilter','Web');
        input.put('benefitFilter','Test');
        
    	Test.startTest();
        refil.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        system.assertNotEquals(null,outMap.get('Result'));
    }
    
    @IsTest static void invoke_filterDataByChannel_SMS_BenefitTest(){
    	String methodName = 'filterDataByChannel';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
		
        RefillHistoryHandler refil = new RefillHistoryHandler();
        String stringDateStart = string.valueOfGmt((system.today()-2));
        String stringDateEnd = string.valueOfGmt((system.today()+2));
        input.put('startDateFilter',stringDateStart);
        input.put('endDateFilter',stringDateEnd);
        input.put('channelFilter','SMS');
        input.put('benefitFilter','Test');
        
    	Test.startTest();
        refil.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        system.assertNotEquals(null,outMap.get('Result'));   
    }
    
    @IsTest static void invoke_filterDataByChannel_IVR_BenefitTest(){
    	String methodName = 'filterDataByChannel';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
		
        RefillHistoryHandler refil = new RefillHistoryHandler();
        String stringDateStart = string.valueOfGmt((system.today()-2));
        String stringDateEnd = string.valueOfGmt((system.today()+2));
        input.put('startDateFilter',stringDateStart);
        input.put('endDateFilter',stringDateEnd);
        input.put('channelFilter','IVR');
        input.put('benefitFilter','Test');
        
    	Test.startTest();
        refil.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        system.assertNotEquals(null,outMap.get('Result'));   
    }
    @IsTest static void invoke_filterDataByChannel_OTHER_BenefitTest(){
    	String methodName = 'filterDataByChannel';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
		
        RefillHistoryHandler refil = new RefillHistoryHandler();
        String stringDateStart = string.valueOfGmt((system.today()-2));
        String stringDateEnd = string.valueOfGmt((system.today()+2));
        input.put('startDateFilter',stringDateStart);
        input.put('endDateFilter',stringDateEnd);
        input.put('channelFilter','OTHER');
        input.put('benefitFilter','Test');
        
    	Test.startTest();
        refil.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        system.assertNotEquals(null,outMap.get('Result'));   
    }
}