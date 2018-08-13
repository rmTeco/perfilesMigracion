@IsTest
public class ta_Techcare_OrderAcceptances_test {
    @IsTest static void invoke_getQueue(){
		Id techServiceRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Technical Service').getRecordTypeId();
        Case newCase = New Case();
        newCase.RecordTypeId = techServiceRecordTypeId;
        newCase.Type = 'Club Personal';
        newCase.Status = 'En espera del cliente';
        insert newCase;
        
        CaseHistory testHistory = New CaseHistory();
        testHistory.Field = 'Owner';
        testHistory.CaseId = newCase.Id;
        insert testHistory;
        
        String methodName = 'getQueue';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
		options.put('caseID',newCase.id);
        
        ta_Techcare_OrderAcceptances orderAccep = new ta_Techcare_OrderAcceptances();
        
		Test.startTest();
        orderAccep.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
    }

}