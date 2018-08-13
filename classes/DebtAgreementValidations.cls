global with sharing class DebtAgreementValidations implements vlocity_cmt.VlocityOpenInterface {

    global DebtAgreementValidations () {}

    global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {

        Boolean result = true;
        try {

            if (methodName.equals('validateNegativeBalance')) {

                validateNegativeBalance(input, outMap, options);
            }
            result = false;

        }
        catch(Exception e) {
            System.debug('DebtAgreementValidations: invokeMethod -> exception: '+e);
            result = false;
            outMap.put('error', e.getMessage());
        }
        return result;
    }
    
    void validateNegativeBalance(Map<String, Object> inputMap,  Map<String, Object> outMap, Map<String, Object> options){
    		try {
    			List<Object> billingAccList = VlocityOpenInterfaceHelper.getListObjectsFromMap(inputMap, 'BillingAccounts');
    			Map<String, Object> resultMap;
    			List<Object> listResult = new List<Object>();
    			
    			for (Object obj : billingAccList ) {
    				
    				resultMap = new Map<String, Object>();
    				Map<String, Object> accountMap = (Map<String, Object>)obj;
    				
    				String accName = String.valueOf( accountMap.get('Name') );
    				String accIntegrationId = String.valueOf( accountMap.get('AccountIntegrationId') );
    				String billingStreet = String.valueOf( accountMap.get('BillingStreet') );
    				String autoPaymentMethodIdFormula = String.valueOf( accountMap.get('AutoPaymentMethodIdFormula') );
    				Object assetsObj = accountMap.get('Assets');

    				Map<String, String> result = searchBillingCycle(accIntegrationId, options);

    				for (String r : result.keySet()) {
    					resultMap.put(r, result.get(r));
    				}
    				if (resultMap.isEmpty() == false) {
    					resultMap.put('Name', accName);
    					resultMap.put('AccountIntegrationId', accIntegrationId);
    					resultMap.put('BillingStreet', billingStreet);
    					resultMap.put('AutoPaymentMethodIdFormula', autoPaymentMethodIdFormula);
    					resultMap.put('Assets', assetsObj);
    					listResult.add(resultMap);
    				}
    			}
    			
    			outMap.put('AccountBalanceList', listResult);
    			system.debug('result: ' + outMap);
    		} catch (Exception ex) {
    			system.debug(ex.getLineNumber());
    			throw ex;
    		}
    }
    
    private Map<String, String> searchBillingCycle(String accIntegrationId, Map<String, Object> options) {
    		
    		Map<String, String> resultMap;
    		
    		try {
    			resultMap = new Map<String, String>();
    			
    			if (options.isEmpty() == false) {
    			
	    			system.debug('accInt: ' + accIntegrationId);
	    			Object listaInfoBalance = options.get('listaInfoBalance');
	    			List<Object> infoBalanceList = VlocityOpenInterfaceHelper.getListObjectsFromMap((Map<String, Object>)listaInfoBalance, 'infoBalance');
	    			
	    			String codMoneda = '';
	    			
	    			for (Object balance : infoBalanceList) {
	    				
	    				//system.debug(String.valueOf(((Map<String, Object>)balance).get('codCuenta')));
	    				if (String.valueOf(((Map<String, Object>)balance).get('codCuenta')).equalsIgnoreCase(accIntegrationId)) {
	    				
	    					Double saldoBalance = 0.0;
	    					Double saldoActual = 0.0;
		    				resultMap.put('saldoTotal', String.valueOf(((Map<String, Object>)balance).get('saldoPorTipoBalance')));
		    				Object listaCicloFracturacion = ((Map<String, Object>)balance).get('listaCicloFacturacion');
		    				List<Object> cicloFracturacionList = VlocityOpenInterfaceHelper.getListObjectsFromMap((Map<String, Object>)listaCicloFracturacion, 'cicloFacturacion');
		    				
		    				for (Object ciclo : cicloFracturacionList) {
		    					
		    					Object detalleCiclo = ((Map<String, Object>)ciclo).get('detalleCicloFacturacion');
		    					List<Object> detalleItemCicloList = VlocityOpenInterfaceHelper.getListObjectsFromMap((Map<String, Object>)detalleCiclo, 'detalleItemCicloFacturacion');
		    					DateTime fecha = DateTime.valueOf(String.valueOf(((Map<String, Object>)ciclo).get('fechaVencimientoFacturacion')))	;
	
		    					for (Object item : detalleItemCicloList) {
		    						if ( fecha < DateTime.now() ) {
		    							saldoBalance += Double.valueOf(((Map<String, Object>)item).get('balanceCuenta'));
		    						} else {
		    							saldoActual += Double.valueOf(((Map<String, Object>)item).get('balanceCuenta'));
		    						}
		    						codMoneda = String.valueOf(((Map<String, Object>)item).get('codMoneda'));
		    					}
		    				}
		    				resultMap.put('codMoneda', codMoneda);
		    				resultMap.put('saldoVencido', String.valueOf(saldoBalance));
		    				resultMap.put('saldoActual', String.valueOf(saldoActual));
	    				}
	    			}
	    			return resultMap;
    			}
    			return resultMap;
    		} catch (Exception ex) {
    			system.debug(ex.getLineNumber());
    			//throw ex;
    			//resultMap = new Map<String, String>();
    			resultMap.put('saldoTotal', '0.0');
			resultMap.put('codMoneda', 'ARS');
			resultMap.put('saldoVencido', '0.0');
			resultMap.put('saldoActual', '0.0');
			return resultMap;
    		}
    }
}