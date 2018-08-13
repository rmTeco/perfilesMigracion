@IsTest
public class ConnectedAppPluginExampleTest {

    @isTest
    public static void customAttributesTest(){
        Map<String,String> mapstr = new Map<String,String>();
        Test.startTest();
        ConnectedAppPluginExample cap = new ConnectedAppPluginExample();
        Map<String,String> respMapStr = cap.customAttributes(UserInfo.getUserId(),mapstr);
        Test.stopTest();
        
        Map<String,String> mapstrempty = new Map<String,String>();
        System.assertNotEquals(respMapStr,mapstrempty);
        
    }
}