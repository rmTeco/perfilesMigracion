@isTest
public class Mkt_CPDataManagerTest {

	static testmethod void invoquedMethodTest(){

		Contact contact = new Contact(FirstName = 'firstName', LastName = 'lastName', DocumentType__c = 'DNI', DocumentNumber__c = '44553333', Email = 'test@yopmail.com');
		insert contact;
		
		Id consumerRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Consumer' AND SobjectType = 'Account' LIMIT 1].Id;
	    Id businessRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Business' AND SobjectType = 'Account' LIMIT 1].Id;
	
	    Account ac = new Account (Name='New Test Consumer', RecordTypeId = consumerRecordTypeId, vlocity_cmt__PrimaryContactId__c = contact.Id, ClubMember__c = true, PersonalClubCategory__c = 'Classic');
	    Account ab = new Account (Name='New Test Business', RecordTypeId = businessRecordTypeId, vlocity_cmt__PrimaryContactId__c = contact.Id, ClubMember__c = true, PersonalClubCategory__c = 'Classic');
	    List<Account> accounts = new List<Account>();
	    accounts.add(ac);
	    accounts.add(ab);
		
		insert accounts;
		
	    Mkt_CPDataManager dataManager = new Mkt_CPDataManager();
	    Mkt_clubPersonalTab personalTab = new Mkt_clubPersonalTab();
	    Map<String,Object> inputMap = new Map<String,Object>();
	    Map<String,Object> outputMap = new Map<String,Object>();
	    Map<String,Object> options = new Map<String,Object>();
	    Map<String,Object> altaMap = new Map<String,Object>();
	    List<Map<String,Object>> accList = new List<Map<String,Object>>();
		List<Map<String,Object>> acbList = new List<Map<String,Object>>();
		Map<String,Object> consumer = new Map<String,Object>();
		Map<String,Object> business = new Map<String,Object>();

		consumer.put('Id',ac.Id);
		consumer.put('ClubCategory', 'Alta Reciente');
		accList.add(consumer);
		business.put('Id',ab.Id);
		business.put('ClubCategory', 'Alta Reciente');
		acbList.add(business);

	    inputMap.put('ContextId',ac.Id);
	    altaMap.put('businessAccounts', accList);
	    altaMap.put('consumerAccounts',acbList);
	    inputMap.put('AltaClubPersonal',altaMap);
	    inputMap.put('CPMembershipCancellation',altaMap);

	    Test.startTest();
	    dataManager.invokeMethod('getAccountsCP',inputMap,outputMap,options);
	    dataManager.invokeMethod('getUsersInfo',inputMap,outputMap,options);
	    dataManager.invokeMethod('createMembers',inputMap,outputMap,options);
	    personalTab.invokeMethod('getAccountHeader',inputMap,outputMap,options);
	    dataManager.invokeMethod('deleteMembers',inputMap,outputMap,options);
	    Test.stopTest();
	}
}