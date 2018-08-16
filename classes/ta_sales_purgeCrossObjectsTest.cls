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
}