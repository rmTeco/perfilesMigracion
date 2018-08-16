@isTest
private class NominationPDFDownloadTest {
  
      
      
      static testMethod void DownloadPDF() {
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, String>();
        List<Account>  Acc = TestDataFactory.createAccounts(1,'Consumer');
        Map<string,object>AccMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(Acc[0]));
        inputMap.put('Account',AccMap ) ;  
        Map<string,object>ConMap = new Map<String, Object>();
        ConMap.put('DocumentType','PAS');
        inputMap.put('Contact',ConMap ) ; 
         Test.startTest();     
        NominationPDFDownload NPD = new NominationPDFDownload();
        NPD.invokeMethod('getPdf',inputMap,outMap,options);
        ConMap.clear();
        ConMap.put('DocumentType','CUIL');
        inputMap.put('Contact',ConMap ) ;      
        NPD.invokeMethod('getPdf',inputMap,outMap,options);                                              
        Test.stopTest();
      }
      
  }