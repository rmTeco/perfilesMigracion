@IsTest
public class BillingGroupAnnulledCaseControllerTest {
	
    @IsTest
    public static void closeCaseTest(){
    
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Diagnosis').getRecordTypeId();
        
        Case testCase = new Case();
        testCase.Origin = 'Web';
        testCase.RecordTypeId = devRecordTypeId;
        
        insert testCase;
        
        Test.startTest();
        
        Boolean bgacc = BillingGroupAnnulledCaseController.closeCase(testCase.Id);
        
        Test.stopTest();
        
        System.assert(bgacc);
    }
    
    @IsTest
    public static void closeCaseTestFalse(){
        Test.startTest();
        
        Boolean bgacc = BillingGroupAnnulledCaseController.closeCase('906F0000000937iIAA');
        
        Test.stopTest();
        
        System.assert(!bgacc);
        
    }
    
    
}