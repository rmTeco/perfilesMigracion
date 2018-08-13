@isTest (seeAllData = false)
public with sharing class MktgMCCampaignUpdateTest {
    static testMethod void testSincronizeCampaignWithMC () {
        SingleRequestMock fakeTokenResponse = MarketingCloudAPIUtilTest.accessTokenResponse();
        SingleRequestMock fakeCampaignResponse = MarketingCloudAPIUtilTest.mktgCloudCampaignResponse();
        
        MarketingCloudAPIUtil.skipAPICall = true;
        
        MktgCloudAPISettings__c mktgCloudAPISettings = MarketingCloudAPIUtilTest.getMktgCloudAPISettings();
        mktgCloudAPISettings.TokenDuration__c = 3400;
        mktgCloudAPISettings.TokenCreationDate__c = Datetime.now();
        mktgCloudAPISettings.MCAPIAccessToken__c = '12345';
        
        insert mktgCloudAPISettings;

        List<Campaign> campaignList = TestDataFactory.createCampaigns(1);
        
        Map<String, SingleRequestMock> endpoint2TestResp = new Map<String,SingleRequestMock>();
        
        endpoint2TestResp.put('https://auth.exacttargetapis.com/v1/requestToken', fakeTokenResponse);
        endpoint2TestResp.put('https://www.exacttargetapis.com/hub/v1/campaigns/123', fakeCampaignResponse);

        HttpCalloutMock multiCalloutMock = new MktgCloudMultiCalloutMock(endpoint2TestResp);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        campaignList.get(0).MarketingCloudCampaignId__c = '123';
        
        MktgMCCampaignUpdate.updateCampaignWithMC(campaignList);

        Test.stopTest();
    }
}