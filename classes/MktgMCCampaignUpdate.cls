public class MktgMCCampaignUpdate {

    @InvocableMethod(label='Update Campaign with MC Id' description='Update SF campaigns with marketing cloud data')
    public static void updateCampaignWithMC(List<Campaign> campaigns) {
       List <String> serializedCampaigns = MarketingCloudAPIUtil.serializeCampaigns(campaigns);

       updateMCCampaigns(serializedCampaigns);
    }
    
    @future(callout=true) static void updateMCCampaigns(List <String> serializedCampaigns){
        String accessToken = MarketingCloudAPIUtil.getMCAccessToken();
        
        for(String camp : serializedCampaigns){
            MarketingCloudAPIUtil.CampaignWrapper currentCampaign = (MarketingCloudAPIUtil.CampaignWrapper) JSON.deserialize(camp, MarketingCloudAPIUtil.CampaignWrapper.class);
            if( null != currentCampaign.marketingCloudId ) { 
                MarketingCloudAPIUtil.updateCampaign(accessToken, currentCampaign, currentCampaign.marketingCloudId);
            }
        }
    }
}