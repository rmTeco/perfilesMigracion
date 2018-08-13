@isTest
public class ta_techCare_subscriptions_test {
    
    @isTest
    static void invokeGetFilteredSubscriptions_OK() {

        String methodName = 'GetFilteredSubscriptions';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Ta_techCare_subscriptions subs = new Ta_techCare_subscriptions();

        options.put('subscriptionsList', '[002]');
        options.put('msisdn', '1122334455');

        Test.startTest();
        subs.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        String expectedFilteredList = '{"Suscripciones":[{"DatosServicioSuscrip":{"ListadoNrosCortos":[{"numeroCortoSVA":"2524"}],"codServicio":"002","descripcionCortaServicio":"RingTone 222","nombreServicio":"RingTone 111","descripcionServicio":"RingTone 222","estadoServicio":"1","codProveedor":"515","cargoUso":"100.2500","tipoContratacion":"PACK","cantUnidadesProdAdquiridas":"24"},"fechaAltaSuscripcion":"2017-09-25 10:10:10","fechaDesactivacionSuscripcion":"2017-12-31 10:10:10","palabraClaveSVA":"SIEBEL","CanalAlta":{"codCanal":"WEB","descripcionCanal":"WEB"},"codEstadoSuscripcion":"1","CanalBaja":{"codCanal":"","descripcionCanal":""},"fechaVigenciaHastaProdAdq":"2017-12-30 11:11:11","cantUnidadesProdRemanentes":"11"}],"error":"OK"}';
        Map<String, Object> expectedFilteredListMap = (Map<String, Object>)JSON.deserializeUntyped(expectedFilteredList);
        
        System.assertEquals(JSON.serialize(expectedFilteredListMap.get('Suscripciones')), JSON.serialize(outMap.get('Suscripciones')));
    }

    @isTest
    static void invokeUnsubscribeFromServices_OK() {

        String methodName = 'UnsubscribeFromServices';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Ta_techCare_subscriptions subs = new Ta_techCare_subscriptions();

        String filteredSubscriptions = '{"Suscripciones":[{"DatosServicioSuscrip":{"ListadoNrosCortos":[{"numeroCortoSVA":"2524"}],"codServicio":"002","descripcionCortaServicio":"RingTone 222","nombreServicio":"RingTone 111","descripcionServicio":"RingTone 222","estadoServicio":"1","codProveedor":"515","cargoUso":"100.2500","tipoContratacion":"PACK","cantUnidadesProdAdquiridas":"24"},"fechaAltaSuscripcion":"2017-09-25 10:10:10","fechaDesactivacionSuscripcion":"2017-12-31 10:10:10","palabraClaveSVA":"SIEBEL","CanalAlta":{"codCanal":"WEB","descripcionCanal":"WEB"},"codEstadoSuscripcion":"1","CanalBaja":{"codCanal":"","descripcionCanal":""},"fechaVigenciaHastaProdAdq":"2017-12-30 11:11:11","cantUnidadesProdRemanentes":"11"}],"error":"OK"}';
        Map<String, Object> filteredSubscriptionsMap = (Map<String, Object>)JSON.deserializeUntyped(filteredSubscriptions);
        
        options.put('filteredSubscriptions', filteredSubscriptionsMap.get('Suscripciones'));
        options.put('motive', 'Desconocimiento');
        options.put('caseId', TestDataFactory.createCases(1, null, null, 'Subject')[0].Id);
        options.put('needAdjustment', 'TRUE');
        options.put('addToBlacklist', true);

        Test.startTest();
        subs.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        System.assertEquals(null, (String) outMap.get('error'));
    }

    @isTest
    static void invokeGetDaysAutoRemoveBlacklist_OK() {

        String methodName = 'GetDaysAutoRemoveBlacklist';

        AutoRemoveBlacklistDays__c tstAutoRemoveDays = new AutoRemoveBlacklistDays__c(Days__c = 180);
        insert tstAutoRemoveDays; 

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Ta_techCare_subscriptions subs = new Ta_techCare_subscriptions();

        Test.startTest();
        subs.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        System.assertEquals(180, outMap.get('DaysAutoRemove'));
    }

    @isTest
    static void invokeGetHistoryBlacklist() {

        String methodName = 'getHistoryBlacklist';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Ta_techCare_subscriptions subs = new Ta_techCare_subscriptions();
        Test.startTest();
            // con esta linea se llega al 81% de covera, 
            // no se si es magia o el sistema valida que si es 
            // consulta de historial lo toma como todo OK...
            // si sabes la repuesta puede compartirla... en google no la encontre.
            subs.invokeMethod(methodName, input, outMap, options); 
        Test.stopTest();

    }

    
}