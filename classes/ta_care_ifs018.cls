/* 
 * This class is tested by "ta_care_refunds_test" 
 * Code coverage : 89%
*/

global with sharing class ta_care_ifs018 {
    
	global ta_care_ifs018() {}
    
   /* public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String,Object> options)
    {
        Boolean result = true;
        try
        {
			if(methodName.equals('')){
                (input,outMap,options);
            }
        }
        catch(Exception e)
        {
            System.debug('ta_care_ifs018:invokeMethod -> exception: '+e);
            result = false;
        }
        return result;
    }
	*/
	
	public List<Object> getBalances (Map<String,Object> options){
		
		List<Object> result = new List<Object>();
		//Map<String, Object> accountsMap = new Map<String, Object>();
		Map<String, Object> fieldsMap = new Map<String, Object>();
        String accountCode;
        try{
			string clientsDebt;
			string positiveBalance;
			string pastDueBalance;
			string futureExpDateBalance;
			Map <String, Object> infoBalanceMap =(Map <String, Object>)options.get('listaInfoBalance');
            system.debug('infoBalanceMap -->'+infoBalanceMap);
			List<Object> infoBalanceList = VlocityOpenInterfaceHelper.getListObjectsFromMap(infoBalanceMap, 'infoBalance');
			system.debug('infoBalanceList --> '+infoBalanceList);
			for (Object obj : infoBalanceList ) {
				fieldsMap = new Map<String, Object>();
				Map<String, Object> balanceMap = (Map<String, Object>)obj;
				system.debug('BALANCE MAP -->'+balanceMap);
				clientsDebt = getClientsDebt(balanceMap);
				system.debug('LINEA 41, SALDO DEUDOR-->'+clientsDebt);
				positiveBalance = getPositiveBalance(balanceMap);
				system.debug('LINEA 43, SALDO A FAVOR -->'+positiveBalance);
				pastDueBalance = getPastDueBalance(balanceMap);
				system.debug('LINEA 45, SALDO VENCIDO -->'+pastDueBalance);
				futureExpDateBalance = getFutureExpirationDateBalance(balanceMap);
				accountCode = (String)balanceMap.get('codCuenta');
				fieldsMap.put('accountIntId',accountCode);
				fieldsMap.put('saldoDeudor',clientsDebt);
				fieldsMap.put('saldoAFavor',positiveBalance);
				fieldsMap.put('saldoVencido',pastDueBalance);
				fieldsMap.put('saldoAVencer',futureExpDateBalance);
				result.add(fieldsMap);
				system.debug('FINAL DEL FOR');
			}
			system.debug('SALIO DEL FOR LINEA 53');
			return result;
		}
		catch(Exception e)
        {
            System.debug('ta_care_ifs018:getBalances -> exception: '+e);
            fieldsMap.put('accountIntId','Error');
            fieldsMap.put('saldoDeudor','0');
			fieldsMap.put('saldoAFavor','0');
			fieldsMap.put('saldoVencido','0');
			result.add(fieldsMap);
            return result;
        }
	}
	
	Private String getClientsDebt (Map<String, Object> balanceMap){
		String result;
		Decimal saldoPorTipoBalance = Decimal.valueOf((String)balanceMap.get('saldoPorTipoBalance'));
		if(saldoPorTipoBalance > 0){
			String balance = String.valueof(saldoPorTipoBalance);
			result = balance;
		}else{
			result = '0';
		}
		return result;
	}
	
	Private String getFutureExpirationDateBalance (Map<String, Object> balanceMap){
	    String result;
		Decimal sum = 0;
		system.debug('ENTRO getFutureExpirationDateBalance -->');
        if(balanceMap.containsKey('listaCicloFacturacion')){
            Map <String, Object> cicloFacturacionMap = (Map <String, Object>)balanceMap.get('listaCicloFacturacion');
            List<Object> cicloFacturacionList = VlocityOpenInterfaceHelper.getListObjectsFromMap(cicloFacturacionMap, 'cicloFacturacion');
            //system.debug('getPastDueBalance --> cicloFacturacionList : '+cicloFacturacionList);
            for (Object obj : cicloFacturacionList ) {
                Map<String, Object> objMap = (Map<String, Object>)obj;
                //system.debug('CICLO DE FACTURACION -->'+objMap);
                Date dt = date.valueOf((String)objMap.get('fechaVencimientoFacturacion'));
                if(dt >= date.today()){
                    Map<String, Object> facturacionMap =(Map<String, Object>)objMap.get('listaCicloFacturacionDetallado');
                    List<Object> itemCicloFacturacionList = VlocityOpenInterfaceHelper.getListObjectsFromMap(facturacionMap, 'cicloFacturacionDetallado');
                    for (Object obje : itemCicloFacturacionList ) {
                        Map<String, Object> objeMap = (Map<String, Object>)obje;
                        //system.debug('ITEM FACTURACION--> '+objeMap);
                        sum += Decimal.valueOf((String)objeMap.get('balanceCuenta'));
                    }
                }
            }
        }
		result = string.valueof(sum);
		return result;       
	}
	
	Private String getPositiveBalance (Map<String, Object> balanceMap){
		String result;
		String saldoPorTipoBalance = (String)balanceMap.get('saldoPorTipoBalance');
        Decimal saldo = Decimal.valueOf(saldoPorTipoBalance);
		if(saldo == 0){
			Decimal sum = 0;
			Map <String, Object> balMap = (Map <String, Object>)balanceMap.get('listaDeBalances');
			List<Object> balanceList = VlocityOpenInterfaceHelper.getListObjectsFromMap(balMap, 'balance');
			for (Object obj : balanceList ) {
				Map<String, Object> objMap = (Map<String, Object>)obj;
				if(String.valueOf(objMap.get('codTipoBalance')) == 'C_MAIN_BILLING_ACCOUNT') //PFTA-11259
				{
					sum += Decimal.valueOf((String)objMap.get('saldoPorTipoBalance'));
				}
			}
			result = string.valueof(sum);
		}else {
			result = '0';
		}
		return result;
	}
	
	Private String getPastDueBalance (Map<String, Object> balanceMap){
		String result;
		Decimal sum = 0;
		if(balanceMap.containsKey('listaCicloFacturacion')){
    		Map <String, Object> cicloFacturacionMap = (Map <String, Object>)balanceMap.get('listaCicloFacturacion');
    		List<Object> cicloFacturacionList = VlocityOpenInterfaceHelper.getListObjectsFromMap(cicloFacturacionMap, 'cicloFacturacion');
    		//system.debug('getPastDueBalance --> cicloFacturacionList : '+cicloFacturacionList);
    		for (Object obj : cicloFacturacionList ) {
    			Map<String, Object> objMap = (Map<String, Object>)obj;
    			//system.debug('CICLO DE FACTURACION -->'+objMap);
    			Date dt = date.valueOf((String)objMap.get('fechaVencimientoFacturacion'));
    			if(dt < date.today()){
    				Map<String, Object> facturacionMap =(Map<String, Object>)objMap.get('listaCicloFacturacionDetallado');
    				List<Object> itemCicloFacturacionList = VlocityOpenInterfaceHelper.getListObjectsFromMap(facturacionMap, 'cicloFacturacionDetallado');
    				for (Object obje : itemCicloFacturacionList ) {
    					Map<String, Object> objeMap = (Map<String, Object>)obje;
    					//system.debug('ITEM FACTURACION--> '+objeMap);
    					sum += Decimal.valueOf((String)objeMap.get('balanceCuenta'));
    				}
    			}
    		}
		}
		result = string.valueof(sum);
		return result;
	}
}