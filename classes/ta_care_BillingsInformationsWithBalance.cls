/*
Created by Federico Biaus 10/07/2018
This class is tested by "ta_care_BillingsInformationBalance_Test" 
*/
global with sharing class ta_care_BillingsInformationsWithBalance implements vlocity_cmt.VlocityOpenInterface {

    global ta_care_BillingsInformationsWithBalance(){}
    
      global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        
        try{
            if (methodName.Equals('CompleteWithBalance')) {
                CompleteWithBalance(inputMap, outMap, options);
            }
            
        }catch(Exception ex)
        {
            outMap.put('error', ex.getStackTraceString());
            result = false;
        }
        
        return result;
     }
    
    @TestVisible 
    global static void CompleteWithBalance(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        try
        {   
            vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
            Map<String, Object> billingObj = new Map<String, Object>();
            List<Object> billingAccList = VlocityOpenInterfaceHelper.getListObjectsFromMap(options, 'BillingAccounts');
            
            Map<String, Object> outMapIFS = new Map<String, Object>();
            Map<String, Object> optionsIFS = new Map<String, Object>();
            integProcServ.invokeMethod('IFS_S018', createRequestForIFS018(billingAccList), outMapIFS, optionsIFS);
            Map<String, Object> result = (Map<String, Object>)outMapIFS.get('IPResult');
            List<Object> objBalance = new List<Object>();
            if(result.get('detalle') == null)
            {
                ta_care_ifs018 isf018 = new ta_care_ifs018();
                objBalance = isf018.getBalances(result);
                for(Object balance : objBalance)
                {
                    Map<String, Object> balanceMap = (Map<String, Object>)balance;
                    String accountIntId = String.valueOf(balanceMap.get('accountIntId'));
                    
                    for(Object billingAcc : billingAccList)
                    {
                        Map<String, Object> billingAccMap = (Map<String, Object>)billingAcc;
                        String accountIntegrationId = String.valueOf(billingAccMap.get('AccountIntegrationId'));
                        if(accountIntId == accountIntegrationId)
                        {
                            Double totalBalence = (Double.valueOf(balanceMap.get('saldoAFavor')) - Double.valueOf(balanceMap.get('saldoDeudor')));
                            billingAccMap.put('Balance', totalBalence);
                            //System.debug('billingAccMap: '+billingAccMap);
                        }
                    }
                }
              //  outMap.put('BillingAccounts',billingAccList);
            }
            else
            {
                // throw new FuncException('Ocurrio un error al intentar consultar el balance de las cuentas dadas.');
                for(Object billingAcc : billingAccList)
                {
                   Map<String, Object> billingAccMap = (Map<String, Object>)billingAcc;
                   billingAccMap.put('Balance', 'Sin datos');
                }
            }
            //System.debug('objBalance: '+objBalance);
        }catch(Exception ex)
        {
            System.debug('Error en CompleteWithBalance: '+ ex.getMessage());
            throw ex;
        }
    }

    @TestVisible
    global static Map<String, Object> createRequestForIFS018(List<Object> billingAccList) {
        
        Map<String, Object> body = new Map<String, Object>();
        try
        {
            Map<String, Object> codigoCuentaAcceso = new Map<String, Object>();
            Map<String, Object> listaCuentas = new Map<String, Object>();
            List<Map<String, Object>> cuentas = new List<Map<String, Object>>();
            Map<String, Object> idCuenta;
            Map<String, Object> cuenta = new Map<String, Object>();

            for(Object billingAcc : billingAccList)
            {
                idCuenta = new Map<String, Object>();
                Map<String, Object> billingAccMap = (Map<String, Object>)billingAcc;
                System.debug('accountsIntegrationId: '+ String.valueOf(billingAccMap.get('AccountIntegrationId')));
                idCuenta.put('idCuenta', String.valueOf(billingAccMap.get('AccountIntegrationId')));
                cuentas.add(idCuenta);
            }
            cuenta.put('cuenta', cuentas);
            listaCuentas.put('listaCuentas', cuenta);
            codigoCuentaAcceso.put('codigoCuentaAcceso', listaCuentas);
            body.put('body', codigoCuentaAcceso);

            System.debug('Request: '+body);

        }catch(Exception ex){
            System.debug('Error en createRequestForIFS018: '+ ex.getMessage());
            throw ex;
        }
        return body;
    }
}