@IsTest
global with sharing class ta_sales_UserUtilsTest {
  @isTest static void getUserChannelTest(){
    String methodName = 'getUserChannel';

                Map<String, Object> input = new Map<String, Object>();
                Map<String, Object> outMap = new Map<String, Object>();
                Map<String, Object> options = new Map<String, Object>();
                Team_Member__c tm = TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);

                options.put('userId', userinfo.getUserId());

                Test.startTest();
                ta_sales_UserUtils testedClass = new ta_sales_UserUtils();
                testedClass.invokeMethod(methodName, input, outMap, options);
                Test.stopTest();

                Vlocity_cmt__BusinessSite__c stooreLoc = [SELECT Channel_Type__c, Channel__c FROM Vlocity_cmt__BusinessSite__c][0];
                //System.assertEquals(stooreLoc.Channel_Type__c, (String) outMap.get('UserChannel'));
                //System.assertEquals(stooreLoc.Channel__c, (String) outMap.get('UserChannelMode'));
  }

  @isTest static void getStoreLocationTest(){
    String methodName = 'getStoreLocation';

                Map<String, Object> input = new Map<String, Object>();
                Map<String, Object> outMap = new Map<String, Object>();
                Map<String, Object> options = new Map<String, Object>();

                Team_Member__c tm = TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);

                Test.startTest();
                ta_sales_UserUtils testedClass = new ta_sales_UserUtils();
                testedClass.invokeMethod(methodName, input, outMap, options);
                Test.stopTest();

                options.put('userId', userinfo.getUserId());
                System.assertEquals(tm.Work_Team__r.Work_Place__r.Id, (String) outMap.get('UserStoreLocation'));
  }

        @isTest static void checkUserHasCustomPermissionAccessTest(){
                String methodName = 'checkUserHasCustomPermissionAccess';

                Map<String, Object> input = new Map<String, Object>();
                Map<String, Object> outMap = new Map<String, Object>();
                Map<String, Object> options = new Map<String, Object>();

                Test.startTest();
                ta_sales_UserUtils testedClass = new ta_sales_UserUtils();
                options.put('userId', userinfo.getUserId());
                List < CustomPermission > permissionNames = [SELECT DeveloperName FROM CustomPermission];
                if (permissionNames.size() > 0){
                    options.put('customPermission', permissionNames[0].DeveloperName);
                    testedClass.invokeMethod(methodName, input, outMap, options);
                }

                Test.stopTest();


        }
}