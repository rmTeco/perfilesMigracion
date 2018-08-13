@isTest
public class CampaignTriggersTest {

    static testMethod void testUpdateCampaignMemberStatus() {
        
        MktgCloudAPISettings__c mktgCloudAPISettings = new MktgCloudAPISettings__c ();
        mktgCloudAPISettings.Name = 'Mktg Cloud API';
        mktgCloudAPISettings.ClientId__c = '1234';
        mktgCloudAPISettings.ClientSecret__c = '4567';
        mktgCloudAPISettings.MktgAuthURL__c = 'https://auth.exacttargetapis.com/v1/requestToken';
        mktgCloudAPISettings = getMktgCloudAPISettings();
        insert mktgCloudAPISettings;
        
        Test.setMock(HttpCalloutMock.class, new MktgCloudCalloutMock2()); 
        
        SingleRequestMock fakeTokenResponse = MarketingCloudAPIUtilTest.accessTokenResponse();
        SingleRequestMock fakeCampaignResponse = MarketingCloudAPIUtilTest.mktgCloudCampaignResponse();
        
        List<Campaign> campaignList = new List<Campaign>();
        for(Integer i = 0; i < 50 ; i++) {
            Campaign cp = new Campaign(Name = 'Test Campaign ' + i, Campaign_Type__c = 'Desarrollo',
                                       Campaign_Subtype__c = 'Fidelización', Campaign_Subtype_2__c = 'Club Personal', 
                                       Channel_Type__c  = 'OUT', Channel__c  = 'SMS', Campaign_Destiny__c = 'Masivo', Type = 'Desarrollo',
                                       Destination__c = 'Masivo',SubtypeL1__c = 'Fidelización', SubtypeL2__c = 'Club Personal');
            campaignList.add(cp);
        }
        
        Map<String, SingleRequestMock> endpoint2TestResp = new Map<String,SingleRequestMock>();
        
        endpoint2TestResp.put('https://auth.exacttargetapis.com/v1/requestToken', fakeTokenResponse);
        endpoint2TestResp.put('https://www.exacttargetapis.com/hub/v1/campaigns', fakeCampaignResponse);

        HttpCalloutMock multiCalloutMock = new MktgCloudMultiCalloutMock(endpoint2TestResp);
 		Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        Test.startTest();        
        Test.setMock(HttpCalloutMock.class, new MktgCloudCalloutCreateCampaignMock2());         
        insert campaignList;
        Test.stopTest();
    }
    
    public class MktgCloudCalloutCreateCampaignMock2 implements HttpCalloutMock{
        
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"id":"1234"}');
            res.setStatusCode(200);
            return res; 
        }
    }

 public class MktgCloudCalloutMock2 implements HttpCalloutMock{
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