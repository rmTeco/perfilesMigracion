public with sharing class Kb_deleteVotesPB {
	
    @InvocableMethod(label='KB_deleteVotes' description='delete votes of ArticleId.')
    public static void deleteVotes(List<String> urlNames ){ 
        System.debug('deleteVotes: ' +urlNames); 
        
        if(!urlNames.isEmpty()){

        	try{
        		List <KB_Article__kav> articlesList= [Select Id, KnowledgeArticleId, KB_BorrarVotos__c  from KB_Article__kav where UrlName =: urlNames.get(0) and PublishStatus ='Draft'];
        		KB_Article__kav art=articlesList.get(0);

        		art.KB_BorrarVotos__c=false;
            	UPDATE art;

        		List<Vote>votes =[SELECT Id FROM Vote where PARENTID =:art.KnowledgeArticleId];
            	DELETE votes;

            	KbManagement.PublishingService.publishArticle(art.KnowledgeArticleId, true); 
            	System.debug('articulo: ' +art); 

            }catch(Exception e){
            	System.debug('KB_deleteVotes ERROR: ' +e.getMessage());
            }
        }
        
    }

}