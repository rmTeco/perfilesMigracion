@isTest
public class IFS_OrderSubmiterTest {

    @isTest static void testResponseStatus200 () {
        Test.startTest();
        List<Account> lstAcc = TestDataFactory.createAccounts(1, null);
        List<Order> lstOrders = TestDataFactory.createOrders(1, lstAcc[0]);
        insertJob(lstOrders[0].Id, lstAcc[0].Id);
        IFS_OrderSubmiter os = new IFS_OrderSubmiter();
        DataBase.executeBatch(os);
        Test.stopTest();    
    }    

    static void insertJob (Id pOrderId, Id pAccountId) {
        final String K_TIPO_JOB = 'Job Request';
        Crossobject__c co = new Crossobject__c();
        co.order__c = pOrderId;
        co.CrossObjectName__c = K_TIPO_JOB + ' ' + pOrderId;
        co.Status__c = 'Pendiente';
        co.DateTime1__c = DateTime.now();
        co.Account__c = pAccountId;
        co.String1__c = 'F&F - Canal: Externo - Orden Id: ' + pOrderId;
        co.RecordTypeId = Schema.SObjectType.Crossobject__c.getRecordTypeInfosByName().get('External Channel').getRecordTypeId();
        insert co;
    }

}