@isTest

public class EntitlementManagerTest {
	
    @isTest static void CreateEntitlementAndGetExistentEntitlementMap_Test (){
    	
    Id businessRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        Account accountObj = new Account (
            Name='Account Test', 
            RecordTypeId = businessRecordTypeId
        );
        insert accountObj;  
        
        List<Order> testOrder = TestDataFactory.createOrders(1,accountObj);
        testOrder[0].OrderApprovalStatus__c = 'Pendiente de aprobación';
        update testOrder;
        
        Id techServiceRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Technical Service').getRecordTypeId();
        Case caseObj2 = New Case(
            Origin = 'Personalizado',
            AccountId = accountObj.Id,
            RecordTypeId = techServiceRecordTypeId,
            Subject = 'Gestión de Servicio Técnico',
            Order__c = testOrder[0].Id
            );
        insert caseObj2;
        
        Test.startTest();
        caseObj2.Status = 'En espera del cliente';
        Update caseObj2;            
        Test.stopTest();
        Case finalCase = [SELECT Id,AccountId,EntitlementId FROM Case WHERE AccountId =: accountObj.Id LIMIT 1];
        system.AssertNotEquals(null,finalCase.EntitlementId);
        
    }
    
}