global with sharing class TriggeredSendNotificationService implements vlocity_cmt.VlocityOpenInterface{
    
    global TriggeredSendNotificationService() {}
    
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true; 

        try{
            if (methodName.equals('sendMessage')){
                sendMessage(inputMap,outMap, null);
            }
        }catch(Exception e){
            System.debug('TriggeredSendNotificationService:invokeMethod -> exception: '+e);
            result = false;
        }
        return result;
    }
    
    public void sendMessage(Map<String, Object> inputMap, Map<String, Object> outMap, String sendType){

        NotificationServiceResponse serviceResponse = new NotificationServiceResponse();

        try{ 
            MessageWrapper messageToSend = new MessageWrapper();
            ToAddressWrapper toAddressWrapper = new ToAddressWrapper();
            OptionsWrapper optionsWrapper = new OptionsWrapper();
            SubscriberAttributesWrapper subscriberAttrs = new SubscriberAttributesWrapper();

            Map<String, String> mktgUtilResponse = new Map<String, String>();

            List<Object> toSendList = VlocityOpenInterfaceHelper.getListObjectsFromMap(inputMap, 'To');

            for (Object toSendObj : toSendList){
                Map<String, Object> toMap = (Map<String, Object>)toSendObj;
                serviceResponse.errorCodeMessageMap = validateParameters(toMap);

                if(serviceResponse.errorCodeMessageMap.isEmpty()){
                    toAddressWrapper.address = String.valueOf(toMap.get('Address'));
                    toAddressWrapper.subscriberKey = String.valueOf(toMap.get('SubscriberKey'));
                    optionsWrapper.requestType = String.valueOf(toMap.get('Options'));
                    toAddressWrapper.channel = String.valueOf(toMap.get('Channel'));
                    toAddressWrapper.processName = String.valueOf(toMap.get('processName'));
                    messageToSend.options = optionsWrapper;

                    List<Object> attributesList = VlocityOpenInterfaceHelper.getListObjectsFromMap(toMap, 'ContactAttributes');
                    for(Object attr : attributesList){
                        subscriberAttrs.subscriberAttributes = (Map<String, Object>)attr;
                    }
                } else {
                    serviceResponse.success = false;
                }
            }

            if(serviceResponse.success == true){
                toAddressWrapper.contactAttributes = subscriberAttrs;
                messageToSend.to = toAddressWrapper;
                
                String token = MarketingCloudAPIUtil.getMCAccessToken();
                String jsonParams = JSON.serialize(messageToSend);
                
                mktgUtilResponse = MarketingCloudAPIUtil.sendMessageWithMC(toAddressWrapper.processName, jsonParams, token);

                if('true' == mktgUtilResponse.get('HasErrors')){
                    serviceResponse.success = false;
                    serviceResponse.errorCodeMessageMap.put('00', mktgUtilResponse.get('MessageErrorCode') + ' - ' + mktgUtilResponse.get('MessageErrorStatus'));
                }
            
            }
            
            outMap.put('ServiceResponse', serviceResponse);
           
        }catch (Exception e) {
            System.debug('TriggeredSendNotificationService: sendMessage' + e.getMessage());
            System.debug(e.getMessage());
            serviceResponse.success = false;
            serviceResponse.errorCodeMessageMap.put('00', e.getMessage());
            outMap.put('ServiceResponse', serviceResponse);
        }
    }

    public Map<String, String> validateParameters(Map<String, Object> toValidateMap){
        Map<String, String> validationErrorMap = new Map<String, String>();
        List<String> parameters;

        if(null == toValidateMap.get('Address') || !validateEmailAddress(String.valueOf(toValidateMap.get('Address')))){
            parameters = new List<String>();
            parameters.add('Address');
            parameters.add('');
            validationErrorMap.put('01', String.format(Label.TriggeredSendNotifServiceInvalidParameter, parameters));
        }
        if(null == toValidateMap.get('SubscriberKey') || ( !String.valueOf(toValidateMap.get('SubscriberKey')).startsWith('003') && 
            !String.valueOf(toValidateMap.get('SubscriberKey')).startsWith('00Q') ) && !validateEmailAddress(String.valueOf(toValidateMap.get('SubscriberKey')))){
            parameters = new List<String>();
            parameters.add('SubscriberKey');
            parameters.add(' It should be a Contact, a Lead or an Email Address');
            validationErrorMap.put('02', String.format(Label.TriggeredSendNotifServiceInvalidParameter, parameters));
        }
        if(null == toValidateMap.get('Channel') || ( String.valueOf(toValidateMap.get('Channel')) != 'Email' && String.valueOf(toValidateMap.get('Channel')) != 'SMS' ) ){
            validationErrorMap.put('03','The Parameter: Channel should be Email or SMS');
        }
        if(null == toValidateMap.get('processName') || null == TriggeredSendNotificationSettings__c.getValues(String.valueOf(toValidateMap.get('processName')))){
            validationErrorMap.put('04','The Parameter: ProcessName is invalid');
        }

        return validationErrorMap;
    }

    public Boolean validateEmailAddress(String email){
        String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
        Pattern emailPattern = Pattern.compile(emailRegex);
        Matcher emailMatcher = emailPattern.matcher(email);

        return emailMatcher.matches();
    }
    
    
    public class MessageWrapper {
        public ToAddressWrapper to {get;set;}
        public OptionsWrapper options {get;set;}
        
        public MessageWrapper(){}
    }
    
    public class SubscriberAttributesWrapper {
        public Map<String,Object> SubscriberAttributes{get;set;}
    }
    
    public class ToAddressWrapper {
        public String address {get;set;}
        public String subscriberKey {get;set;}
        public SubscriberAttributesWrapper contactAttributes {get; set;}
        public String channel {get; set;}
        public String processName {get; set;}
    }

    public class OptionsWrapper {
        public String requestType {get;set;}
    }


    public class NotificationServiceResponse {
        // Error Codes
        /*
* 00 - Error General
* 01 - Invalid Email Address
* 02 - Invalid SubscriberKey
* 03 - Invalid Channel
* 04 - Invalid ProcessName
*/
        public Boolean success = true;
        public Map<String,String> errorCodeMessageMap = new Map<String,String>();

        public NotificationServiceResponse(){}
        
        public NotificationServiceResponse(Boolean succes, Map<String,String> errorCodeMessageMap){
            this.success = success;
            this.errorCodeMessageMap = errorCodeMessageMap;
        }
    }


}