public class KB_TopicAssigmentTriggerHandler {
	
	public static void onDeleteTopicAssignment(List<TopicAssignment> TriggerOld) {

		for(TopicAssignment topic : TriggerOld) {
	        System.debug('topic.EntityId: ' +topic.EntityId);
	        KB_Article__kav draft =[select Id, KnowledgeArticleId, KB_AssignedTopic__c, PublishStatus from KB_Article__kav where id=:topic.EntityId];               
	        List<TopicAssignment> topicsList=[select Id, EntityId from TopicAssignment where EntityId=: draft.Id];
	        System.debug('topicsList.size: ' +topicsList.size());
	        if(topicsList.size()==1){
	            if(!draft.PublishStatus.equalsIgnoreCase('Online')){             
	                draft.KB_AssignedTopic__c=False;
	                update draft;
	            }else{
	                System.debug('topicError: '+draft.PublishStatus);
	                Trigger.oldMap.get(topic.Id).addError(Label.KB_error_topics );
	            }
	        }
   		}
	}

	public static void onInsertUpdateTopicAssignment(List<TopicAssignment> TriggerNew) {
		for(TopicAssignment topic : TriggerNew) {
	        System.debug('topic.EntityId: ' +topic.EntityId);
	        KB_Article__kav draft =[select KnowledgeArticleId, KB_AssignedTopic__c, PublishStatus from KB_Article__kav where id=:topic.EntityId];        
	      	
	      	System.debug('PublishStatus(si es Online no se realizan cambios): ' +draft.PublishStatus);
	        
	        if(!draft.PublishStatus.equalsIgnoreCase('Online')){             
	            draft.KB_AssignedTopic__c=true;
	            update draft;
	        }
	    }    
    }
}