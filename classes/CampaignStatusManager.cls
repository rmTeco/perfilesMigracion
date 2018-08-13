public class CampaignStatusManager {
/*  @InvocableMethod(label='Disable Campaign Members' description='Changes all campaign members status when a campaign is aborted')
    public static void disableCampaignMembers(List<Campaign> campaigns) {
        List<CampaignMember> campaignMembers = new List<CampaignMember>();
        Set<Id> abortedCampaignIds = new Set<Id>();
        
        for (Campaign camp : campaigns) {
                abortedCampaignIds.add(camp.Id);
        }
        
        campaignMembers = getCampaignMembers(abortedCampaignIds);
        
        for(CampaignMember campMemb : campaignMembers) {
            campMemb.AbortedCampaign__c = true;
        }
        
        update campaignMembers;
    }

    public static List<CampaignMember> getCampaignMembers(Set<Id> campaignIdSet) {
        return [SELECT Id, Status FROM CampaignMember WHERE 
                                                    CampaignId IN : campaignIdSet];
        
    }LESTEVECO*/
}