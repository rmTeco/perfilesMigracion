@isTest(seeAllData = false)
public with sharing class KB_MassInsertTopics_Test {

	public KB_MassInsertTopics_Test(){
		generateTopicAssigmentTest();
		searchFileTest();
	}

	static testmethod void generateTopicAssigmentTest(){
		KB_Article__kav article = new KB_Article__kav();
		article.Title='TestKB';
		article.UrlName='Test'+Integer.valueOf(Math.Random());
		insert article;
		article=[Select id, KnowledgeArticleId, Title, Summary, UrlName, KB_Body__c, KB_Attachment__Body__s, KB_Attachment__Length__s, KB_Attachment__ContentType__s, KB_Attachment__Name__s from KB_Article__kav WHERE PublishStatus='Draft' and id=: article.id limit 1 UPDATE VIEWSTAT];
		KbManagement.PublishingService.publishArticle(article.KnowledgeArticleId, false);

		KB_MassInsertTopics massInsert= new KB_MassInsertTopics();

		String bodyTopic='TestTopic'+Integer.valueOf(Math.Random())+';TestKB'; 

		Test.startTest();
		massInsert.generateTopicAssigment(bodyTopic);
		Test.stopTest();
	}

	static testmethod void searchFileTest(){
		Test.startTest();
		KB_MassInsertTopics massInsert= new KB_MassInsertTopics('Test');
		Test.stopTest();
	}
}