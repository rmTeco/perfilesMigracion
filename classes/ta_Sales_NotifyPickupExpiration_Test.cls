@isTest
public class ta_Sales_NotifyPickupExpiration_Test {

    static testmethod void test() {
                TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
                RecordType objRecordType = [SELECT DeveloperName,Id FROM RecordType WHERE DeveloperName = 'SMSTemplate'];
              Date newDate = Date.today();

                Account acc = [SELECT Id FROM Account LIMIT 1];
                List<Order> ords = TestDataFactory.createOrders(3, acc);

                for(Order ordTes : ords){
                    ordTes.vlocity_cmt__ExpirationDate__c = Date.newInstance(2018, 03, 03);
                }
              update ords;
              System.debug('All orders here -'+ ords);

              PlazoEsperaPickup__c plazo = new PlazoEsperaPickup__c();
              plazo.Name = 'TestP';
              plazo.DiasDeEspera__c = 1;
              insert plazo;

              System.debug('Here Plazo'+ plazo);

                Crossobject__c crossObjectTest = new Crossobject__c(
                    PickList1__c = 'Vencimiento de Pickup',
                    DateTime1__c = newDate,
                    Account__c = acc.Id,
                    Checkbox1__c = true,
                    RecordTypeId = objRecordType.Id,
                    Order__c = ords.get(0).Id
                );
                insert crossObjectTest;

                Test.startTest();

                ta_Sales_NotifyPickupExpiration taSalesNotifyTesT = new ta_Sales_NotifyPickupExpiration();
                String sch = '0 0 23 * * ?';
                System.schedule('TestSales Notify Pickup', sch, taSalesNotifyTesT);

                Test.stopTest();
                //System.debug('Here code new'+ taSalesChecTest)
               // System.assertEquals(3, [select count() from Order where Delivery_Method__c = 'Retiro']);
        }

        static testmethod void test1()
        {
          Account acc = TestDataFactory.createAccounts(1,'Consumer')[0];
          TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
          TestDataFactory.PlazoEsperaPickup(2,'Prubas sales plazos');

          Order ord = TestDataFactory.createOrders(1, acc)[0];
          ord.vlocity_cmt__ExpirationDate__c = Date.today()+2;
          update ord;
          list<Order> lstObject = new list<Order>();

          lstObject.add(ord);
          CrossObject__c objCrossObject = TestDataFactory.CrossObject(lstObject[0].Id,'Order');
          objCrossObject.Picklist1__c = 'Vencimiento de Pickup';
          update objCrossObject;
          Test.startTest();
            Database.BatchableContext bc;
              ta_Sales_NotifyPickupExpiration taSalesNotifyTesT = new ta_Sales_NotifyPickupExpiration();
            String sch = '0 0 23 * * ?';
            System.schedule('Test Territory Check', sch, taSalesNotifyTesT);
            taSalesNotifyTesT.execute(bc,lstObject);
          test.stopTest();
        }
        static testmethod void test2()
        {
          Account acc = TestDataFactory.createAccounts(1,'Consumer')[0];
          TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
          TestDataFactory.PlazoEsperaPickup(2,'Prubas sales plazos');

          Order ord = TestDataFactory.createOrders(1, acc)[0];
          list<Order> lstObject = new list<Order>();
          lstObject.add(ord);
          CrossObject__c objCrossObject = TestDataFactory.CrossObject(lstObject[0].Id,'Order');
          objCrossObject.Picklist1__c = 'Vencimiento de Pickup';
          update objCrossObject;
          Test.startTest();
            Database.BatchableContext bc;
              ta_Sales_NotifyPickupExpiration taSalesNotifyTesT = new ta_Sales_NotifyPickupExpiration();
            String sch = '0 0 23 * * ?';
            System.schedule('Test Territory Check', sch, taSalesNotifyTesT);
            taSalesNotifyTesT.execute(bc,lstObject);
          test.stopTest();
        }
}