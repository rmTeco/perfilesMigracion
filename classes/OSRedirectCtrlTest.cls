@isTest
private class OSRedirectCtrlTest {
  
      static testMethod void returnURL() {
      test.startTest();
      vlocity_cmt__OmniScriptInstance__c OS = new vlocity_cmt__OmniScriptInstance__c();
      insert OS;
      System.currentPageReference().getParameters().put('sInstanceId', OS.id);
      OSRedirectCtrl OSRedrirect = new OSRedirectCtrl();
      OSRedrirect.returnURL();
      test.stopTest();
}

}