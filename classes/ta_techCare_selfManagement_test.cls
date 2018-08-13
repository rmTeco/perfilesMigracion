@isTest
public class ta_techCare_selfManagement_test{
    
    @isTest
    static void testGetChannels(){
        String methodName = 'GetChannels';

        Id rctId = Schema.SObjectType.Contact_Motive__c.getRecordTypeInfosByName().get('Service Incident').getRecordTypeId();

        insert new Contact_Motive__c(
            RecordTypeId = rctId,
            Is_Active__c = true,
            Channel__c = 'canal',
            Service__c = 'service'
        );

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        Test.startTest();
        Ta_techCare_selfManagement testClass = new Ta_techCare_selfManagement();
        testClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        List<Map<String,String>> outOptions = (List<Map<String,String>>) outMap.get('options');

        System.assertEquals(1, outOptions.size());
    }

    @isTest
    static void testGetServicess(){
        String methodName = 'GetServices';

        Id rctId = Schema.SObjectType.Contact_Motive__c.getRecordTypeInfosByName().get('Service Incident').getRecordTypeId();

        List<Contact_Motive__c> cmlist = new List<Contact_Motive__c>();

        cmList.add(new Contact_Motive__c(
            RecordTypeId = rctId,
            Is_Active__c = true,
            Channel__c = 'canal',
            Service__c = 'service'
        ));

        cmList.add(new Contact_Motive__c(
            RecordTypeId = rctId,
            Is_Active__c = true,
            Channel__c = 'canal',
            Service__c = 'service2'
        ));

        insert cmlist;

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Map<String, Object> selfManagementStep = new Map<String, Object>();
        Map<String, Object> selfManagementFields = new Map<String, Object>();
        
        selfManagementFields.put('ChannelSelection', 'canal');
        selfManagementStep.put('SelfManagementFields', selfManagementFields);
        input.put('SelfManagementStep', selfManagementStep);

        Test.startTest();
        Ta_techCare_selfManagement testClass = new Ta_techCare_selfManagement();
        testClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        List<Map<String,String>> outOptions = (List<Map<String,String>>) outMap.get('options');

        System.assertEquals(2, outOptions.size());
    }

    @isTest
    static void testGetServicess_excep(){
        String methodName = 'GetServices';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Map<String, Object> selfManagementStep = new Map<String, Object>();
        Map<String, Object> selfManagementFields = new Map<String, Object>();
        
        input.put('SelfManagementStep', null);

        Test.startTest();
        Ta_techCare_selfManagement testClass = new Ta_techCare_selfManagement();
        testClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        System.assertNotEquals(null, outMap.get('error'));
    }

    @isTest
    static void testGetIncidents(){
        String methodName = 'GetIncidents';

        Id rctId = Schema.SObjectType.Contact_Motive__c.getRecordTypeInfosByName().get('Service Incident').getRecordTypeId();

        List<Contact_Motive__c> cmlist = new List<Contact_Motive__c>();

        cmList.add(new Contact_Motive__c(
            RecordTypeId = rctId,
            Is_Active__c = true,
            Channel__c = 'canal',
            Service__c = 'service',
            Incident__c = 'incident'
        ));

        cmList.add(new Contact_Motive__c(
            RecordTypeId = rctId,
            Is_Active__c = true,
            Channel__c = 'canal',
            Service__c = 'service',
            Incident__c = 'incident2'
        ));

        insert cmlist;

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Map<String, Object> selfManagementStep = new Map<String, Object>();
        Map<String, Object> selfManagementFields = new Map<String, Object>();
        
        selfManagementFields.put('ChannelSelection', 'canal');
        selfManagementFields.put('ServiceSelection', 'service');
        selfManagementStep.put('SelfManagementFields', selfManagementFields);
        input.put('SelfManagementStep', selfManagementStep);

        Test.startTest();
        Ta_techCare_selfManagement testClass = new Ta_techCare_selfManagement();
        testClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        List<Map<String,String>> outOptions = (List<Map<String,String>>) outMap.get('options');

        System.assertEquals(2, outOptions.size());
    }

    @isTest
    static void testGetIncidents_excep(){
        String methodName = 'GetIncidents';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Map<String, Object> selfManagementStep = new Map<String, Object>();
        Map<String, Object> selfManagementFields = new Map<String, Object>();
        
        input.put('SelfManagementStep', null);

        Test.startTest();
        Ta_techCare_selfManagement testClass = new Ta_techCare_selfManagement();
        testClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        System.assertNotEquals(null, outMap.get('error'));
    }
}