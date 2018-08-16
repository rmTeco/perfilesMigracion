@isTest(seeAllData = false)
public with sharing class KB_KnowledgeViewController_Test {
	
	
	static testmethod void searchTest() {
		KB_Article__kav article = new KB_Article__kav();
		article.Title='Test';
		article.UrlName='Test'+Integer.valueOf(Math.Random());
		insert article;

		System.debug('article: ' +article);

		article=[Select id, KnowledgeArticleId, Title, Summary, UrlName, KB_Body__c, KB_Attachment__Body__s, KB_Attachment__Length__s, KB_Attachment__ContentType__s, KB_Attachment__Name__s from KB_Article__kav WHERE Title='Test' and PublishStatus='Draft' and id=: article.id limit 1];

		KbManagement.PublishingService.publishArticle(article.KnowledgeArticleId, false);

		Test.startTest();

		KB_KnowledgeViewController test_KnowledgeViewController = new KB_KnowledgeViewController();
		PageReference pageRef = Page.KB_KnowledgeView;
		pageRef.getParameters().put('id', String.valueOf(article.KnowledgeArticleId));
		Test.setCurrentPage(pageRef);
		test_KnowledgeViewController.search();
		Test.stopTest();
	}

}