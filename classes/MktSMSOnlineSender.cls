public class MktSMSOnlineSender {
    
    @InvocableMethod(label='SMS Online Sender' description='Sends SMS Online')
    public static void sendSMSOnline(List<CampaignMember> campaignMembers) {
        
    	Set<Id> idSet = new Set<Id>();
    	List<CrossObject__c> messagesList = new List<CrossObject__c>();

    	for(CampaignMember campaignMember : campaignMembers ){
    		idSet.add(campaignMember.MessageId__c);
    	}

    	messagesList = [SELECT Id, TextArea__c FROM CrossObject__c WHERE Id IN :idSet];

        for(CampaignMember campaignMember : campaignMembers ){

        	for(CrossObject__c message : messagesList){

        		if(message.Id == campaignMember.MessageId__c){
        			String body = '{"params": { "nroLinea": "'+ campaignMember.MobilePhoneSend__c +'"}, "body": {"communicationText": "'+ message.TextArea__c +'"}}';
		        	Map<String, Object> input = (Map<String, Object>) JSON.deserializeUntyped(body);
		            Map<String, Object> output = new Map<String, Object>();
		            Map<String, Object> options = new Map<String, Object>();
		            vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
		            integProcServ.invokeMethod('IFS_S159', input, output, options);		
        			break;
        		}
        	}               
        }
    }
}