@isTest
public class IFS_S087_transformParamTest {

    @isTest static void testOk () {
        Map<String, Object> fieldsMap =  getInputParam();
        Map<String, Object> outMap = new Map<String, Object>();
        Test.startTest();
        IFS_S087_TransformMSISDN s087 = new IFS_S087_TransformMSISDN();
        Boolean result = s087.invokeMethod('getTransformParam', fieldsMap, outMap, null);
        System.debug('IPResult: ' + outMap.get('IPResult'));
        System.assertEquals(true, result); 
        Test.stopTest();
    }    

    @isTest static void testNoOk () {
        Map<String, Object> fieldsMap = getInputParam();
        if (fieldsMap != null && !fieldsMap.isEmpty()) {
            fieldsMap.remove('params');
        }
        Map<String, Object> outMap = new Map<String, Object>();
        Test.startTest();
        IFS_S087_TransformMSISDN s087 =  new IFS_S087_TransformMSISDN();
        Boolean result = s087.invokeMethod('getTransformParam', fieldsMap, outMap, null);
        System.debug('IPResult: ' + outMap.get('IPResult'));
        System.assertEquals(false, result); 
        Test.stopTest();
    }    

    static Map<String, Object>  getInputParam () {
        System.debug('----- getInputParam()');

        Map<String, Object> inputParam  = new Map<String, Object>();
        Map<String, Object> inputParam2 = new Map<String, Object>();

        inputParam.put('nroLinea','1122334455');
        inputParam.put('codProveedor','516');
        inputParam.put('marca','0');
        inputParam2.put('params',inputParam);

        return inputParam2;
    }
}