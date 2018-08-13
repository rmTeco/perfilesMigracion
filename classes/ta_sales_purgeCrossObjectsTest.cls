@isTest
public class ta_sales_purgeCrossObjectsTest {

    @isTest static void ta_sales_purgeCrossObjectsTest() {
        //GIVEN
        ta_sales_purgeCrossObjects schedule = new ta_sales_purgeCrossObjects();

        //WHEN
        Test.startTest();
        system.schedule('ta_sales_purgeCrossObjects ' + System.Now(), '0 0 * 1 * ? *', schedule);
        Test.stopTest();

        //THEN
        System.assert(true);

    }

    @isTest static void test1()
    {
      list<SObject> lstObject = new list<SObject>();
      Test.startTest();
        Database.BatchableContext bc;
          ta_sales_purgeCrossObjects taSalesNotifyTesT = new ta_sales_purgeCrossObjects();
        String sch = '0 0 23 * * ?';
        System.schedule('Test Territory Check', sch, taSalesNotifyTesT);
        taSalesNotifyTesT.execute(bc,lstObject);
      test.stopTest();
    }
}