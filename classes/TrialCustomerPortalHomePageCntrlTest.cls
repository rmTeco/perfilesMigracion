@istest
public class TrialCustomerPortalHomePageCntrlTest {
    
    static testMethod void method() { 
       User loggedInUser = [Select id,contactId,Contact.AccountId from User where id = :UserInfo.getUserId()];
    
       Id caseRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Diagnosis' AND SobjectType = 'Case' LIMIT 1].Id;
       Account acc = new Account(Name = 'testLagertha',Phone = '0800'); 
       insert acc;
  
       Asset ass = new Asset(Name = 'asset1', vlocity_cmt__LineNumber__c = '1234567890', AccountId = acc.Id);
       insert ass;
        
       Contact con = new Contact(FirstName = 'Ragnar', LastName = 'Lodbrok', Phone = '0900', MobilePhone = '0400', Email = 'ragnar.lodbrok@gmail.com');
       con.AccountId = acc.Id;  //account id 
       insert con;
        
       Case test_case = new Case(Subject = 'test_subject_vikings', AccountID = acc.Id, ContactId = loggedInUser.ContactId, Status = 'Nueva', Origin = 'Telefónico', RecordTypeId = caseRecordTypeId);
       insert test_case;
       
       system.debug('loggedInUser: ' + loggedInUser);
       system.debug('con : ' + con );
       
        Product2 prod = new Product2(
            Name = 'TestProduct', 
            IsActive = true, 
            ProductCode = 'FAN_PRDA_00001',
            vlocity_cmt__IsOrderable__c = true, 
            vlocity_cmt__Status__c = 'Active', 
            vlocity_cmt__SpecificationType__c = 'Offer',
            RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId());
       insert prod;
        
       Solution sol = new Solution(SolutionName = 'TestSolution');
       insert sol;
        
       List<Community> cm = [SELECT Id FROM Community];
        
       Idea ideas = new Idea(Title = 'Titulo', CommunityId = cm[0].Id);
       insert ideas;
       Test.StartTest();
       TrialCustomerPortalHomePageController tcPortal = new TrialCustomerPortalHomePageController();
       tcPortal.sortField1 = 'Name';
       tcPortal.SortProducts();
        tcPortal.sortField3 = 'SolutionName';
       tcPortal.SortSolutions();
        tcPortal.sortField4 = 'Title';
       tcPortal.SortIdeas();
        tcPortal.sortField2 = 'CaseNumber';
       tcPortal.SortCases();
       Test.StopTest();
     }
}