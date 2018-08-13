public class MarketingCloudAPIUtil {
    
    public static Boolean skipAPICall = false;
    
    public static String getMCAccessToken()
    {
        String token = '';
        List<MktgCloudAPISettings__c> mktgCloudAPISettings = MktgCloudAPISettings__c.getall().values();
        
        Decimal tokenDuration = mktgCloudAPISettings.get(0).tokenDuration__c;
        DateTime tokenCreationDate = mktgCloudAPISettings.get(0).tokenCreationDate__c;
        Decimal diffInSecs = 0;
        if(tokenCreationDate != null ){
            diffInSecs = Decimal.valueOf(Datetime.now().getTime() - tokenCreationDate.getTime()) / 1000;
        }
        
        if(!skipAPICall || tokenDuration == null || diffInSecs == 0 || diffInSecs >= tokenDuration || mktgCloudAPISettings.get(0).MCAPIAccessToken__c == null){
            
            Map<String, String> params = new Map<String, String>();
            params.put('clientId', mktgCloudAPISettings.get(0).ClientId__c);
            params.put('clientSecret', mktgCloudAPISettings.get(0).ClientSecret__c );
            
            String jsonParams = JSON.serialize(params);
            
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(mktgCloudAPISettings.get(0).MktgAuthURL__c); 
            req.setHeader('Content-Type','application/json'); 
            req.setBody(jsonParams);
            req.setMethod('POST'); 
            
            HTTPResponse res = h.send(req);
            String responseBody = res.getBody();
            
            token = ((Map<String, String>) JSON.deserialize(responseBody, Map<String, String>.class)).get('accessToken');
            
            Decimal expiresIn = Decimal.valueOf(((Map<String, String>) JSON.deserialize(responseBody, Map<String, String>.class)).get('expiresIn'));
            
            /*mktgCloudAPISettings.get(0).MCAPIAccessToken__c = token;
            mktgCloudAPISettings.get(0).tokenCreationDate__c = Datetime.now();
            mktgCloudAPISettings.get(0).tokenDuration__c = expiresIn;
            
            //AsyncMktgAPISettingsUpdate asyncMktgSettingsUpdateJob = new AsyncMktgAPISettingsUpdate(mktgCloudAPISettings.get(0));
            
            //ID jobID = System.enqueueJob(asyncMktgSettingsUpdateJob);
            
            //updateMktgCloudAPISettings(token, Datetime.now(), expiresIn);
            */
            
        } else {
            token = mktgCloudAPISettings.get(0).MCAPIAccessToken__c;
        }
        return token;
    }
    
    @future
    public static void updateMktgCloudAPISettings(String newToken, Datetime tokenCreationDate, Decimal expiresIn){
        List<MktgCloudAPISettings__c> mktgCloudAPISettings = MktgCloudAPISettings__c.getall().values();
        mktgCloudAPISettings.get(0).MCAPIAccessToken__c = newToken;
        mktgCloudAPISettings.get(0).tokenCreationDate__c = tokenCreationDate;
        mktgCloudAPISettings.get(0).tokenDuration__c = expiresIn;
        
        update mktgCloudAPISettings;
    }
    
    public static String createCampaign(String accessToken, CampaignWrapper campaign) {
        
        String MCId = '';
        
        //if(!skipAPICall){
            Map<String, String> bodyParams = new Map<String, String>();
            
            bodyParams.put('name', campaign.Name);
            bodyParams.put('description', campaign.descriptionMC);
            bodyParams.put('campaignCode', campaign.campaignId);
            bodyParams.put('favorite', 'false');
            
            String reqBody = JSON.serialize(bodyParams);
            
            Http h = new Http();
            HttpRequest r = new HttpRequest();
            r.setEndpoint('https://www.exacttargetapis.com/hub/v1/campaigns');  
            r.setMethod('POST');
            r.setHeader('Content-type','application/json');
            r.setHeader('Authorization', 'Bearer '+accessToken);
            r.setBody(reqBody);    
            HttpResponse res = h.send(r);
            
            MCId = ((Map<String, String>) JSON.deserialize(res.getBody(), Map<String, String>.class)).get('id');		
       // }
        
        return MCId;
    }
    
    public static void updateCampaign(String accessToken, CampaignWrapper campaign, String mcId) {
        
        Map<String, String> bodyParams = new Map<String, String>();
        
        bodyParams.put('name', campaign.Name);
        bodyParams.put('description', campaign.descriptionMC);
        bodyParams.put('campaignCode', campaign.campaignId);
        bodyParams.put('favorite', 'false');
        
        String reqBody = JSON.serialize(bodyParams);
        
        Http h = new Http();
        HttpRequest r = new HttpRequest();
        r.setEndpoint('https://www.exacttargetapis.com/hub/v1/campaigns/'+mcId);  
        r.setMethod('POST');
        r.setHeader('Content-type','application/json');
        r.setHeader('Authorization', 'Bearer '+accessToken);
        r.setBody(reqBody); 
        HttpResponse res = h.send(r);
    }    
    
    public class CampaignWrapper {
        public String campaignId {get;set;}
        public String name {get;set;}
        public String description {get;set;}
        public String descriptionMC{get;set;}
        public String marketingCloudId{get;set;}
        
        public CampaignWrapper(String campaignId, String name, String description, String descriptionMC, String marketingCloudId) {
            this.campaignId = campaignId;
            this.name = name;
            this.description = description;
            this.descriptionMC = descriptionMC;
            this.marketingCloudId = marketingCloudId;           
        }
    }
    
    public static List<String> serializeCampaigns (List<Campaign> campaigns) {
        List<String> serializedCampaigns = new List<String>();
        String descriptionMC = '';
        
        Schema.FieldSet fs1 = Schema.SObjectType.Campaign.fieldSets.getMap().get('AdditionalMCCampaignFields');
        List<Schema.FieldSetMember> fields = fs1.getFields();
        
        for (Campaign camp : campaigns) {
            for(Schema.FieldSetMember fsm : fields){
                if(camp.get(fsm.getFieldPath()) != null && camp.get(fsm.getFieldPath()) != '')     
                    descriptionMC = descriptionMC + fsm.getLabel() +': ' + camp.get(fsm.getFieldPath()) + ' | ';
            }
            
            CampaignWrapper campaignWrapper = new CampaignWrapper (camp.Id,
                                                                   camp.Name, camp.Description, descriptionMC, camp.MarketingCloudCampaignId__c);
            
            
            serializedCampaigns.add(JSON.serialize(campaignWrapper));
        }
        
        return serializedCampaigns;
    }
    
    public static Map<String, String> sendMessageWithMC(String triggeredSendName, String jsonParams, String accessToken){
        
        Map<String, String> sendMsgResponse = new Map<String,String>();

        TriggeredSendNotificationSettings__c triggeredSendKey = TriggeredSendNotificationSettings__c.getValues(triggeredSendName);
        List<MktgCloudAPISettings__c> mktgCloudAPISettings = MktgCloudAPISettings__c.getall().values();
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://www.exacttargetapis.com/messaging/v1/messageDefinitionSends/key:' + triggeredSendKey.TriggeredSendMCId__c + '/send'); 
        req.setHeader('Content-Type','application/json');
        req.setHeader('Authorization', 'Bearer '+ accessToken);
        req.setBody(jsonParams);
        req.setMethod('POST'); 
        
        HTTPResponse res = h.send(req);
        
        String responseBody = res.getBody();
       
        SendMessageResponseWrapper sendMessageWrapper = new SendMessageResponseWrapper();

        sendMessageWrapper = (SendMessageResponseWrapper) JSON.deserialize(responseBody, SendMessageResponseWrapper.class);

        sendMsgResponse.put('HasErrors', String.valueOf(sendMessageWrapper.responses.get(0).hasErrors));
        

        if(sendMessageWrapper.responses != null && !sendMessageWrapper.responses.isEmpty() && sendMessageWrapper.responses.get(0).hasErrors == true){
            sendMsgResponse.put('MessageErrorCode', String.valueOf(sendMessageWrapper.responses.get(0).messageErrors.get(0).messageErrorCode));
            sendMsgResponse.put('MessageErrorStatus', sendMessageWrapper.responses.get(0).messageErrors.get(0).messageErrorStatus);
        } 

        return sendMsgResponse;
    }


    public class SendMessageResponseWrapper{
        public String requestId {get;set;}
        public List<SendMessageErrorsWrapper> responses{get;set;}
    }

    public class SendMessageErrorsWrapper{
        public String recipientSendId {get;set;}
        public Boolean hasErrors {get;set;}
        public List<String> messages {get;set;}
        public List<MessageErrorsWrapper> messageErrors {get;set;}

    }

    public class MessageErrorsWrapper{
        public Decimal messageErrorCode {get;set;}
        public String messageErrorStatus {get;set;}
    }

}