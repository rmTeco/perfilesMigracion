public with sharing class TrackingEntryClass {
    
    public static void updateTrackingEntry(List<vlocity_cmt__VlocityTrackingEntry__c> triggerNew){

       List<Id> ownersID = new List<Id>();
        
        for(vlocity_cmt__VlocityTrackingEntry__c t : triggerNew)
        {
            if(t.TrackedAction__c == 'Consulta de Comprobante')
                ownersID.add(t.OwnerId);
        }
            
        List<Team_Member__c> workTeamUser = [SELECT Work_Team__c, User_member__c FROM Team_Member__c WHERE User_member__c IN :ownersID];
        system.debug('workTeamUser'+ workTeamUser);
        List<vlocity_cmt__VlocityTrackingEntry__c> trackinListUpdate = new List<vlocity_cmt__VlocityTrackingEntry__c>();
        system.debug('trackingListUpdate'+ trackinListUpdate);
        
        for(vlocity_cmt__VlocityTrackingEntry__c ta : triggerNew)
        {
            if(ta.TrackedAction__c == 'Consulta de Comprobante'){
                for(Integer w=0; w < workTeamUser.size(); w++){
                    if(ta.OwnerId == workTeamUser[w].User_member__c){
                        ta.vlocity_cmt__Data__c = ta.vlocity_cmt__Data__c+',workTeamUser: '+workTeamUser[w].Work_Team__c;
                    }
                }
            }
        }
           
    }

/*ta_helper.getWorkTeamUserInfo(userId);
public class ta_helper{
public static List<Team_Member__c> getWorkTeamUserInfo(Id userId)
{
   List<Team_Member__c> workTeamUser = [SELECT Work_Team__c, User_member__c FROM Team_Member__c WHERE User_member__c = :userId]; 
   return workTeamUser;
}
}*/

}