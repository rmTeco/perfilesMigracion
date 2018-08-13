trigger KB_updateArticleAssignedTopic on TopicAssignment (after update, after insert) {
 
    for(TopicAssignment topic : Trigger.New) {
        System.debug('topic.EntityId: ' +topic.EntityId);
        KB_Article__kav draft =[select KnowledgeArticleId, KB_AssignedTopic__c, PublishStatus from KB_Article__kav where id=:topic.EntityId];        
       
        if(!draft.PublishStatus.equalsIgnoreCase('Online')){             
            draft.KB_AssignedTopic__c=true;
            update draft;
        }
    }
}