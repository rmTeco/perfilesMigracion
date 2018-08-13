@isTest

public class EntitlementTriggerHandler_Test {

    @isTest static void assignEntitlementToTechServiceCase_Test (){
    
        Id businessRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        Account accountObj = new Account (
            Name='Account Test', 
            RecordTypeId = businessRecordTypeId
        );
        insert accountObj;
        
        Id techServiceRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Technical Service').getRecordTypeId();
        Case caseObj2 = New Case(
            Status = 'En espera del cliente',
            Origin = 'Personalizado',
            AccountId = accountObj.Id,
            RecordTypeId = techServiceRecordTypeId,
            Subject = 'Gestión de Servicio Técnico'
            );
        insert caseObj2;
        
        Test.startTest();
        Entitlement entitle = New Entitlement();
        entitle.Name = 'entitle test';
        entitle.AccountId = accountObj.id;
        
        insert entitle;
        Test.stopTest();
        
        Case cs = [SELECT id,status,AccountId,subject,EntitlementId FROM Case WHERE status = 'En espera del cliente' AND subject ='Gestión de Servicio Técnico'LIMIT 1];
        system.assertNotEquals(null, cs.EntitlementId);
    }
}