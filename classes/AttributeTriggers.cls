public class AttributeTriggers {

	public static void ValidateAssignments(){

		Set<Id> deleted = new Set<Id>();

		if(trigger.isDelete){
            deleted = Trigger.NewMap.keySet();
            
		}else{
			for(vlocity_cmt__Attribute__c attributeNew : (List<vlocity_cmt__Attribute__c>)Trigger.New){
                vlocity_cmt__Attribute__c attributeOld = (vlocity_cmt__Attribute__c)Trigger.OldMap.get(attributeNew.Id);
                if(attributeOld.vlocity_cmt__ActiveFlg__c && !attributeNew.vlocity_cmt__ActiveFlg__c){
                    deleted.add(attributeNew.Id);
                }
			}	
		}
		List<vlocity_cmt__attributeAssignment__c> assignments = [SELECT Id, vlocity_cmt__AttributeId__c FROM vlocity_cmt__attributeAssignment__c
																  WHERE vlocity_cmt__AttributeId__c IN :deleted
																  	AND vlocity_cmt__IsActiveAssignment__c = true];
		
        for(vlocity_cmt__attributeAssignment__c assignment : assignments){
            Trigger.NewMap.get(assignment.vlocity_cmt__AttributeId__c).addError(Label.ErrorAttributeDeleted);
        }
        
	}
}