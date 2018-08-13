@isTest
public class IFS_OrdenSubmiterJobTest {

    @isTest static void testResponseStatus200 () {
        Test.startTest();
        IFS_OrdenSubmiterJob osj = new IFS_OrdenSubmiterJob(true);
        osj.execute(null);
        Test.stopTest();    
    }    

}