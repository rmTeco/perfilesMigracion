@isTest
public class IFS_OrderSubmiterTest {
    private static final String K_TIPO_JOB = 'Job Request';

    @isTest static void testResponseStatus200 () {
        Test.startTest();
        insertJob('8016C0000000e2EQAQ', '0016C000009KWawQAG');
        IFS_OrderSubmiter os = new IFS_OrderSubmiter();
        DataBase.executeBatch(os);
        Test.stopTest();    
    }    


    private static void insertJob (Id pOrderId, Id pAccountId) {
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