@isTest
public class TransformParamTest {

    @isTest static void testOk () {
        Map<String, Object> pinputMap = getInputParam();
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('body', pinputMap);
        Map<String, Object> outMap = new Map<String, Object>();
        Test.startTest();
        TransformParam s143 = new TransformParam();
        Boolean result = s143.invokeMethod('getTransformDecimales', inputMap, outMap, null);
        System.debug('IPResult: ' + outMap.get('IPResult'));
        System.assertEquals(true, result); 
        Test.stopTest();
    }    

    @isTest static void testNoOk () {
        Map<String, Object> inputMap = getInputParam();
        if (inputMap != null && !inputMap.isEmpty()) {
            inputMap.remove('codigoAccesoSuscriptor');
        }
        Map<String, Object> outMap = new Map<String, Object>();
        Test.startTest();
        TransformParam s143 = new TransformParam();
        Boolean result = s143.invokeMethod('getTransformDecimales', inputMap, outMap, null);
        System.debug('IPResult: ' + outMap.get('IPResult'));
        System.assertEquals(false, result); 
        Test.stopTest();
    }    

    static Map<String, Object>  getInputParam () {
        System.debug('----- getInputParam()');

        Map<String, Object> inputParam  = new Map<String, Object>();
        Map<String, Object> inputParam2 = new Map<String, Object>();
        Map<String, Object> inputParam3 = new Map<String, Object>();
        Map<String, Object> inputParam4 = new Map<String, Object>();
        List<Map<String, Object>> listaInputParam3 = new List<Map<String, Object>>();

        inputParam.put('codMotivoRecarga','24');
        inputParam2.put('identificadorRecurso','1122334455');
        inputParam.put('codigoAccesoSuscriptor',inputParam2);
        inputParam3.put('montoRecarga',100);
        listaInputParam3.add(inputParam3);
        inputParam4.put('listPagoEfectivo',listaInputParam3);
        inputParam.put('infoRecarga',inputParam4);
        System.debug(inputParam);

        return inputParam;
    }
}