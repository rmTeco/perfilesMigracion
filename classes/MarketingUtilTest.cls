@isTest
private class MarketingUtilTest {
  
  
  @isTest static void obtainPicklistValues_Test(){
    List<String> pickValues;
    //WHEN
        Test.startTest();
        pickValues = MarketingUtil.obtainPicklistValues('Account', 'Type');
        Test.stopTest();
        
    //THEN
        System.assertEquals(true, pickValues.contains('Partner'));
  }
  
}