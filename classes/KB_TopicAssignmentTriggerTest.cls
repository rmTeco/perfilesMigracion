@isTest(seeAllData = false)
public class KB_TopicAssignmentTriggerTest {
	public KB_TopicAssignmentTriggerTest() {
		
	}

	static testmethod void validateUpdateTriggerTest(){
	
		KB_Article__kav article = new KB_Article__kav();
		article.Title='Test';
		article.UrlName='Test'+Integer.valueOf(Math.Random());
		insert article;

		Topic t = new Topic();
		t.Name='Test';
		t.Description='Test';
		insert t;

		TopicAssignment tAssigment = new TopicAssignment();
		tAssigment.TopicId= t.id;
		tAssigment.EntityId= article.id;

		Test.startTest();
		insert tAssigment;
		Test.stopTest();
		
	}

	static testmethod void validateDeleteTriggerTest() {
		KB_Article__kav article = new KB_Article__kav();
		article.Title='Test';
		article.UrlName='Test'+Integer.valueOf(Math.Random());
		insert article;

		Topic t = new Topic();
		t.Name='Test';
		t.Description='Test';
		insert t;

		TopicAssignment tAssigment = new TopicAssignment();
		tAssigment.TopicId= t.id;
		tAssigment.EntityId= article.id;
		insert tAssigment;

		Test.startTest();
		delete tAssigment;
		Test.stopTest();
	}
}