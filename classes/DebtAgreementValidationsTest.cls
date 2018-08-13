@isTest
private class DebtAgreementValidationsTest {

    @isTest static void validateNegativeBalanceOptionsEmpty() {
        //GIVEN
    String methodName = 'validateNegativeBalance';
    
    Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
       List<Object> billingAccounts = new List<Object>();
       Map<String,Object> assets = new Map<String,Object>();
       
       Map<String,Object> billingAccount = new Map<String,Object>();
       billingAccount.put('Name','NameAccount');
       billingAccount.put('AccountIntegrationId','AccountIntegrationId');
       billingAccount.put('BillingStreet','BillingStreet');
       billingAccount.put('AutoPaymentMethodIdFormula','AutoPaymentMethodIdFormula');
       billingAccount.put('Assets',assets);
       
       billingAccounts.add(billingAccount);
       input.put('BillingAccounts',billingAccounts);
       
       DebtAgreementValidations DebtAgreementValidations = new DebtAgreementValidations();
       
       //WHEN
       Test.startTest();
       DebtAgreementValidations.invokeMethod(methodName, input, outMap, options);
       Test.stopTest();
       
       //THEN
       System.assertEquals(true, ((List<Object>)outMap.get('AccountBalanceList')).isEmpty());
    }
    
    @isTest static void validateNegativeBalanceOptionsNotEmptyWithInfoBalanceListEmpty() {
        //GIVEN
    String methodName = 'validateNegativeBalance';
    
    Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
       List<Object> billingAccounts = new List<Object>();
       Map<String,Object> assets = new Map<String,Object>();
       
       Map<String,Object> billingAccount = new Map<String,Object>();
       billingAccount.put('Name','NameAccount');
       billingAccount.put('AccountIntegrationId','AccountIntegrationId');
       billingAccount.put('BillingStreet','BillingStreet');
       billingAccount.put('AutoPaymentMethodIdFormula','AutoPaymentMethodIdFormula');
       billingAccount.put('Assets',assets);
       billingAccounts.add(billingAccount);
       
       List<Object> infoBalance = new List<Object>();
       
       Map<String,Object> listaInfoBalance = new Map<String,Object>();
       listaInfoBalance.put('infoBalance',infoBalance);
       
       input.put('BillingAccounts',billingAccounts);
       options.put('listaInfoBalance', listaInfoBalance);
       
       DebtAgreementValidations DebtAgreementValidations = new DebtAgreementValidations();
       
       //WHEN
       Test.startTest();
       DebtAgreementValidations.invokeMethod(methodName, input, outMap, options);
       Test.stopTest();
       
       //THEN
       System.assertEquals(true, ((List<Object>)outMap.get('AccountBalanceList')).isEmpty());
    }
    
    @isTest static void validateNegativeBalanceOptionsNotEmptyWithInfoBalanceListNotEmpty() {
        //GIVEN
    String methodName = 'validateNegativeBalance';
    
    Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
       List<Object> billingAccounts = new List<Object>();
       Map<String,Object> assets = new Map<String,Object>();
       
       String AccountIntegrationId = 'AccountIntegrationId';
       
       Map<String,Object> billingAccount = new Map<String,Object>();
       billingAccount.put('Name','NameAccount');
       billingAccount.put('AccountIntegrationId',AccountIntegrationId);
       billingAccount.put('BillingStreet','BillingStreet');
       billingAccount.put('AutoPaymentMethodIdFormula','AutoPaymentMethodIdFormula');
       billingAccount.put('Assets',assets);
       billingAccounts.add(billingAccount);
       
       List<Object> infoBalance = new List<Object>();
       Map<String,Object> balance = new Map<String,Object>();
       String saldoPorTipoBalance = '100.0';
       Map<String,Object> listaCicloFacturacion = new Map<String,Object>();
       List<Object> cicloFacturacion = new List<Object>();
       Map<String,Object> ciclo1 = new Map<String,Object>();
       Map<String,Object> ciclo2 = new Map<String,Object>();
       Map<String,Object> detalleCicloFacturacion = new Map<String,Object>();
       List<Object> detalleItemCicloFacturacion = new List<Object>();
       Map<String,Object> item = new Map<String,Object>();
       item.put('balanceCuenta',100.0);
       item.put('codMoneda','codMoneda');
       detalleItemCicloFacturacion.add(item);
       detalleCicloFacturacion.put('detalleItemCicloFacturacion',detalleItemCicloFacturacion);
       ciclo1.put('detalleCicloFacturacion', detalleCicloFacturacion);
       ciclo1.put('fechaVencimientoFacturacion','1990-01-01 00:00:00');
       ciclo2.put('detalleCicloFacturacion', detalleCicloFacturacion);
       ciclo2.put('fechaVencimientoFacturacion',Datetime.now().addDays(1));
       cicloFacturacion.add(ciclo1);
       cicloFacturacion.add(ciclo2);
       listaCicloFacturacion.put('cicloFacturacion',cicloFacturacion);
       balance.put('codCuenta',AccountIntegrationId);
       balance.put('saldoPorTipoBalance',saldoPorTipoBalance);
       balance.put('listaCicloFacturacion',listaCicloFacturacion);
       infoBalance.add(balance);
       
       
       Map<String,Object> listaInfoBalance = new Map<String,Object>();
       listaInfoBalance.put('infoBalance',infoBalance);
       
       input.put('BillingAccounts',billingAccounts);
       options.put('listaInfoBalance', listaInfoBalance);
       
       DebtAgreementValidations DebtAgreementValidations = new DebtAgreementValidations();
       
       //WHEN
       Test.startTest();
       DebtAgreementValidations.invokeMethod(methodName, input, outMap, options);
       Test.stopTest();
       
       //THEN
       List<Object> result = (List<Object>)outMap.get('AccountBalanceList');
       System.assertEquals(false, result.isEmpty());
       System.assertEquals(billingAccounts.size(), result.size());
       for(Integer i = 0; i < billingAccounts.size(); i++){
           Map<String,Object> oResult = (Map<String,Object>) result.get(i);
           Map<String,Object> oBillingAccount = (Map<String,Object>) billingAccounts.get(i);
           System.assertEquals(oBillingAccount.get('Name'), oResult.get('Name'));
           System.assertEquals(oBillingAccount.get('AccountIntegrationId'), oResult.get('AccountIntegrationId'));
           System.assertEquals(oBillingAccount.get('BillingStreet'), oResult.get('BillingStreet'));
           System.assertEquals(oBillingAccount.get('AutoPaymentMethodIdFormula'), oResult.get('AutoPaymentMethodIdFormula'));
           System.assertEquals(oBillingAccount.get('Assets'), oResult.get('Assets'));
       }
       
    }
}