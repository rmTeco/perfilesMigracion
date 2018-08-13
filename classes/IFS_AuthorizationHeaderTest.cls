@IsTest
public class IFS_AuthorizationHeaderTest {
    @IsTest public static void testGiveHeader(){
        Test.startTest();
        String authHeader = IFS_AuthorizationHeader.giveHeader();
        Test.stopTest();
        System.assertNotEquals('', authHeader);
    }
}