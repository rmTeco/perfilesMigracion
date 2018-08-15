@isTest
public class MktgMCSyncTest {
    static testMethod void testSincronizeCampaignWithMC () {
        SingleRequestMock fakeTokenResponse = MarketingCloudAPIUtilTest.accessTokenResponse();
        SingleRequestMock fakeCampaignResponse = MarketingCloudAPIUtilTest.mktgCloudCampaignResponse();
        
        MarketingCloudAPIUtil.skipAPICall = true;

        //List<Campaign> campaignList = TestDataFactory.createCampaigns(1);
        List<Campaign> campaignList = new List<Campaign>();
        for(Integer i = 0; i < 50 ; i++) {
            Campaign cp = new Campaign(Name = 'Test Campaign ' + i, Campaign_Type__c = 'Desarrollo',
                                       Campaign_Subtype__c = 'Fidelización', Campaign_Subtype_2__c = 'Club Personal', 
                                       Channel_Type__c  = 'OUT', Channel__c  = 'SMS', Campaign_Destiny__c = 'Masivo', Type = 'Desarrollo',
                                       Destination__c = 'Masivo',SubtypeL1__c = 'Activ. Comercial', SubtypeL2__c = 'Cambio de Terminal');
            campaignList.add(cp);
        }
       

        Map<String, SingleRequestMock> endpoint2TestResp = new Map<String,SingleRequestMock>();
        
        endpoint2TestResp.put('https://auth.exacttargetapis.com/v1/requestToken', fakeTokenResponse);
        endpoint2TestResp.put('https://www.exacttargetapis.com/hub/v1/campaigns', fakeCampaignResponse);

        HttpCalloutMock multiCalloutMock = new MktgCloudMultiCalloutMock(endpoint2TestResp);
        
        MktgCloudAPISettings__c mktgCloudAPISettings = MarketingCloudAPIUtilTest.getMktgCloudAPISettings();
        mktgCloudAPISettings.TokenDuration__c = 3400;
        mktgCloudAPISettings.TokenCreationDate__c = Datetime.now();
        mktgCloudAPISettings.MCAPIAccessToken__c = '12345';
        insert mktgCloudAPISettings;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        insert campaignList;
            
        Test.stopTest();
    }
}