@IsTest
public class ta_care_PaymentRecordTest {

    @IsTest static void invoke_GetPaymentRecord(){
        String methodName = 'GetPaymentRecord';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
		
        ta_care_PaymentRecord paymentList = new ta_care_PaymentRecord();
        
		Test.startTest();
        paymentList.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        Object detalleDePago = outMap.get('listaDetallesPagos');
        system.debug('outMap = '+outMap);
        Map<String, Object> IPResult = (Map<String, Object>)outMap.get('IPResult');
        Map<String, Object> listaInfoPagos = (Map<String, Object>)IPResult.get('listaInfoPagos');
        List<Object> infoPago = (List<Object>)listaInfoPagos.get('infoPago');
        Map<String, Object> payment = (Map<String, Object>)infoPago[0];
        String codMedioPago = (String)payment.get('codMedioPago');
        system.debug('codMedioPago = '+codMedioPago);
        
		system.assertEquals('Tarjeta de crédito', codMedioPago);
    }
    
}