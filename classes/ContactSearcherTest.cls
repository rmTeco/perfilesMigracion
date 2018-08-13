@isTest(seeAllData = false)
public with sharing class ContactSearcherTest
{
	static testmethod void getClientsTest()
	{
		MockupFactory.generate();
		Account acc = [SELECT Id FROM Account LIMIT 1];
		acc.Phone = '1234567890';
		update acc;
		Map<String, Object> inputMap = new Map<String, Object>();
		Map<String, Object> outMap = new Map<String, Object>();
		Map<String, Object> options = new Map<String, String>();
		options.put('ContactFirstName', 'Contact First Name');
		options.put('ContactLastName', 'Contact LastName');
		options.put('AccountName', 'Sample Account');
		options.put('DocumentType', 'DNI');
		options.put('DocumentNumber', '12345678');
		options.put('AccountNumber', '1234');
		options.put('Email', 'test@yopmail.com');
		options.put('PhoneNumber', '1234567890');
		Test.startTest();
		ContactSearcher cs = new ContactSearcher();
		cs.invokeMethod('GetClients', inputMap, outMap, options);
		Test.stopTest();
	}
	static testmethod void getClientsBlankDocumentNumberTest()
	{
		MockupFactory.generate();
		Account acc = [SELECT Id FROM Account LIMIT 1];
		acc.Phone = '1234567890';
		update acc;
		Map<String, Object> inputMap = new Map<String, Object>();
		Map<String, Object> outMap = new Map<String, Object>();
		Map<String, Object> options = new Map<String, String>();
		options.put('ContactFirstName', 'Contact First Name');
		options.put('ContactLastName', 'Contact LastName');
		options.put('AccountName', 'Sample Account');
		options.put('DocumentType', 'DNI');
		options.put('DocumentNumber', '');
		options.put('AccountNumber', '1234');
		options.put('Email', 'test@yopmail.com');
		options.put('PhoneNumber', '1234567890');
		Test.startTest();
		ContactSearcher cs = new ContactSearcher();
		cs.invokeMethod('GetClients', inputMap, outMap, options);
		Test.stopTest();
	}
	static testmethod void getClientsErrorTest()
	{
		Test.startTest();
		ContactSearcher cs = new ContactSearcher();
		cs.invokeMethod('NotExistantMethod', null, null, null);
		Test.stopTest();
	}

	static testmethod void getClientsEmptyInputTest()
	{
		Test.startTest();
		ContactSearcher cs = new ContactSearcher();
		cs.invokeMethod('GetClients', null, null, null);
		Test.stopTest();
	}

	static testmethod void getClientsNoPhoneTest()
	{
		MockupFactory.generate();
		Map<String,Object> inputMap = new Map<String, Object>();
		Map<String, Object> outMap = new Map<String, Object>();
		Map<String, String> options = new Map<String, String>();
		String firstName = 'Contact First Name';
		String lastName = 'Contact LastName';
		String accountName = 'Sample Account';
		String documentType = 'DNI';
		String documentNumber = '12345678';
		String accountNumber = '1234';
		String email = 'test@yopmail.com';
		options.put('ContactFirstName', firstName);
		options.put('ContactLastName', lastName);
		options.put('AccountName', accountName);
		options.put('DocumentType', documentType);
		options.put('DocumentNumber', documentNumber);
		options.put('AccountNumber', accountNumber);
		options.put('Email', email);
		Contact contact = new Contact(FirstName = firstName, LastName = lastName, DocumentType__c = documentType, DocumentNumber__c = documentNumber, Email = email);
		insert contact;
		Test.startTest();
		ContactSearcher cs = new ContactSearcher();
		cs.invokeMethod('GetClients', inputMap, outMap, options);
		Test.stopTest();
	}

	static testmethod void getClientsNoPhoneNoDocumentTest()
	{
		MockupFactory.generate();
		Map<String,Object> inputMap = new Map<String, Object>();
		Map<String, Object> outMap = new Map<String, Object>();
		Map<String, String> options = new Map<String, String>();
		String firstName = 'Contact First Name';
		String lastName = 'Contact LastName';
		String accountName = 'Sample Account';
		String documentType = 'DNI';
		String documentNumber = '12345678';
		String accountNumber = '1234';
		String email = 'test@yopmail.com';
		options.put('ContactFirstName', firstName);
		options.put('ContactLastName', lastName);
		options.put('AccountName', accountName);
		//options.put('DocumentType', documentType);
		//options.put('DocumentNumber', documentNumber);
		options.put('AccountNumber', accountNumber);
		options.put('Email', email);
		Contact contact = new Contact(FirstName = firstName, LastName = lastName, DocumentType__c = documentType, DocumentNumber__c = documentNumber, Email = email);
		insert contact;
		Test.startTest();
		ContactSearcher cs = new ContactSearcher();
		cs.invokeMethod('GetClients', inputMap, outMap, options);
		Test.stopTest();
	}

	static testmethod void getNoNominatedLinesTest()
	{
		MockupFactory.generate();
		String phone = '1234567890';
		Asset asset = [SELECT Id, Account.Id FROM Asset WHERE MSISDN__c =: phone LIMIT 1];
		asset.MSISDN__c = '1234567890';
		update asset;
		
		Account acc = [SELECT Id, UnnamedCustomer__c FROM Account WHERE Id =: asset.Account.Id LIMIT 1];
		acc.UnnamedCustomer__c = true;
		update acc;
		
		Map<String, Object> outMap = new Map<String, Object>();
		Map<String, String> options = new Map<String, String>();
		options.put('PhoneNumber', phone);
		options.put('userAccountId', acc.Id);
		Test.startTest();
		ContactSearcher cs = new ContactSearcher();
		cs.invokeMethod('GetNoNominatedLines', null, outMap, options);
		acc.UnnamedCustomer__c =false;
		update acc;
		cs.invokeMethod('GetNoNominatedLines', null, outMap, options);
        asset.MSISDN__c='2';
        update asset;
		cs.invokeMethod('GetNoNominatedLines', null, outMap, options);
    
		Test.stopTest();
	}
	//(JARN) New metod test coverage (20/02/2018)
	static testmethod void getClientsNoPhoneTest2()
	{
		MockupFactory.generate();
		list<Asset> lstAsset = new list<Asset>();

		Account acc = [SELECT Id FROM Account LIMIT 1];
		acc.Phone = '1234567890';
		update acc;
		Map<String, Object> inputMap = new Map<String, Object>();
		Map<String, Object> outMap = new Map<String, Object>();
		Map<String, Object> options = new Map<String, String>();
		options.put('ContactFirstName', 'Contact First Name');
		options.put('ContactLastName', 'Contact LastName');
		options.put('AccountName', 'Sample Account');
		options.put('DocumentType', 'DNI');
		options.put('DocumentNumber', '12345678');
		options.put('AccountNumber', '1234');
		options.put('Email', 'test@yopmail.com');
		options.put('PhoneNumber', '1234567890');

		Asset objAsset = [SELECT Id FROM Asset LIMIT 1];
		//delete objasset;
		system.debug('===> '+objAsset);
		lstAsset.add(objAsset);
		Map<Id, List<Asset>> mapAssetsWithLine = new Map<Id, List<Asset>>();

		Test.startTest();
		ContactSearcher cs = new ContactSearcher();
		cs.invokeMethod('GetClients', inputMap, outMap, options);
		mapAssetsWithLine.put(objAsset.Id, lstAsset);
		Test.stopTest();
	}
/*
	static testmethod void GetContactsWhithOutAccountsContactDocumentTest()
	{
		MockupFactory.generate();

		Account acc = [SELECT Id FROM Account LIMIT 1];
		String contactFirstName = 'Contact NoAccount First Name';
		String contactLastName = 'Contact NoAccount LastName');
		String accountName = null;
		String documentType = 'DNI';
		String documentNumber = '12345699';
		String accountNumber = null;
		String email = 'testNoAccount@yopmail.com';
		String phone = null;
		List<Id> unfinishedAccounts = new List<Id>();
		unfinishedAccounts.add(acc.Id);
		Test.startTest();
		ContactSearcher cs = new ContactSearcher();
		List<Map<String, Object>> result = cs.GetContactsWhithOutAccounts(contactFirstName, contactLastName, phone, accountName, documentType,
    	documentNumber, accountNumber, email, unfinishedAccounts);
		Test.stopTest();
		system.assertEquals(result.size(),1);
	}

	static testmethod void GetContactsWhithOutAccountsContactNameTest()
	{
		MockupFactory.generate();

		Account acc = [SELECT Id FROM Account LIMIT 1];
		String contactFirstName = 'Contact NoAccount First Name';
		String contactLastName = 'Contact NoAccount LastName');
		String accountName = null;
		String documentType = null;
		String documentNumber = null;
		String accountNumber = null;
		String phone = null;
		String email = 'testNoAccount@yopmail.com';
		List<Id> unfinishedAccounts = new List<Id>();
		unfinishedAccounts.add(acc.Id);
		Test.startTest();
		ContactSearcher cs = new ContactSearcher();
		List<Map<String, Object>> result = cs.GetContactsWhithOutAccounts(contactFirstName, contactLastName, phone, accountName, documentType,
    	documentNumber, accountNumber, email, unfinishedAccounts);
		Test.stopTest();
		system.assertEquals(result.size(),1);
	}
	*/
}