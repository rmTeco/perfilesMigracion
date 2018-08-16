@isTest
global with sharing class IFS_S073_getBillTest {
   
    @isTest static void testOk () {
        System.debug('----- testOk()');
        Map<String, Object> fieldsMap = getInputParam();
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('Request', fieldsMap);
        Map<String, Object> outMap = new Map<String, Object>();
        Test.startTest();
        IFS_S073_getBill s073 = new IFS_S073_getBill();
        Boolean result = s073.invokeMethod('getBill', inputMap, outMap, null);
        Map<String, Object> ipResult = (Map<String, Object>)outMap.get('IPResult');
        System.debug('IPResult: ' + ipResult);
        Map<String, Object> renderTransformResult = (Map<String, Object>)ipResult.get('renderTransformResult');
        System.debug('renderTransformResult: ' + renderTransformResult);
        System.assertEquals(true, result);
        System.assertNotEquals(null, renderTransformResult.get('pagedatabytes'));
        Test.stopTest();
    }

     @isTest static void testNoOk () {
        System.debug('----- testNoOk()');
        Map<String, Object> fieldsMap = getInputParam();
        fieldsMap.remove('database');
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('Request', fieldsMap);
        Map<String, Object> outMap = new Map<String, Object>();
        Test.startTest();
        IFS_S073_getBill s073 = new IFS_S073_getBill();
        Boolean result = s073.invokeMethod('getBill', inputMap, null, null);
        System.assertEquals(false, result); 
        Test.stopTest();
     }

     

    @TestSetup
    static void crearDatosPrueba () {
        System.debug('----- Entre en crearDatosPrueba');
        try {
            EndPointService__c endPoint = new EndPointService__c(Name='IFS_s073');
            endPoint.EndPoint__c = 'http://52.67.109.234:8080/S073_getBill/rest/factura/cuenta/obtener';
            insert endPoint;
        }
        catch (Exception e) {
            System.debug('Error al crear el Endpoint__c de IFS_s073. Error: ' + e.getMessage());
        }
        System.debug('----- Sali de crearDatosPrueba');
    }


     static Map<String, Object>  getInputParam () {
        System.debug('----- getInputParam()');

        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('database', 'facturaciclica');
        inputMap.put('usuario', 'DESARROLLO');
        inputMap.put('password', 'DESARROLLO');
        inputMap.put('nroCuenta', '0000017607');
        inputMap.put('fechaEmision', '2017-11-30 00:00:00');
        return inputMap;
     }
}