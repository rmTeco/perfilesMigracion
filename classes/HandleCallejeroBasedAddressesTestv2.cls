@isTest 
private class HandleCallejeroBasedAddressesTestv2 {

      @testSetup static void setup() {
           //account,contact,zone,street,location,range
           List<Account> AccList = TestDataFactory.createAccounts(1);
           List<Contact> ConList = TestDataFactory.createContacts(1,AccList[0]);
           Location__c LOC = new Location__c(Name='TestLoc',StateCode__c='B', LocationCode__c='A000');
           insert LOC;
           Street__c Street = new Street__c(Location__c=LOC.id, Name='TestStreet', Postal_Code__c='1744', Range_From__c= 200.0, Range_To__c=250.0, StreetCode__c='B16030016');
           insert Street;
           Zones__c Zone = new Zones__c(AddressNumber__c=220.0, Location__c=LOC.id, Street__c=Street.id, ZoneID__c='54563', ZoneType__c='2');
           insert Zone;
           
      }
              
      static testMethod void UpsertToAddress2Test() {
      
          List<Account> AccList = [Select id from Account];
          List<Contact> ConList = [Select id from Contact];
          List<Location__c> Location = [Select id from Location__c]; 
          List<Street__c> Street = [Select id from Street__c]; 
          List<Zones__c> Zone = [Select id from Zones__c]; 
           
          Map<String,Object> testoptions = new Map<String,Object>();
          Map<String,Object> testinputmap = new Map<String,Object>();
          Map<String,Object> testoutputmap = new Map<String,Object>();
          
          testoptions.put('State', 'B');
          testoptions.put('LocationTypeAhead', Location[0].id);
          testoptions.put('StreetTypeAhead', Street[0].id);
          testoptions.put('ZoneTypeAhead', Zone[0].id);
          testoptions.put('TypeOfAddress', 'Billing Address');
          testoptions.put('AccountId', AccList[0].id);
          
          HandleCallejeroBasedAddresses ctrl = new HandleCallejeroBasedAddresses();
          ctrl.invokemethod('UpsertToAddress2',testinputmap, testoutputmap, testoptions );
          
          testoptions = new Map<String,Object>();
          
          testoptions.put('State', 'B');
          testoptions.put('LocationName', 'Test Location');
          testoptions.put('StreetName', 'Test Street');
          testoptions.put('ZoneName', 'Test Zone');
          testoptions.put('TypeOfAddress', 'Legal Address');
          testoptions.put('AccountId', AccList[0].id);
          
          ctrl.invokemethod('UpsertToAddress2',testinputmap, testoutputmap, testoptions );
          
          testoptions = new Map<String,Object>();
          
          testoptions.put('State', 'B');
          testoptions.put('LocationName', 'Test Location');
          testoptions.put('StreetName', 'Test Street');
          testoptions.put('ZoneName', 'Test Zone');
          testoptions.put('TypeOfAddress', 'Service Address');
          testoptions.put('AccountId', AccList[0].id);
          
          ctrl.invokemethod('UpsertToAddress2',testinputmap, testoutputmap, testoptions );
          
          testoptions = new Map<String,Object>();
           
          testoptions.put('State', 'B');
          testoptions.put('LocationTypeAhead', Location[0].id);
          testoptions.put('StreetTypeAhead', Street[0].id);
          testoptions.put('ZoneTypeAhead', Zone[0].id);
          testoptions.put('TypeOfAddress', 'Mailing Address');
          testoptions.put('ContactId', ConList[0].id);
          
          ctrl.invokemethod('UpsertToAddress2',testinputmap, testoutputmap, testoptions );
          
          testoptions = new Map<String,Object>();
          
          testoptions.put('State', 'B');
          testoptions.put('LocationName', 'Test Location');
          testoptions.put('StreetName', 'Test Street');
          testoptions.put('ZoneName', 'Test Zone');
          testoptions.put('TypeOfAddress', 'Billing Address');
          testoptions.put('ContactId', ConList[0].id);
          
          ctrl.invokemethod('UpsertToAddress2',testinputmap, testoutputmap, testoptions );
           
      }
      
      static testMethod void DeleteAddress2Test() {
          List<Account> AccList = [Select id from Account];
          List<Contact> ConList = [Select id from Contact];
          List<Location__c> Location = [Select id from Location__c]; 
          List<Street__c> Street = [Select id from Street__c]; 
          List<Zones__c> Zone = [Select id from Zones__c]; 
           
          Map<String,Object> testoptions = new Map<String,Object>();
          Map<String,Object> testinputmap = new Map<String,Object>();
          Map<String,Object> testoutputmap = new Map<String,Object>();
          
          testoptions.put('State', 'B');
          testoptions.put('LocationTypeAhead', Location[0].id);
          testoptions.put('StreetTypeAhead', Street[0].id);
          testoptions.put('ZoneTypeAhead', Zone[0].id);
          testoptions.put('TypeOfAddress', 'Billing Address');
          testoptions.put('AccountId', AccList[0].id);
          
          HandleCallejeroBasedAddresses ctrl = new HandleCallejeroBasedAddresses();
          ctrl.invokemethod('UpsertToAddress2',testinputmap, testoutputmap, testoptions );
          
          testoptions = new Map<String,Object>();
          testoptions.put('Address2Id', testoutputmap.get('Address2Id'));
          ctrl.invokemethod('DeleteAddressfromAddress2',testinputmap, testoutputmap, testoptions );
          
      }
      
      static testMethod void UIAddressHelper_StreetTest() {
      
          List<Account> AccList = [Select id from Account];
          List<Contact> ConList = [Select id from Contact];
          List<Location__c> Location = [Select id from Location__c]; 
          List<Street__c> Street = [Select id from Street__c]; 
          List<Zones__c> Zone = [Select id from Zones__c]; 
           
          Map<String,Object> testoptions = new Map<String,Object>();
          Map<String,Object> testinputmap = new Map<String,Object>();
          Map<String,Object> testoutputmap = new Map<String,Object>();
          
          testoptions.put('LocationId', Location[0].id);
          testoptions.put('StreetName', 'Test');
          
          HandleCallejeroBasedAddresses ctrl = new HandleCallejeroBasedAddresses();
          ctrl.invokemethod('UIAddressHelper_street',testinputmap, testoutputmap, testoptions );
          
         
      
      
      }
      
      static testMethod void UIAddressHelper_ZoneTest() {
      
          List<Account> AccList = [Select id from Account];
          List<Contact> ConList = [Select id from Contact];
          List<Location__c> Location = [Select id from Location__c]; 
          List<Street__c> Street = [Select id from Street__c]; 
          List<Zones__c> Zone = [Select id from Zones__c]; 
           
          Map<String,Object> testoptions = new Map<String,Object>();
          Map<String,Object> testinputmap = new Map<String,Object>();
          Map<String,Object> testoutputmap = new Map<String,Object>();
          
          testoptions.put('LocationId', Location[0].id);
          testoptions.put('zonename', 'Test');
          
          HandleCallejeroBasedAddresses ctrl = new HandleCallejeroBasedAddresses();
          ctrl.invokemethod('UIAddressHelper_zone',testinputmap, testoutputmap, testoptions );
          
      }
    
    
    
 }