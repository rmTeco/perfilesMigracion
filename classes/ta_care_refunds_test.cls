@IsTest
public class ta_care_refunds_test {
    
	@IsTest static void invoke_getBalanceForRefunds(){
    	String methodName = 'getBalanceForRefunds';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
		string body = '{"infoBalance":[{"listaCicloFacturacion":{"cicloFacturacion":[{"listaCicloFacturacionDetallado":{"cicloFacturacionDetallado":[{"codMoneda":"ARS","balanceCuenta":"859.6500"}]},"fechaVencimientoFacturacion":"2017-10-10 00:00:00","fechaCorteFacturacion":"2017-09-30 00:00:00","fechaInicioFacturacion":"2017-09-01 00:00:00","cicloFacturacion":"20170901"},{"listaCicloFacturacionDetallado":{"cicloFacturacionDetallado":[{"codMoneda":"ARS","balanceCuenta":"20.0400"}]},"fechaVencimientoFacturacion":"2017-11-10 00:00:00","fechaCorteFacturacion":"2017-10-31 00:00:00","fechaInicioFacturacion":"2017-10-01 00:00:00","cicloFacturacion":"20171001"},{"listaCicloFacturacionDetallado":{"cicloFacturacionDetallado":[{"codMoneda":"ARS","balanceCuenta":"546.0000"}]},"fechaVencimientoFacturacion":"2019-01-10 00:00:00","fechaCorteFacturacion":"2018-12-31 00:00:00","fechaInicioFacturacion":"2018-12-01 00:00:00","cicloFacturacion":"20181201"}]},"listaDeBalances":{"balance":[{"detalleBalance":{"detalleItemBalance":[{"fechaVigenciaHastaProdAdq":"2017-12-31 00:00:00","fechaVigenciaDesdeProdAdq":"2017-09-01 00:00:00","saldoAnteriorBalance":"0.0000","saldoBalance":"1425.6900","codBalance":"701000000000000004"}]},"codMoneda":"ARS","flagReembolsoEfectivo":"N","flagCuentaDeposito":"N","saldoPorTipoBalance":"1425.6900","codTipoBalance":"C_MAIN_BILLING_ACCOUNT"}]},"listaInfoCredito":{},"codCuenta":"1380001003300001","saldoPorTipoBalance":"3433.8700"}]}';
        options.put('listaInfoBalance',(Map<String, Object>)JSON.deserializeUntyped(body));
        
        ta_care_refunds refunds = new ta_care_refunds();
        
		Test.startTest();
        refunds.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        List<Object> resultList = (List<Object>)outMap.get('listaCuentas');
        Map<String, Object> resultMap = (Map<String, Object>)resultList[0];
        system.debug('MAPA PARA VER SALDO A VENCER -->'+resultMap);
        system.assertEquals('879.6900',resultMap.get('saldoVencido'));
        system.assertEquals('1425.6900',resultMap.get('saldoAFavor'));
        system.assertEquals('3433.8700',resultMap.get('saldoDeudor'));
        system.assertEquals('546.0000',resultMap.get('saldoAVencer'));
    }
    
    @IsTest static void invoke_getBalanceForRefunds_positiveBalance(){
    	String methodName = 'getBalanceForRefunds';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
		string body = '{"infoBalance":[{"listaCicloFacturacion":{"cicloFacturacion":[{"listaCicloFacturacionDetallado":{"cicloFacturacionDetallado":[{"codMoneda":"ARS","balanceCuenta":"859.6500"}]},"fechaVencimientoFacturacion":"2017-10-10 00:00:00","fechaCorteFacturacion":"2017-09-30 00:00:00","fechaInicioFacturacion":"2017-09-01 00:00:00","cicloFacturacion":"20170901"},{"listaCicloFacturacionDetallado":{"cicloFacturacionDetallado":[{"codMoneda":"ARS","balanceCuenta":"20.0400"}]},"fechaVencimientoFacturacion":"2017-11-10 00:00:00","fechaCorteFacturacion":"2017-10-31 00:00:00","fechaInicioFacturacion":"2017-10-01 00:00:00","cicloFacturacion":"20171001"},{"listaCicloFacturacionDetallado":{"cicloFacturacionDetallado":[{"codMoneda":"ARS","balanceCuenta":"546.0000"}]},"fechaVencimientoFacturacion":"2019-01-10 00:00:00","fechaCorteFacturacion":"2018-12-31 00:00:00","fechaInicioFacturacion":"2018-12-01 00:00:00","cicloFacturacion":"20181201"}]},"listaDeBalances":{"balance":[{"detalleBalance":{"detalleItemBalance":[{"fechaVigenciaHastaProdAdq":"2017-12-31 00:00:00","fechaVigenciaDesdeProdAdq":"2017-09-01 00:00:00","saldoAnteriorBalance":"0.0000","saldoBalance":"1425.6900","codBalance":"701000000000000004"}]},"codMoneda":"ARS","flagReembolsoEfectivo":"N","flagCuentaDeposito":"N","saldoPorTipoBalance":"1425.6900","codTipoBalance":"C_MAIN_BILLING_ACCOUNT"}]},"listaInfoCredito":{},"codCuenta":"1380001003300001","saldoPorTipoBalance":"0"}]}';
        options.put('listaInfoBalance',(Map<String, Object>)JSON.deserializeUntyped(body));
        
        ta_care_refunds refunds = new ta_care_refunds();
        
		Test.startTest();
        refunds.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        List<Object> resultList = (List<Object>)outMap.get('listaCuentas');
        Map<String, Object> resultMap = (Map<String, Object>)resultList[0];

        system.assertEquals('879.6900',resultMap.get('saldoVencido'));
        system.assertEquals('1425.6900',resultMap.get('saldoAFavor'));
        system.assertEquals('0',resultMap.get('saldoDeudor'));
    }
    
    @IsTest static void invoke_getBalanceBillingAccounts(){
        String methodName = 'getBalanceBillingAccounts';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        List<Object> accountList = new List<Object>();
        List<Object> accountList2 = new List<Object>();
        
        string body = '{"Assets": [{"Name": "Simcard","Id": "02i6C0000002fFiQAI"}],"TotalInvalidAssets": 0,"TotalActiveAssets": true,"PurchaseFinancing": false,"Name": "Florinda Acosta","Id": "0016C00000993xtQAA","Fraud": false,"Dunning": true,"DebtFinancing": false,"CountTotalActiveAssets": 4,"CountActivePrepaidAssets": 0,"BillingStreet": "Soler 5560","BillingCity": "B1908","AutoPaymentMethodIdFormula": false,"AccountNumber": "1","AccountIntegrationId": "1380001003300001"}';
        string body1 = '{"Assets": [{"Name": "Plan con Tarjeta Repro","Id": "02i6C0000002fEvQAI"}],"TotalInvalidAssets": 0,"TotalActiveAssets": false,"PurchaseFinancing": false,"ParentId": "0016C00000993xtQAA","Name": "Florinda Acosta nueva billing 4","Id": "0016C000009IWlPQAW","Fraud": false,"Dunning": false,"DebtFinancing": false,"CountTotalActiveAssets": 0,"CountActivePrepaidAssets": 0,"BillingStreet": "asd 123","BillingCity": "B1718","AutoPaymentMethodIdFormula": false,"AccountIntegrationId": "1380001003310022"}';
        Map<String, Object> accountMap = (Map<String, Object>)JSON.deserializeUntyped(body);
        Map<String, Object> accountMap1 = (Map<String, Object>)JSON.deserializeUntyped(body1);
        accountList.add(accountMap);
        accountList.add(accountMap1);
        
        string body2 = '{"saldoVencido": "879.6900","saldoAFavor": "0","saldoDeudor": "3433.8700","accountIntId": "1380001003300001"}';
        Map<String, Object> accountMap2 = (Map<String, Object>)JSON.deserializeUntyped(body2);
        accountList2.add(accountMap2);
        
        options.put('BillingAccounts',accountList);
        options.put('listaCuentas',accountList2);
        
        ta_care_refunds refunds = new ta_care_refunds();
        
		Test.startTest();
        refunds.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        List<Object> resultList =(List<Object>)outMap.get('BalancedBillingAccounts');
        Map<String, Object> resultMap = (Map<String, Object>)resultList[0];
        system.assertEquals('879.6900',resultMap.get('saldoVencido'));
        system.assertEquals('0',resultMap.get('saldoAFavor'));
        system.assertEquals('3433.8700',resultMap.get('saldoDeudor'));
        system.assertEquals('1380001003300001',resultMap.get('AccountIntegrationId'));
    }
    
    @IsTest static void invoke_getPaymentHistoryForPaymentMethodForRefunds(){
        String methodName = 'getPaymentHistoryForPaymentMethodForRefunds';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        String body = '{"infoPago": [{"idCuenta": "1380001000112345","idCliente": "13800010001","codSuscripcion": "13800010002","tipoTransaccionPago": "OnLine","fechaAplicacionPago": "2017-07-04 00:00:00","importePago": "300.0000","codMoneda": "ARS","codMedioPago": "TAR"}]}';
        Map<String, Object> infoPagoMap = (Map<String, Object>)JSON.deserializeUntyped(body);
        options.put('listaInfoPagos',infoPagoMap);
        options.put('codMedioPago','TAR');
        
        ta_care_refunds refunds = new ta_care_refunds();
        
		Test.startTest();
        refunds.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        List<Object> payList = (List<Object>)outMap.get('CreditCardPaymentsList');
        system.assertNotEquals(null,payList);
    }
    
    @IsTest static void invoke_getThreeMonthsAgoDate(){
        String methodName = 'getThreeMonthsAgoDate';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        ta_care_refunds refunds = new ta_care_refunds();
        
		Test.startTest();
        refunds.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        Date actualDate = date.today();
        Date actualDateLessMonth = actualDate.addMonths(-3);
        datetime dt = datetime.newInstance(actualDateLessMonth.year(), actualDateLessMonth.month(),actualDateLessMonth.day());
        
        datetime dtResult = (datetime)outMap.get('ThreeMonthsAgoDate');
        
        system.assertEquals(dt,dtResult);
    }
    
    @IsTest static void invoke_getCreditCardName(){
    	String methodName = 'getCreditCardName';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        String body ='{"nroTarjeta": "4545454545455478","codTarjeta": "404","nombreEntidadFinanciera": "ICBC","fechaAplicacionPago": "2017-07-04 00:00:00","importePago": "300.0000","$$hashKey": "object:494"}';
        Map<String, Object> bodyMap = (Map<String, Object>)JSON.deserializeUntyped(body);
        List<Object> bodyList = new List<Object>();
        bodyList.add(bodyMap); 
        options.put('CreditCardPaymentsList',bodyList);
        ta_care_refunds refunds = new ta_care_refunds();
        
		Test.startTest();
        refunds.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        system.assertNotEquals(null,outMap);
    }
    
    @IsTest static void invoke_getPaymentResult(){
        String methodName = 'getPaymentResult';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        String body = '{"revertirPagosRespuesta": {"listaInformacionPagos": [{"informacionPago": {"resultadoReversion": {"revExitosa": {"estado": "ok"}},"codPago": "CBSAR291554"}}]}}';
		Map<String, Object> bodyMap = (Map<String, Object>)JSON.deserializeUntyped(body);
        options.put('revertirPagosRespuesta',bodyMap);
        ta_care_refunds refunds = new ta_care_refunds();
        
		Test.startTest();
        refunds.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        system.assertEquals(true,outMap.get('PaymentRollBackResultSuccess'));
    }
    
    @IsTest static void invoke_getBillingAccByAccId(){
        String methodName = 'getBillingAccByAccId';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        String body = '[{"Assets": {"Name": "Plan Prepago Nacional"},"AccountId": "0016C000009NhnTQAS"},{"Assets": {"Name": "Plan Prepago Nacional"},"AccountId": "0016C000009NhnOQAS"}]';
        List<Object> bodyMap = (List<Object>)JSON.deserializeUntyped(body);
        
        options.put('AccountId','0016C000009NhnTQAS');
        options.put('AccountBalanceList',bodyMap);
        ta_care_refunds refunds = new ta_care_refunds();
        
		Test.startTest();
        refunds.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        system.assertNotEquals(null,outMap.get('AccountBalanceList'));
    }
}