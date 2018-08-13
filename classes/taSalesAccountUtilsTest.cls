@isTest
public  class taSalesAccountUtilsTest
{
    public static testmethod void GeneralExceptionTest()   
    {
        Map<String,Object> inputMap = new Map<String, Object>();
    Map<String,Object> options = new Map<String, Object>();
      Map<String,Object> outputMap = new Map<String, Object>();
        Test.startTest();
        taSalesAccountUtils tSAu = new taSalesAccountUtils();
    tSAu.invokeMethod('removeAddress', inputMap, outputMap, options);
        Test.stopTest();      
    }

    public static testmethod void getAuthorizedContactsTest()  
    {
        MockupFactory.generate();
        Map<String,Object> inputMap = new Map<String, Object>();
    Map<String,Object> options = new Map<String, Object>();
      Map<String,Object> outputMap = new Map<String, Object>();
        Order ord = [SELECT Id FROM Order LIMIT 1];
    options.put('IdOrder', ord.Id);
        options.put('PostOfficeFlag', 'SI');
        //ContactNodeName
         options.put('ContactNodeName', 'Contact');
        Test.startTest();
        ord.vlocity_cmt__ShippingName__c = '{"ShippingName" : "123"}';
        update ord;
        taSalesAccountUtils tSAu = new taSalesAccountUtils();
    tSAu.invokeMethod('getAuthorizedContacts', inputMap, outputMap, options);
        Test.stopTest();
    }

    public static testmethod void getAuthorizedContactsListTest()  
    {
        MockupFactory.generate();
        Map<String,Object> inputMap = new Map<String, Object>();
    Map<String,Object> options = new Map<String, Object>();
      Map<String,Object> outputMap = new Map<String, Object>();
        Order ord = [SELECT Id FROM Order LIMIT 1];
    options.put('IdOrder', ord.Id);
        options.put('PostOfficeFlag', 'NO');
        //ContactNodeName
         options.put('ContactNodeName', 'Contact');
        Test.startTest();
        ord.vlocity_cmt__ShippingName__c = '[{"ShippingName" : "123"},{"ShippingName" : "456"}]';
        update ord;
        taSalesAccountUtils tSAu = new taSalesAccountUtils();
    tSAu.invokeMethod('getAuthorizedContacts', inputMap, outputMap, options);
        Test.stopTest();
    }

     public static testmethod void getAccountAddressesTest()       
    {
        Map<String,Object> inputMap = new Map<String, Object>();
    Map<String,Object> options = new Map<String, Object>();
      Map<String,Object> outputMap = new Map<String, Object>();
      
    Id usId = userinfo.getUserId();
    TestDataFactory.setTeamMember('Test', usId, null); 
        List<Account> accs = TestDataFactory.createAccounts(1, 'Consumer');
    List<Order> ord2 = TestDataFactory.createOrders(2, accs[0]);
    
    ord2[0].AddressHidden__c = false;
    ord2[0].ShippingPostalCode = '1900';
        ord2[1].AddressHidden__c = false;
    ord2[1].ShippingPostalCode = '1900';
    upsert ord2;
    
        Order ord = [SELECT Id FROM Order LIMIT 1];
    options.put('accountId', accs[0].Id);
        options.put('PostOfficeFlag', 'NO');
        //ContactNodeName
         options.put('ContactNodeName', 'Contact');
        Test.startTest();
        taSalesAccountUtils tSAu = new taSalesAccountUtils();
    tSAu.invokeMethod('getAccountAddresses', inputMap, outputMap, options);
        Test.stopTest();
        
    }

     public static testmethod void removeAddressTest()   
    {
        MockupFactory.generate();
        Map<String,Object> inputMap = new Map<String, Object>();
    Map<String,Object> options = new Map<String, Object>();
      Map<String,Object> outputMap = new Map<String, Object>();
        Order ord = [SELECT Id FROM Order LIMIT 1];
    options.put('IdOrder', ord.Id);
        options.put('PostOfficeFlag', 'NO');
        //ContactNodeName
        Map<String, Object> ShippingAddressData = new Map<String, Object>();
        Map<String, Object> Address = new Map<String, Object>();
        List<Object> ids = new  List<Object>();
        ids.add(ord.Id);
        Address.put('Ids',ids );
        ShippingAddressData.put('Address', Address);
        inputMap.put('ShippingAddressData', ShippingAddressData);
         options.put('ContactNodeName', 'Contact');
        Test.startTest();
        taSalesAccountUtils tSAu = new taSalesAccountUtils();
    tSAu.invokeMethod('removeAddress', inputMap, outputMap, options);
        Test.stopTest();
        
    }

    public static testmethod void saveAuthorizedContactsTest()   
    {
         MockupFactory.generate();
        Map<String,Object> inputMap = new Map<String, Object>();
    Map<String,Object> options = new Map<String, Object>();
      Map<String,Object> outputMap = new Map<String, Object>();
        Order ord = [SELECT Id FROM Order LIMIT 1];
    options.put('IdOrder', ord.Id);
        options.put('PostOfficeFlag', 'NO');
        //ContactNodeName
         options.put('ContactNodeName', 'Contact');
        Test.startTest();
        taSalesAccountUtils tSAu = new taSalesAccountUtils();
    tSAu.invokeMethod('saveAuthorizedContacts', inputMap, outputMap, options);
        Test.stopTest(); 
    }

    public static testmethod void saveAuthorizedContactsListTest()   
    {
        MockupFactory.generate();
        Map<String,Object> inputMap = new Map<String, Object>();
    Map<String,Object> options = new Map<String, Object>();
      Map<String,Object> outputMap = new Map<String, Object>();
        List<Object> authorizedContactsList = new List<Object>();
        authorizedContactsList.add('123');
        authorizedContactsList.add('456');
        Order ord = [SELECT Id FROM Order LIMIT 1];
    options.put('IdOrder', ord.Id);
        options.put('AuthorizedContacts', authorizedContactsList);
        Test.startTest();
        taSalesAccountUtils tSAu = new taSalesAccountUtils();
    tSAu.invokeMethod('saveAuthorizedContacts', inputMap, outputMap, options);
        Test.stopTest();
        ord = [SELECT Id, vlocity_cmt__ShippingName__c FROM Order LIMIT 1];
        system.assertEquals(ord.vlocity_cmt__ShippingName__c,'["123","456"]');
    }

    public static testmethod void compareToNotEqualTest()   
    {
        MockupFactory.generate();
        Order ord = [SELECT Id, ShippingAditionalInformation__c, ShippingCity, ShippingApartment__c, ShippingFloor__c, ShippingPostalCode, ShippingStreet1__c, ShippingStreet2__c, ShippingStateCode, ShippingStreet__c, ShippingStreetNumber__c, vlocity_cmt__ShippingState__c FROM Order LIMIT 1];
        taSalesAccountUtils.OrderAddress address = new taSalesAccountUtils.OrderAddress(ord);
        taSalesAccountUtils.OrderAddress address2 = new taSalesAccountUtils.OrderAddress(ord);
        address.orderString = '123';
        address2.orderString = '1234';
        Test.startTest();
        Integer result = address.compareTo(address2);
        Test.stopTest();
        system.assertEquals(result,1);
    }

    public static testmethod void compareToEqualTest()   
    {
        MockupFactory.generate();
        Order ord = [SELECT Id, ShippingAditionalInformation__c, ShippingCity, ShippingApartment__c, ShippingFloor__c, ShippingPostalCode, ShippingStreet1__c, ShippingStreet2__c, ShippingStateCode, ShippingStreet__c, ShippingStreetNumber__c, vlocity_cmt__ShippingState__c FROM Order LIMIT 1];
        taSalesAccountUtils.OrderAddress address = new taSalesAccountUtils.OrderAddress(ord);
        taSalesAccountUtils.OrderAddress address2 = new taSalesAccountUtils.OrderAddress(ord);
        address.orderString = '123';
        address2.orderString = '123';
        Test.startTest();
        Integer result = address.compareTo(address2);
        Test.stopTest();
        system.assertEquals(result,0);
    }
    
}