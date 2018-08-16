@isTest
public class taSalesLogValidationIdentityExtTest {
    
    @isTest static void constructorTest(){
    	Account acc = TestDataFactory.createAccounts(1,'Consumer')[0];
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        Order ord = TestDataFactory.createOrders(1, acc)[0];
        Date newDate = Date.today();
        
        Crossobject__c crossObjectTest = new Crossobject__c( 
            PickList1__c = 'Document',
          	DateTime1__c = newDate, 
            Account__c = acc.Id,  
            Checkbox1__c = true,
            RecordTypeId = '0126C0000000AKJQA2',
            Order__c = ord.Id
        );
        insert crossObjectTest;
        
        System.debug(crossObjectTest + 'here testing1');
        
		ApexPages.StandardController stdLead = new ApexPages.StandardController(ord);  
        taSalesLogValidationIdentityExtension testClass = new taSalesLogValidationIdentityExtension(stdLead);

		System.assertEquals(testClass.logs[0].Id, crossObjectTest.Id);
        
    }
}