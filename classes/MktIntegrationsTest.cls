@isTest (seeAllData = false)
public with sharing class MktIntegrationsTest {
    static testmethod void invoquedMethodTest(){
        Test.startTest();
        MktIntegrations ms = new MktIntegrations();
        ms.invokeMethod('NotExistantMethod', null, null, null);
        Test.stopTest();
    }
    
    static testmethod void UpdateCPStatusHuaweiTest(){
        Map<String,Object> inputMap1 = new Map<String, Object>();
        Map<String,Object> inputMap2 = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> obj = new Map<String, Object>();
        
        Map<String, Map<String, Object>> CP = new Map<String, Map<String, Object>>();
        
        Map<String, Object> CPaccounts = new Map<String, String>();
        
        Id consumerRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Consumer' AND SobjectType = 'Account' LIMIT 1].Id;
        Id billingRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Business' AND SobjectType = 'Account' LIMIT 1].Id;
       
        Account aConsumer = new Account(Name = 'TestMSConsumer', RecordTypeId = consumerRecordTypeId);
        insert aConsumer;
        
        Account aBusiness = new Account(Name = 'TestMSBilling', RecordTypeId = billingRecordTypeId);
        insert aBusiness;   

        /*String asset1 = '{"Name":"Asset1", "Tipo_de_Producto__c": "Simcard","MSISDN__c": "1122334455", "AccountId": "'+String.valueOf(aConsumer.Id)+'"}';
        Asset record1 = (Asset)JSON.deserialize(asset1, Asset.class);

        String asset2 = '{"Name":"Asset2", "Tipo_de_Producto__c": "Simcard", "MSISDN__c": "1122332455", "AccountId": "'+String.valueOf(aBusiness.Id)+'"}';
        Asset record2 = (Asset)JSON.deserialize(asset2, Asset.class);

        insert record1;
        insert record2;*/
        
        Product2 prod = new Product2(Name ='prod', vlocity_cmt__Type__c = 'Simcard');
        insert prod;
        
        Asset asst1 = new Asset(Name = 'Asset', AccountId = aConsumer.Id, Product2Id = prod.Id);
        insert asst1;
        
        Asset asst2 = new Asset(Name = 'Asset', AccountId = aBusiness.Id, Product2Id = prod.Id);
        insert asst2;
        
        CPaccounts.put('consumerAccounts', (Object)'({AccountNumber=10, ClubMember=false, Id='+String.valueOf(aConsumer.Id)+', Name='+aConsumer.Name+', vlcSelected=true})');
        CPaccounts.put('businessAccounts', (Object)'({AccountNumber=11, ClubMember=false, Id='+String.valueOf(aBusiness.Id)+', Name='+aBusiness.Name+', vlcSelected=true})');
 
        Case testCase = new Case(Type = 'Club Personal', Description = 'Unit Test');
        insert testCase;

        inputMap1.put('DRId_Case', testCase.Id);
        inputMap1.put('Case:Type', testCase.Type);
        inputMap1.put('Case:Description', 'ALTA');
        inputMap1.put('AltaClubPersonal', CPaccounts);
        
        inputMap2.put('DRId_Case', testCase.Id);
        inputMap2.put('Case:Type', testCase.Type);
        inputMap2.put('Case:Description', 'BAJA');
        inputMap2.put('CPMembershipCancellation',CPaccounts);

        Test.startTest();
        MktIntegrations ms = new MktIntegrations();
        ms.invokeMethod('UpdateCPStatusHuawei', inputMap1, outMap, null);
        ms.invokeMethod('UpdateCPStatusHuawei', inputMap2, outMap, null);
        Test.stopTest();
    }

    @isTest
    static void Generate_RequestS372Test() {
        MktIntegrations mkt = new MktIntegrations();
        mkt.Generate_RequestS372('','');
    }
}