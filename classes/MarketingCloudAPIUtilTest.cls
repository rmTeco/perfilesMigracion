@isTest
public class MarketingCloudAPIUtilTest {
    
    static testMethod void testGetMCAccessToken () {
        
        MktgCloudAPISettings__c mktgCloudAPISettings = getMktgCloudAPISettings();
        insert mktgCloudAPISettings;
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new MktgCloudCalloutMock()); 
        
        String token = MarketingCloudAPIUtil.getMCAccessToken();
        
        System.assertEquals(token, '1234567');
        
        Test.stopTest();
    }
    
    static testMethod void testCreateCampaign () {
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new MktgCloudCalloutCreateCampaignMock()); 
        
        System.assertEquals(MarketingCloudAPIUtil.createCampaign('1234', createCampaignWrapper()), '1234');
    }
 
    static testMethod void testUpdateCampaign () {
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new MktgCloudCalloutCreateCampaignMock()); 
        
        MarketingCloudAPIUtil.updateCampaign('1234', createCampaignWrapper(), '20');
        List<Campaign> campaigns = new List<Campaign>();
        Campaign campaign = new Campaign(Name='TestC', Description='TestD');
        campaigns.add(campaign);
        MarketingCloudAPIUtil.serializeCampaigns(campaigns);
        
        TriggeredSendNotificationSettings__c tsns = new TriggeredSendNotificationSettings__c();
        tsns.Name='TestCNS';
        tsns.TriggeredSendMCId__c='1332';
        insert tsns;
        
        MktgCloudAPISettings__c mcsns = new MktgCloudAPISettings__c();
        mcsns.Name='TestMCAS';
        mcsns.ClientId__c='123';
        mcsns.ClientSecret__c='12';
        mcsns.MCAPIAccessToken__c='11';
        mcsns.MktgAuthURL__c='11';
        mcsns.TokenCreationDate__c=Date.today();
        mcsns.TokenDuration__c=30;
        insert mcsns;
        MarketingCloudAPIUtil.sendMessageWithMC('TestCNS', '{"responses":[{"hasErrors":false,"id":20,"value":"C_OT_MB_EQUIPMENT_MODEMS"},{"displayText":"Modem","id":20,"value":"C_OT_MB_EQUIPMENT_MODEMS"}]}', 'randomData');
		
    }
    
    static testMethod void testCampaignWrapper() {
        createCampaignWrapper();
    }
    
    public static MarketingCloudAPIUtil.CampaignWrapper createCampaignWrapper() {
        return new MarketingCloudAPIUtil.CampaignWrapper('1234', 'Campaign Test', 'Test Description', 'MC Description', '');
    }

    public class MktgCloudCalloutCreateCampaignMock implements HttpCalloutMock{
        
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"id":"1234"}');
            res.setStatusCode(200);
            return res; 
        }
    }
    
    public class MktgCloudCalloutMock implements HttpCalloutMock{
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"accessToken":"1234567", "expiresIn": 3479}');
            res.setStatusCode(200);
            return res; 
        }
    }    
    
    public static SingleRequestMock mktgCloudCampaignResponse (){
    	SingleRequestMock fakeCampaignResponse = new SingleRequestMock(200,
                                                         'Complete',
                                                         '{"id":"1234"}',
                                                         null);

        return fakeCampaignResponse;
    }
    
    public static SingleRequestMock accessTokenResponse () {
        SingleRequestMock fakeTokenResponse = new SingleRequestMock(200,
                                                         'Complete',
                                                         '{"accessToken":"1234567"}',
                                                         null);

        return fakeTokenResponse;
    }
    
    public static MktgCloudAPISettings__c getMktgCloudAPISettings() {
        MktgCloudAPISettings__c mktgCloudAPISettings = new MktgCloudAPISettings__c ();
        mktgCloudAPISettings.Name = 'Mktg Cloud API';
        mktgCloudAPISettings.ClientId__c = '1234';
        mktgCloudAPISettings.ClientSecret__c = '4567';
        mktgCloudAPISettings.MktgAuthURL__c = 'https://auth.exacttargetapis.com/v1/requestToken';
        
        return mktgCloudAPISettings;
    } 
        
}