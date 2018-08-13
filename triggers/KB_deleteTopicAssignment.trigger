trigger KB_deleteTopicAssignment on TopicAssignment (before delete) {
    
    for(TopicAssignment topic : Trigger.Old) {
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
               // topic.Id.addError(Label.KB_error_topics,false);
                Trigger.oldMap.get(topic.Id).addError(Label.KB_error_topics );
            }
        }
    }
}