@isTest
public class CampaignTriggersTest {
    
    static testMethod void testUpdateCampaignMemberStatus() {
        
        MktgCloudAPISettings__c mktgCloudAPISettings = MarketingCloudAPIUtilTest.getMktgCloudAPISettings();
        insert mktgCloudAPISettings;
        
        SingleRequestMock fakeTokenResponse = MarketingCloudAPIUtilTest.accessTokenResponse();
        SingleRequestMock fakeCampaignResponse = MarketingCloudAPIUtilTest.mktgCloudCampaignResponse();
        
        List<Campaign> campaignList = new List<Campaign>();
        for(Integer i = 0; i < 50 ; i++) {
            Campaign cp = new Campaign(Name = 'Test Campaign ' + i, Type = 'Desarrollo',
                                       SubtypeL1__c = 'Fidelización', SubtypeL2__c = 'Club Personal', 
                                       Channel_Type__c  = 'OUT', Channel__c  = 'SMS', Destination__c = 'Masivo');
            campaignList.add(cp);
        }
        
        Map<String, SingleRequestMock> endpoint2TestResp = new Map<String,SingleRequestMock>();
        
        endpoint2TestResp.put('https://auth.exacttargetapis.com/v1/requestToken', fakeTokenResponse);
        endpoint2TestResp.put('https://www.exacttargetapis.com/hub/v1/campaigns', fakeCampaignResponse);
        
        HttpCalloutMock multiCalloutMock1 = new MktgCloudMultiCalloutMock(endpoint2TestResp);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MarketingCloudAPIUtilTest.MktgCloudCalloutMock());
        Test.setMock(HttpCalloutMock.class, multiCalloutMock1);
        insert campaignList;
        Test.stopTest();
    }
}