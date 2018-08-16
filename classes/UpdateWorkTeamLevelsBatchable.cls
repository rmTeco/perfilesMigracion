global class UpdateWorkTeamLevelsBatchable implements Database.Batchable<sObject> {
	
	String query = '[SELECT Id, Parent_Team__c, WorkTeamLevel__c  FROM WorkTeam__c WHERE Parent_Team__c = null]';
	Integer wtLevel = 1;

	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator([SELECT Id, Parent_Team__c, WorkTeamLevel__c  FROM WorkTeam__c WHERE Parent_Team__c = null]);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		List<WorkTeam__c> lstTopParents = new List<WorkTeam__c>();
		Set<Id> lstTopParentsIds = new Set<Id>();
		
		//Level 1
        for (WorkTeam__c wt : (List<WorkTeam__c>) scope) 
        {
			wt.WorkTeamLevel__c = wtLevel;
			lstTopParents.add(wt); 
			lstTopParentsIds.add(wt.Id);              
        }

		update lstTopParents;

		setChildrensLevel(lstTopParentsIds, wtLevel);	
	}
	
	public void setChildrensLevel(Set<Id> lstTopParentsIds, Integer wtLevel){
		wtLevel  = wtLevel + 1;

		List<WorkTeam__c> lstChildrens = [SELECT Id, Parent_Team__c, WorkTeamLevel__c  
										  FROM WorkTeam__c 
										  WHERE Parent_Team__c IN :lstTopParentsIds];
		
		Set<Id> lstChildrensIds = new Set<Id>();

		for (WorkTeam__c wt : lstChildrens) 
        {
			wt.WorkTeamLevel__c = wtLevel;
			lstChildrensIds.add(wt.Id);              
        }

		update lstChildrens	;

		if(!lstChildrens.isEmpty()){
			setChildrensLevel(lstTopParentsIds, wtLevel);
		}
	}

	global void finish(Database.BatchableContext BC) {
		
	}	
}