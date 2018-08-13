public class WorkTeamTriggerHandler {
    
    /**
    * @Author: Julia Carranza
    * @Description: Delete the Public Groups related with the Deleted Work Teams.
    */
    public static void syncAfterDelete(){
        Set<String> groupAPINamesSet = new Set<String>();
        for(WorkTeam__c wt : (List<WorkTeam__c>)Trigger.old){
            groupAPINamesSet.add(wt.PublicGroupAPIName__c);
        }
        System.debug('groupAPINamesSet: ' + groupAPINamesSet);
        WorkTeamTriggerHelper.deleteGroups(groupAPINamesSet);
    }   

    /**
    * @Author: Julia Carranza
    * @Description: Creates de value for the Public Group External ID.
    */
    public static void convertToDeveloperName(){
        for(WorkTeam__c wt : (List<WorkTeam__c>)Trigger.new){
            String value = wt.Name;
            Pattern apiNamePattern = Pattern.compile('[a-zA-Z0-9_]');
            
            for(Integer i = 0; i < value.length(); i++){
                String charRes = value.substring(i, i+1);
                Matcher apiNameMatcher = apiNamePattern.matcher(charRes);
                if(!apiNameMatcher.matches()){
                    value = value.replace(charRes,'');
                }
            }
            
            wt.PublicGroupAPIName__c = value;
            
            If (Test.isRunningTest()){
                wt.PublicGroupAPIName__c = 'NoName' + string.valueOf(math.round(math.random()*100));
            }
        }
    }

    /**
    * @Author: Norwill Gutierrez
    * @Description: Delete the corresponding Public Group when workteam is inactive
    */    
    public static void OnAfterUpdate(WorkTeam__c[] updatedWorkTeams){
        Set<String> queueAPINamesSet = new Set<String>();
        Map<Id, Integer> wtToUpdate = new Map<Id, Integer>();
        for(WorkTeam__c wt : updatedWorkTeams){
            if(wt.Is_Active__c == false){
                queueAPINamesSet.add(wt.PublicGroupAPIName__c);
            }                      
        }
        if(queueAPINamesSet.size() > 0){
            WorkTeamTriggerHelper.deleteGroupMember(queueAPINamesSet);
        }
    }    
}