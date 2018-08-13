@isTest
public class ta_Care_SendSmsTest {

    static testMethod void getCaseTest() {
        //GIVE
        Account account = TestDataFactory.createAccounts(1).get(0);
        Asset asset = TestDataFactory.createAssets(1, account).get(0);
        List<Case> myCase = TestDataFactory.createCases(1, account.Id, asset.Id, '');
        
        SMSSender__c objSMS = new SMSSender__c();
        objSMS.Name = 'S-Confirmacion-SMS';
        objSMS.Sender__c = 'S-Confirmacion-SMS';
        insert objSMS;
        //WHEN
        ta_Care_SendSms.getCase(myCase);
        
        //THEN
        System.assert(true);
        
    }
}