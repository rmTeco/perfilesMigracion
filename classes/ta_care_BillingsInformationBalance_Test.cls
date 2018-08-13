@isTest
public class ta_care_BillingsInformationBalance_Test{

    @isTest
    public static void CompleteWithBalance_Test1() {
        ta_care_BillingsInformationsWithBalance testedClass = new ta_care_BillingsInformationsWithBalance();
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();

        String jsonString = '{"BillingAccounts":[{"Assets":{"Family":"Movil"},"AccountIntegrationId":"2380001051410001","Status":"Active","PurchaseFinancing":false,"BillingStreet":"Congreso 3900","BillingReceipt":"Factura física","BillingDay":"21","AccountId":"0016C000009NhnTQAS","AccountIntegrationId__c":"2380001051410001","CreatedDate":"2018-02-08T16:52:00.000Z"},{"Assets":{"Family":"Movil"},"MultipleBillings":true,"AccountIntegrationId":"2380001051310001","Status":"Active","PurchaseFinancing":false,"BillingStreet":"Florida 123","BillingReceipt":"Factura física","BillingDay":"07","AccountId":"0016C000009NhnOQAS","AccountIntegrationId__c":"2380001051310001","CreatedDate":"2018-02-08T15:53:30.000Z"}]}';
        Map<String, Object> options = (Map<String, Object>) JSON.deserializeUntyped(jsonString);

        testedClass.invokeMethod('CompleteWithBalance', input, outMap, options);
    }


    @isTest
    public static void CompleteWithBalance_Test2() {
        ta_care_BillingsInformationsWithBalance testedClass = new ta_care_BillingsInformationsWithBalance();
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();

        String jsonString = '{"BillingAccounts":[{"Assets":{"Family":"Movil"},"AccountIntegrationId":"1234567890123","Status":"Active","PurchaseFinancing":false,"BillingStreet":"Congreso 3900","BillingReceipt":"Factura física","BillingDay":"21","AccountId":"0016C000009NhnTQAS","AccountIntegrationId__c":"2380001051410001","CreatedDate":"2018-02-08T16:52:00.000Z"},{"Assets":{"Family":"Movil"},"MultipleBillings":true,"AccountIntegrationId":"123456790123","Status":"Active","PurchaseFinancing":false,"BillingStreet":"Florida 123","BillingReceipt":"Factura física","BillingDay":"07","AccountId":"0016C000009NhnOQAS","AccountIntegrationId__c":"2380001051310001","CreatedDate":"2018-02-08T15:53:30.000Z"}]}';
        Map<String, Object> options = (Map<String, Object>) JSON.deserializeUntyped(jsonString);

        testedClass.invokeMethod('CompleteWithBalance', input, outMap, options);
    }


    @isTest
    public static void CompleteWithBalance_Test3() {
        ta_care_BillingsInformationsWithBalance testedClass = new ta_care_BillingsInformationsWithBalance();
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();

        String jsonString = '{"BillingAccounts":[{"Assets":{"Family":"Movil"},"AccountIntegrationId":"1234567890123","Status":"Active","PurchaseFinancing":false,"BillingStreet":"Congreso 3900","BillingReceipt":"Factura física","BillingDay":"21","AccountId":"0016C000009NhnTQAS","AccountIntegrationId__c":"2380001051410001","CreatedDate":"2018-02-08T16:52:00.000Z"},{"Assets":{"Family":"Movil"},"MultipleBillings":true,"AccountIntegrationId":"123456790123","Status":"Active","PurchaseFinancing":false,"BillingStreet":"Florida 123","BillingReceipt":"Factura física","BillingDay":"07","AccountId":"0016C000009NhnOQAS","AccountIntegrationId__c":"2380001051310001","CreatedDate":"2018-02-08T15:53:30.000Z"}]}';
        Map<String, Object> options = (Map<String, Object>) JSON.deserializeUntyped(jsonString);

        testedClass.invokeMethod('CompleteWithBalance22', input, outMap, options);
    }


    @isTest
    public static void CompleteWithBalance_Test4() {
        ta_care_BillingsInformationsWithBalance testedClass = new ta_care_BillingsInformationsWithBalance();
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        testedClass.invokeMethod('CompleteWithBalance', input, outMap, options);
    }
}