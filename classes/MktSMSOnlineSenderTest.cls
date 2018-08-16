@isTest
public class MktSMSOnlineSenderTest{

    static testMethod void testSend(){ 
        
        MarketingCloudAPIUtil.skipAPICall = true;

        MktgCloudAPISettings__c mktgCloudAPISettings = MarketingCloudAPIUtilTest.getMktgCloudAPISettings();
        mktgCloudAPISettings.TokenDuration__c = 3400;
        mktgCloudAPISettings.TokenCreationDate__c = Datetime.now();
        mktgCloudAPISettings.MCAPIAccessToken__c = '12345';
        insert mktgCloudAPISettings;

        Id crossObjectRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'SMSAdministrator' AND SobjectType = 'Crossobject__c' LIMIT 1].Id;
        List<Campaign> campaignList = TestDataFactory.createCampaigns(1);
        //insert campaignList;

        List<CrossObject__c> coList = new List<CrossObject__c>();
        CrossObject__c message = new CrossObject__c(RecordTypeId = crossObjectRecordTypeId,
                                                 TextArea__c = 'Mensaje de test');
        coList.add(message);
        insert coList;
            
        Contact contact1 = new Contact(LastName='Contact1');
        Database.Insert(contact1);

        Id campId = campaignList.get(0).Id;
        List<CampaignMember> cmList = new List<CampaignMember>();
        CampaignMember cm = new CampaignMember(CampaignId = campId,
                                               ContactId  = contact1.Id,
                                               MessageId__c   = message.Id,
                                               IsSMSOnline__c = true);
        cmList.add(cm);
        //insert cmList;

        Test.startTest();
        MktSMSOnlineSender.sendSMSOnline(cmList);   
        Test.stopTest();
    }
}