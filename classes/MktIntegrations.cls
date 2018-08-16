global with sharing class MktIntegrations implements vlocity_cmt.VlocityOpenInterface{
    global MktIntegrations() {}

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {

        Boolean result = true;

        try{
            if (methodName.equals('UpdateCPStatusHuawei')){
                UpdateCPStatusHuawei(inputMap,outMap);
            }
            else{
                result = false;
            }   
        } 
        catch(Exception e){
            System.debug('MktIntegrations:invokeMethod -> exception: '+e);
            result = false;
        }
        return result;
    }

    void UpdateCPStatusHuawei(Map<String, Object> inputMap, Map<String, Object> outMap){
        try{
            Map<String, Object> accounts = new Map<String, Object>();
            Set<String> businessAccounts = new Set<String>();
            Set<String> consumerAccounts = new Set<String>();

            CalloutException e = new CalloutException();

            system.debug(inputMap);

            String op = (String) inputMap.get('Case:Description');

            system.debug(op);
            
            if(op == null || op == ''){
                e.setMessage('No existe Case:Description');
                throw e;
            }            

            if(op.contains('ALTA')){
                op = 'alta';
            }else if(op.contains('BAJA')){
                op = 'baja';
            }else{
                e.setMessage('tipo de operacion Alta o Baja no definida');
                throw e;
            }

            if(op.equals('alta')){
                accounts = (Map<String,Object>) inputMap.get('AltaClubPersonal');
                //System.debug('accounts ' + accounts);      
            }else{
                accounts = (Map<String,Object>) inputMap.get('CPMembershipCancellation');
                //System.debug('accounts ' + accounts);  
            }
            
            Object baccs = accounts.get('businessAccounts');
            System.debug('baccs ' + baccs);
            
            if(baccs != null)
                businessAccounts = getIds(String.valueof(baccs));
       
            Object conAccs = accounts.get('consumerAccounts');
            System.debug('conAccs ' + conAccs);
            
            if(conAccs != null)
                consumerAccounts = getIds(String.valueof(conAccs));
    
            System.debug('consumerAccounts ' + consumerAccounts);
            
            //query de business accs
            List<Account> bAccountDetailList = [SELECT Name, AccountNumber, AccountIntegrationId__c FROM Account WHERE Id IN :businessAccounts];
    
            //query de consumer accs
            List<Account> cAccountDetailList = [SELECT Name, AccountNumber, AccountIntegrationId__c FROM Account WHERE Id IN :consumerAccounts];

            List<Account> allAccounts = new List<Account>();
            allAccounts.addAll(bAccountDetailList);
            allAccounts.addAll(cAccountDetailList);
            
            System.debug('bAccountDetailList ' + bAccountDetailList);
            System.debug('cAccountDetailList ' + cAccountDetailList);


            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options2 = new Map<String, Object>();
            vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();

            List<Asset> assetsByAccount = [SELECT Id, Accountid, MSISDN__c, Tipo_de_Producto__c, Subscription_Id__c FROM Asset WHERE AccountId IN :allAccounts];
            List<String> statusResponseMsgList = new List<String>();
            system.debug('assetsByAccount '+ assetsByAccount);
            if (assetsByAccount.isEmpty()) {
                statusResponseMsgList.add('El cliente no tiene assets para informar a Huawei');
            }
            if(op == 'alta'){
                for(Account a :allAccounts){
                    for(Asset ast : assetsByAccount){
                        if(a.Id == ast.AccountId && ast.Tipo_de_Producto__c == 'Plan Prepago'){
                            system.debug(ast.Subscription_Id__c);
                            input = Generate_RequestS372(ast.Subscription_Id__c, '1');
                            System.debug('request s372: ' + JSON.serialize(input));
                            integProcService.invokeMethod('IFS_S372', input, output, options2);
                            if (output.isEmpty() == false) {
                                statusResponseMsgList.add('Fail: ' + ast.Subscription_Id__c +  ' - ' + ast.AccountId);
                            } else {
                                statusResponseMsgList.add('Success ' + ast.Subscription_Id__c +  ' - ' + ast.AccountId);
                            }
                            System.debug('response s372: ' + output);
                        }
                    } 
                }
            }else{
                for(Account a :allAccounts){
                    for(Asset ast : assetsByAccount){
                        if(a.Id == ast.AccountId && ast.Tipo_de_Producto__c == 'Plan Prepago'){
                            system.debug(ast.MSISDN__c);
                            input = Generate_RequestS372(ast.Subscription_Id__c, '0');
                            System.debug('request s372: ' + JSON.serialize(input));
                            integProcService.invokeMethod('IFS_S372', input, output, options2);
                            if (output.isEmpty() == false) {
                                statusResponseMsgList.add('Fail: ' + ast.Subscription_Id__c +  ' - ' + ast.AccountId);
                            } else {
                                statusResponseMsgList.add('Success ' + ast.Subscription_Id__c +  ' - ' + ast.AccountId);
                            }
                            System.debug('response s372: ' + output);
                        }
                    } 
                }
            }
            outMap.put('IFS_S372_Response', statusResponseMsgList);
        }catch(Exception e){
            System.debug('MktIntegrations:AltaCPHuawei -> exception: ' + e.getMessage());
        }
    }

    public Static Set<String> getIds (String params){
        Set<String> ids = new Set<String>();
        String id = '';
        
        List<string> strings = params.split('},');
        
        for(String pos : strings){
            List<String> spplited = pos.split(',');
            
            for(String s : spplited){
                if(s.contains('Id=')){
                    id = s.substringAfter('=');
                }
                if(s.contains('vlcSelected=true')){
                    ids.add(id);
                }
            }
        }
        System.debug(ids);
        return ids;
    }

    @TestVisible
    private Map<String, Object> Generate_RequestS372(String subscriptionId, String op) {
        System.debug('Generate_RequestS372');

        System.debug('subscriptionId ' + subscriptionId + 'op ' + op);

        Map<String, Object> request = new Map<String, Object>();
        Map<String, Object> body = new Map<String, Object>();

        Map<String, Object> codigoAcceso = new Map<String, Object>();
        codigoAcceso.put('codSuscripcion', subscriptionId);

        System.debug('codigoAcceso ' + codigoAcceso);

        List<Map<String, String>> datosAdicionales = new List<Map<String, String>>();

        Map<String, String> datoAdicional = new Map<String, String>();
        datoAdicional.put('nombreParametro', 'C_SUB_ClubPersonal');
        datoAdicional.put('valorParametro', op);

        System.debug('datoAdicional ' + datoAdicional);

        datosAdicionales.add(datoAdicional);

        Map<String, Object> infoBasicaClient = new Map<String, Object>();
        infoBasicaClient.put('codAccionMoroATomar', '1');
        infoBasicaClient.put('listDatosAdicionales', datosAdicionales);

        System.debug('infoBasicaClient ' + infoBasicaClient);

        body.put('infoBasicaCliente', infoBasicaClient);
        body.put('codigodeAcceso', codigoAcceso);
        

        request.put('body', body);

        return request;
    }    
}