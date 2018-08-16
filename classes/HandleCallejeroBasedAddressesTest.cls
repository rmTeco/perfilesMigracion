@isTest 
private class HandleCallejeroBasedAddressesTest {

      @testSetup static void setup() {
       //account,contact,zone,street,location,range
       List<Account> AccList = TestDataFactory.createAccounts(1);
       List<Contact>ConList = TestDataFactory.createContacts(1,AccList[0]);
       Location__c LOC = new Location__c(Name='TestLoc',StateCode__c='B', LocationCode__c='A000');
       insert LOC;
       Street__c Street = new Street__c(Location__c=LOC.id, Name='TestStreet', Postal_Code__c='1744', Range_From__c= 200.0, Range_To__c=250.0, StreetCode__c='B16030016');
       insert Street;
       Zones__c Zone = new Zones__c(AddressNumber__c=220.0, Location__c=LOC.id, Street__c=Street.id, ZoneID__c='54563', ZoneType__c='2');
       insert Zone;
       Address2__c address = new Address2__c (Location_ID__c = LOC.id, Location_Name__c ='TestLoc', Province__c ='B', Street_ID__c=Street.id, Street_Name__c='TestStreet', Zone_ID__c = Zone.id, Zone_Name__c='TestZone');
        }
              
     
    
    static testMethod void ValidateAddressTest() {
    Map<String,Object> options = new Map<String,Object> ();
    Map<String,Object> Inputmap = new Map<String,Object> ();
    Map<String,Object> OutMap = new Map<String,Object> ();
    
    
 Location__c LOC = [select id,name,StateCode__c, LocationCode__c from Location__c];
 Street__c Street = [select id,Location__c, Name, Postal_Code__c, Range_From__c, Range_To__c, StreetCode__c from street__c];
 Zones__c Zone = [select id,name,AddressNumber__c, Location__c, Street__c, ZoneID__c, ZoneType__c from Zones__c];
 options.put('Province','b');
 options.put('LocationId',LOC.id);
 options.put('LocationName',LOC.Name);
 options.put('StreetId',Street.id);
 options.put('StreetName',street.name);
 options.put('RangeId',Street.id);
 options.put('AddressNumber','220.0');
 options.put('ZipCode','1744');
 options.put('ZoneId',Zone.id);
 options.put('ZoneName',Zone.name);
 
 HandleCallejeroBasedAddresses HCB = new HandleCallejeroBasedAddresses();
 HCB.invokeMethod('ValidateAddress', Inputmap, OutMap, options);
 options.put('LocationId',null);
 HCB.invokeMethod('ValidateAddress', Inputmap, OutMap, options);
 options.put('StreetId','null');
 HCB.invokeMethod('ValidateAddress', Inputmap, OutMap, options);
 options.put('ZoneId','null');
 HCB.invokeMethod('ValidateAddress', Inputmap, OutMap, options);
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
          
 /*         testoptions = new Map<String,Object>();
          
          testoptions.put('State', 'B');
          testoptions.put('LocationName', 'Test Location');
          testoptions.put('StreetName', 'Test Street');
          testoptions.put('ZoneName', 'Test Zone');
          testoptions.put('TypeOfAddress', 'Legal Address');
          testoptions.put('AccountId', AccList[0].id);
          
          ctrl.invokemethod('UpsertToAddress2',testinputmap, testoutputmap, testoptions );
 */         
 /*         testoptions = new Map<String,Object>();
          
          testoptions.put('State', 'B');
          testoptions.put('LocationName', 'Test Location');
          testoptions.put('StreetName', 'Test Street');
          testoptions.put('ZoneName', 'Test Zone');
          testoptions.put('TypeOfAddress', 'Service Address');
          testoptions.put('AccountId', AccList[0].id);
          
          ctrl.invokemethod('UpsertToAddress2',testinputmap, testoutputmap, testoptions );
  */        
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