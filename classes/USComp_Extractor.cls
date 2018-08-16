public class USComp_Extractor {
    
    public static String sprintNameInPage { get; set; }
    
    public static void extractTest(String sprint) {
        sprintNameInPage = sprint;
        extract();
    }
    
    public static void extract(){
            
        String sprintName = sprintNameInPage;
        system.debug('Inside extract' + sprintName);
        if(sprintName != null) {
        system.debug('Inside IF' + sprintName);      
        List<Historias_de_Usuario__c> customActualUserStories = [SELECT ID, Name, Historias_de_Usuario_Jira__c, Funcionalidad__c FROM Historias_de_Usuario__c WHERE Sprint__c=:sprintName ];
        List<copado__User_Story__c> copadoActualUserStories = [SELECT ID, Name, copado__Sprint__r.name,copado__Team__r.Name,copado__User_Story_Title__c,C_digo_de_la_Funcionalidad__c FROM copado__User_Story__c WHERE copado__Sprint__r.Name=:sprintName ];
        
        List<Attachment> usAttachmentList = new List<Attachment>();
        
        if(!copadoActualUserStories.isEmpty()){
                
            usAttachmentList = [SELECT Id ,Parent.name, ParentId, Name, body FROM Attachment WHERE ParentId IN:copadoActualUserStories]; 
            
            Map<ID, copado__User_Story__c> copadoActualUserStoriesMap = new Map<ID,copado__User_Story__c>(copadoActualUserStories);
            Map<String,Historias_de_Usuario__c> customActualUserStoriesMap = listToMapWithStringAsKeyUS(customActualUserStories);

            List<Componente__c> componentsList = [SELECT Id , external_id__c, Historia_de_Usuario__c FROM Componente__c WHERE Historia_de_Usuario__c IN:customActualUserStories]; 
            
            Map<String,Componente__c> componentsListMap = listToMapWithStringAsKeyComponents(componentsList);
            
            List<Funcionalidad__c> featuresList = [SELECT ID ,C_digo_de_la_Funcionalidad__c FROM Funcionalidad__c];
            
            Map<String,Funcionalidad__c> featuresMap = listToMapWithStringAsKeyFeatures(featuresList);
            
            for(copado__User_Story__c userStory : copadoActualUserStories )
            {
                Historias_de_Usuario__c userStoryCustom = customActualUserStoriesMap.get(userStory.Name);
                
                    if(userStoryCustom == null){
                        String pftaJiraTitle = userStory.copado__User_Story_Title__c;
                        if(pftaJiraTitle.length()>250){
                            pftaJiraTitle = pftaJiraTitle.substring(0,250);
                        }
                        
                        Funcionalidad__c userStoryFeature = featuresMap.get(userStory.C_digo_de_la_Funcionalidad__c);
                        if(userStoryFeature == null){
			                userStoryCustom = new Historias_de_Usuario__c (Name=userStory.Name, Sprint__c=(String) userStory.copado__Sprint__r.Name, Team__c= userStory.copado__Team__r.Name,Historias_de_Usuario_Jira__c=pftaJiraTitle);
                        }
                        else{
                            userStoryCustom = new Historias_de_Usuario__c (Name=userStory.Name, Sprint__c=(String) userStory.copado__Sprint__r.Name, Team__c= userStory.copado__Team__r.Name,Historias_de_Usuario_Jira__c=pftaJiraTitle);
                            userStoryCustom.Funcionalidad__c = userStoryFeature.ID;
                        }
                        customActualUserStories.add(userStoryCustom);
                        customActualUserStoriesMap.put(userStoryCustom.Name, userStoryCustom);
                    }
                    
            }
            upsert customActualUserStories Name;
            
            List<Permission_sets__c> permissionSetList = [SELECT ID, Name FROM Permission_sets__c];
            Map<String, Permission_sets__c> permissionSetsMap = listToMapWithStringAsKeyPermissionSets(permissionSetList);
            
            List<Permission_sets__c>  newPermSets = new List<Permission_sets__c>();
            
            for( Attachment usAtt : usAttachmentList ) {
                if(usAtt.name == 'Git MetaData') {
			            List<Object> compList  = (List<Object>) JSON.deserializeUntyped(usAtt.body.toString());
				        for(Object componet : compList ){
				            Map<String,Object> data = (Map<String,Object>) componet;
 				            string componentType = (String)data.get('t');
				            string componentName = (String)data.get('n');
				            String customUsExternalID = usAtt.Parent.Name + componentType + componentName;
				            Componente__c componentObj = componentsListMap.get(customUsExternalID);
				            
				            if(componentObj==null){
				                Historias_de_Usuario__c userStoryCustom = customActualUserStoriesMap.get(usAtt.Parent.Name);
				                componentObj = new Componente__c(name=componentName, Type__c=componentType,Historia_de_Usuario__c= userStoryCustom.ID,external_id__c=customUsExternalID);
				                componentsList.add(componentObj);
				                componentsListMap.put(customUsExternalID,componentObj);
				                
				                if(componentType=='PermissionSet'){
				                    Funcionalidad__c userStoryFeature = featuresMap.get(userStoryCustom.Codigo_de_la_Funcionalidad__c);
				                    if(userStoryFeature != null){
				                        Permission_sets__c permSet = permissionSetsMap.get(componentName);
				                        if(permSet==null){
				                           Permission_sets__c newPermSet = new Permission_sets__c(Name=componentName,Funcionalidad__c=userStoryFeature.ID);
				                           newPermSets.add(newPermSet);
				                        }
				                    }
				                }
				            }
				            

				        }
                 }
               }
               insert newPermSets;
               upsert componentsList external_id__c;
        }
            
        }
    }
    
    
    private static Map<String,Historias_de_Usuario__c> listToMapWithStringAsKeyUS(List<Historias_de_Usuario__c> oldList) {
        Map<String,Historias_de_Usuario__c> newMap = new Map<String,Historias_de_Usuario__c>();
        for(Historias_de_Usuario__c obj : oldList)
            newMap.put((String) obj.Name, obj);
        return newMap;
    }
    
    private static Map<String,Funcionalidad__c> listToMapWithStringAsKeyFeatures(List<Funcionalidad__c> oldList) {
        Map<String,Funcionalidad__c> newMap = new Map<String,Funcionalidad__c>();
        for(Funcionalidad__c obj : oldList)
            newMap.put(obj.C_digo_de_la_Funcionalidad__c, obj);
        return newMap;
    }
    
        private static Map<String,Componente__c> listToMapWithStringAsKeyComponents(List<Componente__c> oldList) {
        Map<String,Componente__c> newMap = new Map<String,Componente__c>();
        for(Componente__c obj : oldList)
            newMap.put(obj.external_id__c, obj);
        return newMap;
    }
    
    private static Map<String,Permission_sets__c> listToMapWithStringAsKeyPermissionSets(List<Permission_sets__c> oldList) {
        Map<String,Permission_sets__c> newMap = new Map<String,Permission_sets__c>();
        for(Permission_sets__c obj : oldList)
            newMap.put(obj.Name, obj);
        return newMap;
    }
    
    
    public List<SelectOption> getSprintOptions() {
        
        List<SelectOption> sprintOptions = new List<SelectOption>();
        List<copado__Sprint__c> sprints = [SELECT ID, Name from copado__Sprint__c];
        sprintOptions.add(new SelectOption('','- None -'));
        
        for(copado__Sprint__c sprint : sprints ) {
        	sprintOptions.add(new SelectOption(sprint.Name,sprint.Name));
        }
        return sprintOptions;
    }
    


}