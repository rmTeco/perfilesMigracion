@isTest
public class ta_sales_CheckPickupTime_Test {

    static testmethod void test() {
        Account acc = TestDataFactory.createAccounts(1,'Consumer')[0];
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        Order ord = TestDataFactory.createOrders(1, acc)[0];

        Test.startTest();

        ta_sales_CheckPickupTime taSalesChecTesT = new ta_sales_CheckPickupTime();
        String sch = '0 0 23 * * ?';
        System.schedule('Test Territory Check', sch, taSalesChecTest);

        Test.stopTest();
    System.debug('Here code new'+ taSalesChecTest);
        // after the testing stops, assert records were updated properly
        //System.assertEquals(10, [select count() from contact where MailingCity = 'New York']);
    }

    static testmethod void test1()
    {
      Account acc = TestDataFactory.createAccounts(1,'Consumer')[0];
      TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
      Order ord = TestDataFactory.createOrders(1, acc)[0];
      list<Order> lstObject = new list<Order>();
      lstObject.add(ord);
      Test.startTest();
        Database.BatchableContext bc;
        ta_sales_CheckPickupTime taSalesChecTesT = new ta_sales_CheckPickupTime();
        String sch = '0 0 23 * * ?';
        System.schedule('Test Territory Check', sch, taSalesChecTest);
        taSalesChecTesT.execute(bc,lstObject);
      test.stopTest();
    }


}