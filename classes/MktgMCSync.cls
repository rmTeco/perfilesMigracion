public class MktgMCSync {
    
    @InvocableMethod(label='Sync campaing with MC' description='Synchronizes SF campaigns with marketing cloud')
    public static void sincronizeCampaignWithMC(List<Campaign> campaigns) {
        
        List <String> serializedCampaigns = MarketingCloudAPIUtil.serializeCampaigns(campaigns);

		createMCCampaigns(serializedCampaigns);
        
    }
    
    @future(callout=true) static void createMCCampaigns(List <String> serializedCampaigns){
        
        MktgCloudAPISettings__c mktgCloudAPISettings = MktgCloudAPISettings__c.getall().values();
        Boolean updateMCAPISettings = false;

        if(!MarketingCloudAPIUtil.isValidMCToken()){
            mktgCloudAPISettings = MarketingCloudAPIUtil.getMCAccessToken();
            updateMCAPISettings = true;
        }
        
        Map<String, String> idsSFMC = new Map<String, String>();
        
        for(String camp : serializedCampaigns){
            MarketingCloudAPIUtil.CampaignWrapper currentCampaign = (MarketingCloudAPIUtil.CampaignWrapper) JSON.deserialize(camp, MarketingCloudAPIUtil.CampaignWrapper.class);

            idsSFMC.put(currentCampaign.campaignId, MarketingCloudAPIUtil.createCampaign(mktgCloudAPISettings.MCAPIAccessToken__c, currentCampaign));
        }
        
        if(updateMCAPISettings){
            update mktgCloudAPISettings;
        }
        updateCampaignsWithMCId(idsSFMC);
    }


    public static void updateCampaignsWithMCId(Map<String, String> idsSFMC){
        List<Campaign> sfCampaigns = new List<Campaign>();
        for(String idSF : idsSFMC.keySet()){
            Campaign sfCampaign = new Campaign(Id = idSF, MarketingCloudCampaignId__c = idsSFMC.get(idSF));
            sfCampaigns.add(sfCampaign);
        }
        update sfCampaigns;
    }
}