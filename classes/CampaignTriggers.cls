public class CampaignTriggers {
	
    //This method makes an update on CampaignMemberStatus including the global values that are set in the Campaign Picklist.
    //These values are going to be used in Marketing Cloud
    public static void updateCampaignMemberStatus() {
        
        List<CampaignMemberStatus> campaignMembStatusesToInsert = new List<CampaignMemberStatus>();
        List<CampaignMemberStatus> campaignMembStatusesToDelete = new List<CampaignMemberStatus>();
        
        for(CampaignMemberStatus campMembStatusToDelete : [SELECT Id, campaignID, label FROM CampaignMemberStatus WHERE campaignID IN :Trigger.New]) { 
            if(campMembStatusToDelete.Label == 'Sent' || campMembStatusToDelete.Label == 'Responded') {
                campaignMembStatusesToDelete.add(campMembStatusToDelete);
            }    
        }
        
        for (Campaign camp : (List<Campaign>)Trigger.New) {
            for(String campMembStatus : MarketingUtil.obtainPicklistValues('Campaign', 'CampaignMemberStatuses__c')) {
                CampaignMemberStatus cms = new CampaignMemberStatus();
                cms.CampaignId = camp.Id;
                cms.Label = campMembStatus;
                cms.HasResponded = false;
                if(campMembStatus == 'Iniciado') {
                    cms.IsDefault = true;
                }
                if(campMembStatus == 'Interesado' || campMembStatus == 'Clickeado' || campMembStatus == 'Concretado') {
                    cms.HasResponded = true;
                }
                campaignMembStatusesToInsert.add(cms);
            }
        }

        insert campaignMembStatusesToInsert;
        delete campaignMembStatusesToDelete;
    }
}