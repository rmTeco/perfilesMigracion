public with sharing class KB_MassInsertTopics {
    
    public KB_MassInsertTopics() {}

	public KB_MassInsertTopics(String nameFile) {
    
        generateTopicAssigment(searchFile(nameFile));
	}

    public String searchFile(String nameFile){
        try{
            StaticResource resource = [SELECT Id, SystemModStamp, Name, Body FROM StaticResource WHERE Name = :nameFile LIMIT 1];
            return resource.Body.toString(); 
        } catch(exception e){
            System.debug('ERROR: query not found: SELECT Id, SystemModStamp, Name, Body FROM StaticResource WHERE Name = :nameFile LIMIT 1');
        }
        return null;
    }

    public void generateTopicAssigment(String bodyTopic){
        if(String.isNotEmpty(bodyTopic)){
            Map<String,List<String>> topic_KB=new Map<String,List<String>>(); 
            List<String> listTopics = new List<String>();
            List<TopicAssignment>assigList=new List<TopicAssignment>(); 
            String[] csvfilelines = bodyTopic.split('\n');
                    
            for(Integer i=0;i<csvfilelines.size();i++){
                string[] csvRecordData = csvfilelines[i].split(';');
                string listKBTitle=(EncodingUtil.urlEncode(csvRecordData[1], 'UTF-8'));
                listKBTitle=listKBTitle.removeEnd('%0D');
                listKBTitle=(EncodingUtil.urlDecode(listKBTitle, 'UTF-8'));
                topic_KB.put(csvRecordData[0],listKBTitle.split(','));
                listTopics.add(csvRecordData[0]);
            }       
            
            for(String titleTopic : listTopics){
                Topic topic;
                try{
                    topic=[select Id from Topic Where Name=:titleTopic Limit 1];
                } catch(exception e){
                    topic=new Topic();
                    topic.Name= titleTopic;
                    insert topic;
                }
                try{
                    for (KB_Article__kav article:[select Id from KB_Article__kav where Title in : topic_KB.get(titleTopic)]){
                        TopicAssignment assignment = new TopicAssignment();
                        assignment.TopicId=topic.Id;
                        assignment.EntityId=article.Id;
                        assigList.add(assignment);
                    }
                } catch(exception e){
                    System.debug('ERROR: query not found: select Id from KB_Article__kav where Title in : '+topic_KB.get(titleTopic));
                }
            }
            insert assigList;
        }
    }
}