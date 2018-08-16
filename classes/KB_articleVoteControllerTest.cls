@isTest(seeAllData = false)
public with sharing class KB_articleVoteControllerTest {

    public KB_articleVoteControllerTest() {
        itemsTest();
    	sendMailTest();
        changeRatingTest();
    }
    static String getKnowledgeArticleId(){
    	
        KB_Article__kav article = new KB_Article__kav();
        article.Title='Test';
        article.UrlName='Test'+Integer.valueOf(Math.Random());
        try{
        	insert article;
        	article=[Select id, KnowledgeArticleId from KB_Article__kav WHERE PublishStatus='Draft' and id=: article.id limit 1];
        	KbManagement.PublishingService.publishArticle(article.KnowledgeArticleId, false);
        }catch(exception e){
        	article=[Select id, KnowledgeArticleId from KB_Article__kav WHERE Title='Test' limit 1];
        }
        
        return article.KnowledgeArticleId;
    }

    static testmethod void itemsTest() {
        insert new KB_vote_down_option__c(Name='Value', Label__c = 'Value');
        KB_articleVoteController controller = new KB_articleVoteController();
        Test.startTest();
        controller.getItems();
        Test.stopTest();
    }

    static testmethod void sendMailTest(){
        insert new KB_email_List__c(Name='emails', to__c = 'mailfalso@123.com');
        Test.startTest();
        KB_articleVoteController.sendMail('comment', 'option', KB_articleVoteControllerTest.getKnowledgeArticleId());
        Test.stopTest();
    }

    static testmethod void changeRatingTest(){
        Test.startTest();
        KB_articleVoteController.changeRating(KB_articleVoteControllerTest.getKnowledgeArticleId(), 'UP' );
        KB_articleVoteController.changeRating(KB_articleVoteControllerTest.getKnowledgeArticleId(), 'Down' );
        Test.stopTest();
    }

}