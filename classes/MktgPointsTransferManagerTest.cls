@isTest (seeAllData = false)
public with sharing class MktgPointsTransferManagerTest {
    static testmethod void invoquedMethodTest(){
        Test.startTest();
        MktgPointsTransferManager ms = new MktgPointsTransferManager();
        ms.invokeMethod('getPointsCP', null, null, null);
        Test.stopTest();
    }

	static testMethod void testGetPointsCP () {
        Map<String,Object> inputMap1 = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        
        Id consumerRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Consumer' AND SobjectType = 'Account' LIMIT 1].Id;
       
        Account aConsumer = new Account(Name = 'TestMSConsumer', RecordTypeId = consumerRecordTypeId);
        insert aConsumer;

        inputMap1.put('ContextId', aConsumer.id);

        Test.startTest();
        MktgPointsTransferManager ms = new MktgPointsTransferManager();
        ms.invokeMethod('getPointsCP', inputMap1, outMap, null);
        Test.stopTest();
	}

	static testMethod void testTransferPoints () {
        Map<String,Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> transferenciadePuntos = new Map<String, Object>();
        List<Object> selectableAccounts = new List<Object>();
        List<Object> destinationAccounts = new List<Object>();
        Map<String, Object> selectedAccount = new Map<String, Object>();
        Map<String, Object> destinationAccount = new Map<String, Object>();

        List<Account> consumerAccounts = TestDataFactory.createAccounts(1, 'Consumer');
        List<Account> serviceAccounts = TestDataFactory.createAccounts(1, 'Service');

        system.debug('consumerAccounts ' + consumerAccounts);
        system.debug('serviceAccounts ' + serviceAccounts);

        inputMap.put('ContextId', String.valueOf(consumerAccounts.get(0).id));

        transferenciadePuntos.put('PuntosTransferir', 100);
        
        selectedAccount.put('idCuenta', String.valueOf(consumerAccounts.get(0).id));
        destinationAccount.put('idCuenta', String.valueOf(serviceAccounts.get(0).id));

        selectableAccounts.add(selectedAccount);
        destinationAccounts.add(destinationAccount);
        
        transferenciadePuntos.put('SelectableServiceAccounts', selectableAccounts);
        transferenciadePuntos.put('DestinationServiceAccounts', destinationAccounts);       
        
        inputMap.put('TransferenciadePuntos', transferenciadePuntos);
        
        system.debug('inputMap ' + inputMap);
        Test.startTest();
        MktgPointsTransferManager ms = new MktgPointsTransferManager();
        ms.invokeMethod('transferPoints', inputMap, outMap, null);
        Test.stopTest();
	}
}