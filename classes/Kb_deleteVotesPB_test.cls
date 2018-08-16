@isTest(seeAllData = false)
public with sharing class Kb_deleteVotesPB_test {
	
	public Kb_deleteVotesPB_test() {
		getKnowledgeArticleId();
	}

	static testmethod void getKnowledgeArticleId(){
    	
        	KB_Article__kav article = new KB_Article__kav();
        	article.Title='Test1';
        	article.UrlName='Test1'+Integer.valueOf(Math.Random());
        	insert article;
        	article=[Select id, KnowledgeArticleId, Title, Summary, UrlName, KB_Body__c, KB_Attachment__Body__s, KB_Attachment__Length__s, KB_Attachment__ContentType__s, KB_Attachment__Name__s from KB_Article__kav WHERE PublishStatus='Draft' and id=: article.id limit 1];
        	KbManagement.PublishingService.publishArticle(article.KnowledgeArticleId, false);

        	Vote vote= new Vote();
        	vote.ParentId=article.KnowledgeArticleId;
        	vote.Type='UP';
        	insert vote;

        	KbManagement.PublishingService.editOnlineArticle(article.KnowledgeArticleId, true);

        	List<String> urlNames=new List<String>();
        	urlNames.add(article.UrlName);
        	Test.startTest();
        	Kb_deleteVotesPB.deleteVotes(urlNames);
        	Test.stopTest();
    }
}