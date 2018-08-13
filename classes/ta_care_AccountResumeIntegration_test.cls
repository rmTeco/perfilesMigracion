@IsTest
public class ta_care_AccountResumeIntegration_test {
    @IsTest static void GetAccountResumeIntegration_OK(){
        String methodName = 'GetAccountResumeIntegration';

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        ta_care_AccountResumeIntegration testedClass = new ta_care_AccountResumeIntegration();
		string args = '{"bodyS018":{"codigoCuentaAcceso":{"codCuenta":"1380001003300001"}},"bodyS059":{"accesoCuenta":{"identificadorRecurso":"string","idCuenta":"1380001003300001","codCuenta":"1380001003300001","condicionPago":"string"},"txid":"123456","cantidadItemsConsulta":0,"referenciaItemPaginado":0,"cantidadMaxConsulta":0,"fechaDesde":"2018-01-01 00:00:00","fechaHasta":"2018-01-31 00:00:00"},"bodyS024":{"codAcceso":{"codAccesoCuenta":{"identificadorRecurso":"","idCuenta":"1380001003300001","codCuenta":"1380001003300001"},"condicionPago":"2"},"tipoConsulta":{"cicloFacturacion":"20180101","periodoTiempo":{"fechaDesde":"2018-01-01 00:00:00","fechaHasta":"2018-01-31 00:00:00","tipoConsulta":"1"},"consultaPendientes":"Y"},"numTotalRegistros":"string","numRegistroInicial":"string","cantRegistrosMostrar":"string"}}';
        Map<String, Object> inputMap2 = (Map<String, Object>)JSON.deserializeUntyped(args);
        inputMap.put('body', inputMap2);
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
		
        
        Map<String, Object> result = (Map<String, Object>)outMap.get('IPResult');
        List<Object> refills = (List<Object>)result.get('datosBalance');
		List<Object> refillsEmpty;
        System.assertEquals(refills,refillsEmpty);
    }
    @IsTest static void GetAccountResumeIntegration2_OK(){
		
        String methodName = 'GetAccountResumeIntegration2';
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        ta_care_AccountResumeIntegration testedClass = new ta_care_AccountResumeIntegration();

        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
		
        
        Map<String, Object> result = (Map<String, Object>)outMap.get('IPResult');
        List<Object> transactions = (List<Object>)result.get('transacciones');
		Map<String, Object> mapTransactions = (Map<String, Object>)transactions[0];
		
        System.assertEquals(0,mapTransactions.get('Acumulado'));
    }
    
    @IsTest static void GetAccountResumeIntegration3_OK(){
        String methodName = 'GetAccountResumeIntegration3';

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        ta_care_AccountResumeIntegration testedClass = new ta_care_AccountResumeIntegration();
		string args = '{"bodyS018":{"codigoCuentaAcceso":{"codCuenta":"1380001003300001"}},"bodyS059":{"accesoCuenta":{"identificadorRecurso":"string","idCuenta":"1380001003300001","codCuenta":"1380001003300001","condicionPago":"string"},"txid":"123456","cantidadItemsConsulta":0,"referenciaItemPaginado":0,"cantidadMaxConsulta":0,"fechaDesde":"2018-01-01 00:00:00","fechaHasta":"2018-01-31 00:00:00"},"bodyS024":{"codAcceso":{"codAccesoCuenta":{"identificadorRecurso":"","idCuenta":"1380001003300001","codCuenta":"1380001003300001"},"condicionPago":"2"},"tipoConsulta":{"cicloFacturacion":"20180101","periodoTiempo":{"fechaDesde":"2018-01-01 00:00:00","fechaHasta":"2018-01-31 00:00:00","tipoConsulta":"1"},"consultaPendientes":"Y"},"numTotalRegistros":"string","numRegistroInicial":"string","cantRegistrosMostrar":"string"}}';
        Map<String, Object> inputMap2 = (Map<String, Object>)JSON.deserializeUntyped(args);
        inputMap.put('body', inputMap2);
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
		
        
        Map<String, Object> result = (Map<String, Object>)outMap.get('IPResult');
        List<Object> refills = (List<Object>)result.get('datosBalance');
		List<Object> refillsEmpty;
        System.assertEquals(refills,refillsEmpty);
    }

}