public class TreeWorkTeamController {
    public static set<string> set_workTeamFields = new set<string>{'Id', 'Is_Active__c', 'Name', 'Parent_Team__c'};
        
        /*
*/
        @AuraEnabled  
        public static list<TreeComponentsItems> getWorkTeamHierarchy(Id str_workTeamId/*, map<string,list<string>> map_camposXobjeto*/) 
    {  
        system.debug('<<TreeWorkTeamController.getWorkTeamHierarchy>> str_workTeamId: ' + str_workTeamId);
        
      
        if(str_workTeamId==null)
           return null;
        
        
        //Wrapper instance  
        list<TreeComponentsItems> finalWrp = new List<TreeComponentsItems>();  		
        list<WorkTeam__c> list_workTeams;
        
        finalWrp = getNestedComponents( dataBaseQuery('WorkTeam__c', TreeWorkTeamController.set_workTeamFields, 'Parent_Team__c', new set<string>{str_workTeamId}, 'AND Is_Active__c=true') );  			
        
        system.debug('<<TreeWorkTeamController.getWorkTeamHierarchy>> finalWrp Size: ' + finalWrp.size());			
        
        return finalWrp;    
    }//ends getWorkTeamHierarchy
    
    /*
*/
    public static list<TreeComponentsItems> getNestedComponents(list<WorkTeam__c> list_inWorkTeam)
    {
        
        if(list_inWorkTeam==null)
            return null;
        
        list<TreeComponentsItems> finalWrp = new List<TreeComponentsItems>();  	
        
        for(WorkTeam__c obj_workTeam : list_inWorkTeam)
        {
            
            list<TreeComponentsItems> trP1 = new list<TreeComponentsItems>();		
            
            if(obj_workTeam.Parent_Team__r!=null)
                trP1.addAll( getNestedComponents( dataBaseQuery( 'WorkTeam__c', TreeWorkTeamController.set_workTeamFields, 'Parent_Team__c', new set<string>{obj_workTeam.Id}, 'AND Is_Active__c=true')));  
            
            finalWrp.add(new TreeComponentsItems(obj_workTeam.Id, string.valueOf(obj_workTeam.Name), false, trP1)); 				
        }
        
        return finalWrp;
    }//ends getNestedComponents
    
    
  
    
    /*
*/
    public static list<WorkTeam__c> dataBaseQuery( String str_SObject, set<string> lst_selectColumns, String str_whereField, set<string> lst_filters, string str_filter )
    {
        list<WorkTeam__c> list_workTeams;
        
        system.debug('<<TreeWorkTeamController.getNestedComponents>> lst_selectColumns : ' + lst_selectColumns + 'str_whereField: ' +str_whereField+' lst_filters: '+ lst_filters + ' lstr_filter : ' + str_filter );         
        
        String strSOQL = 'SELECT \n';
        
        for( String strFieldName : lst_selectColumns )
            strSOQL += '\t' + strFieldName + ', \n';
        
        strSOQL = strSOQL.substringBeforeLast( ',' ) + ' \n';
        
        strSOQL += 'FROM ' + str_SObject + ' \n' + 'WHERE ' + str_whereField + ' IN:' + lst_filters +str_filter;
        
        system.debug('<<TreeWorkTeamController.getNestedComponents>> strSOQL : ' + strSOQL);        
        
        list_workTeams = (list<WorkTeam__c>) Database.query(strSOQL);            
        
        return list_workTeams;
    }//ends dataBaseQuery    
    
    
}