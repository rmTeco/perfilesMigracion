@isTest
private class ChatterAnswersEscalationTriggerTest {
	static testMethod void validateQuestionEscalation() {
		String questionTitle = 'questionTitle';
		String questionBody = 'questionBody';
		Community[] c = [SELECT Id from Community];
		// We cannot create a question without a community
		if (c.size() == 0) { return; }
		String communityId = c[0].Id;
		/*Question q = new Question(
		Title = questionTitle,
		Body = questionBody,
		CommunityId = communityId);
		insert(q);
		q.Priority = 'high';
		update(q);*/
		List<Case> ca = [SELECT Origin, Subject, Description from Case];
		// Test that escaltion trigger correctly escalate the question to a case
		/*System.assertEquals(questionTitle, ca.Subject);
		System.assertEquals(questionBody, ca.Description);
		System.assertEquals('Chatter Answers', ca.Origin);*/
	}
    
    static testMethod void testChatterAnswers() {
		String jubilado = 'Jubilado';
        String estrategico = 'Estratégico';
        String menor = 'Menor';
        String vip = 'VIP';
        String prensa = 'Prensa';
        String account = 'Account';
        String contact = 'Contact';
        String socioClub = 'Socio Club';
        
        String userId = UserInfo.getUserId();
        Id userProfileId = Id.valueOf(UserInfo.getProfileId());
        Profile userProfile = [SELECT Name FROM Profile WHERE Id = :userProfileId];

        AttributesWeighing__c aw1 = new AttributesWeighing__c(Name = 'aw1', Attribute__c = jubilado, Object__c = account, Weighing__c = 1);
        AttributesWeighing__c aw2 = new AttributesWeighing__c(Name = 'aw2', Attribute__c = estrategico, Object__c = account, Weighing__c = 2);
        AttributesWeighing__c aw3 = new AttributesWeighing__c(Name = 'aw3', Attribute__c = menor, Object__c = account, Weighing__c = 3);
        AttributesWeighing__c aw4 = new AttributesWeighing__c(Name = 'aw4', Attribute__c = vip, Object__c = contact, Weighing__c = 4);
        AttributesWeighing__c aw5 = new AttributesWeighing__c(Name = 'aw5', Attribute__c = prensa, Object__c = contact, Weighing__c = 5);
        AttributesWeighing__c att1 = new AttributesWeighing__c(Name = '01', Object__c = account, Attribute__c = socioClub, Weighing__c = 6);
        AttributesWeighing__c aw6 = new AttributesWeighing__c(Name = 'aw6', Attribute__c = estrategico, Object__c = contact, Weighing__c = 7);
        AttributesByProfile__c ab1 = new AttributesByProfile__c(AccountAttributes__c = (jubilado + '; ' + estrategico + '; ' + menor + '; ' + socioClub), ContactAttributes__c = (vip + '; ' + estrategico + ';' + prensa), SetupOwnerId = userProfile.Id);
        
        Test.startTest();

        Database.Insert(aw1);
        Database.Insert(aw2);
        Database.Insert(aw3);
        Database.Insert(aw4);
        Database.Insert(att1);
        Database.Insert(aw5);
        Database.Insert(aw6);
        Database.Insert(ab1);

        Contact contact1 = new Contact(LastName='Contact1', Attributes__c = vip);
        Database.Insert(contact1);

        ChatterAnswers ca = new ChatterAnswers();
        ca.createAccount('current1', 'test', userid);

	}
}