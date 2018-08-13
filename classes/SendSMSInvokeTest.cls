@isTest
public class SendSMSInvokeTest {

    static testMethod void sendSmsIntegrationTest() {
        //GIVE
        String methodName = 'sendSmsIntegration';
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        
        String jsonString = '{"params": {"nroLinea": "AssetsConsultados.MSISDN__c" },"body": {"bodyFullCodeName": "string", "TestStress - SMS": "string","channelName": "SMS","communicationDate": "2017-05-04T02:29:43", "communicationText": "string","messageReference": "string","target": {"rawdata": [{"key": "string","value": "string"}],"user": {"customerNumber": 0,"lastName": "string","mail": "string","name": "string"}}}}';
		inputMap = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
		
		SendSMSInvoke objIntegration = new SendSMSInvoke();
	
        //WHEN
        objIntegration.invokeMethod(methodName, inputMap, outMap, options);
        
        //THEN
        System.assert(true);
        
    }
}