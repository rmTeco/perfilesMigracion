@isTest
public class ConfigurationExport_test {

    @isTest static void invokeConfigurationExport_OK(){

        String productId = insertProduct();

        Contact_Motive__c objContactMotive = new Contact_Motive__c();
        objContactMotive.Name = 'Test';
        objContactMotive.Description__c = 'Test';
        objContactMotive.Is_Active__c = true;
        objContactMotive.Id_Service__c = productId;
        objContactMotive.RecordTypeID = getRecordTypeIdByName('Contact_Motive');
        insert objContactMotive;
        
        Test.startTest();

        ApexPages.StandardController stdContactMotive = new ApexPages.StandardController(objContactMotive);
        ConfigurationExport objContactMotiveController = new ConfigurationExport(stdContactMotive);

        System.assertEquals(1, objContactMotiveController.services.size());
        System.assertEquals(1, objContactMotiveController.configuration.size());
        System.assertEquals(1, objContactMotiveController.motives.size());

        Test.stopTest();
    }

    @isTest static void invokeConfigurationExport_NoResults(){

        String productId = insertProduct();

        Contact_Motive__c objContactMotive = new Contact_Motive__c();
        objContactMotive.Name = 'Test';
        objContactMotive.Description__c = 'Test';
        objContactMotive.Is_Active__c = true;
        objContactMotive.Id_Service__c = productId;
        objContactMotive.RecordTypeID = getRecordTypeIdByName('Technical_Service_Symptom');
        insert objContactMotive;
        
        Test.startTest();

        ApexPages.StandardController stdContactMotive = new ApexPages.StandardController(objContactMotive);
        ConfigurationExport objContactMotiveController = new ConfigurationExport(stdContactMotive);

        System.assertEquals(1, objContactMotiveController.services.size());
        System.assertEquals(0, objContactMotiveController.configuration.size());
        System.assertEquals(0, objContactMotiveController.motives.size());

        Test.stopTest();
    }

    static String insertProduct(){
        Product2 prod = new Product2();

        prod.Name = 'Test-Internet';
        prod.Family = 'Service Plan';
        prod.IsActive = true;

        insert prod;

        return prod.Id;
    }

    static String getRecordTypeIdByName(string developerName){

        RecordType rec = [SELECT Id FROM RecordType WHERE DeveloperName = :developerName];

        return rec.Id;
    }
}