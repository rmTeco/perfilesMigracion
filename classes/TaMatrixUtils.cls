public with sharing class TaMatrixUtils {
    
    public static Map<String, Object> checkMatrix(String procedureName, Map<String, String> parameters){
        Http http = new Http();
        HttpRequest request = new HttpRequest();

       // String endpoint = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/vlocity_cmt/v1/calculate/' + procedureName;
        
        String endpoint = 'https://'+URL.getSalesforceBaseUrl().getHost().replace('visual.force','my.salesforce').remove('--c')+ '/services/apexrest/vlocity_cmt/v1/calculate/' + procedureName;
        
        System.debug('URL Host: ' +URL.getSalesforceBaseUrl().getHost());
        System.debug('URL Base: ' +URL.getSalesforceBaseUrl().toExternalForm());
        System.debug('User Type: ' +userinfo.getUserType());
        String ntwrkId = Network.getNetworkId();
        if (userinfo.getUserType() == 'CspLitePortal'){
            ConnectApi.Community comm = ConnectApi.Communities.getCommunity(ntwrkId);
            System.debug('Site URL: '+comm.siteUrl);
            endpoint = comm.siteUrl + '/services/apexrest/vlocity_cmt/v1/calculate/' + procedureName;
        }
        
        //String endpoint = 'https://ta-dev--desa01.cs63.my.salesforce.com/services/apexrest/vlocity_cmt/v1/calculate/' + procedureName;
        Boolean first = true;
        for(String key: parameters.keySet()){
            if(first){
                first = false;
                endpoint += '?';
            }else{
                endpoint += '&';
            }
            endpoint +=  key + '=' + parameters.get(key);
        }
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        try{
            System.debug('endpoint: ' + endpoint);
            HttpResponse response = http.send(request);
            System.debug(response.getBody());
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> output = (List<Object>)results.get('output');
            Map<String, Object> outputMap = (Map<String, Object>) output[0];
            List<Object> calculationResults = (List<Object>)outputMap.get('calculationResults');
            return (Map<String, Object>) calculationResults[0];
        }catch(Exception e){
            System.debug(e.getMessage());
        }

        if(Test.isRunningTest()){
            Map<String, String> responseTest = new Map<String, String>();
            if(procedureName == 'StockMovementOperation'){
                responseTest.put('StockMovementOperation__OperationCode', 'MTPL');
                responseTest.put('StockMovementOperation__DestinationDepositCode', 'VICLIE');
            } else {
                responseTest = null; 
            }
            return responseTest;
        } else {
            return null;
        }
        
    }

    public static String checkPrefa(String codfac, String tecacc, String dispsev){
        /*
        codfac = '37110'
        tecacc = 'FIBRA'
        dispsev = 'Voz'
        */
        Map<String, String> parameters = new Map<String, String>();
        parameters.put('Código%20factibilidad', codfac);
        parameters.put('Tecnologia%20de%20Acceso', tecacc);
        parameters.put('Disponibilidad%20Servicio', dispsev);
        Map<String, Object> calculationResultsMap = checkMatrix('EscenariosPrefa', parameters);
        if(calculationResultsMap != null){
            String result = (String) calculationResultsMap.get('EscenariosPrefactibilidadUS__AplicaDISPONIBILIDAD');

            if(result == 'SI'){
                return 'SI';
            }
        }
        
        return 'NO';
    }

    // PFTA-7756 - INI
    public static Map<String, Object> getDeliveryMethodServiceCode(String deliveryMethodService){
        Map<String, String> parameters = new Map<String, String>();
        parameters.put('DeliveryMethodServiceName', deliveryMethodService.replace(' ', ''));
        return (Map<String, Object>)checkMatrix('DeliveryMethodServiceCodes', parameters);
    }
    // PFTA-7756 - FIN

    public static Map<String, Object> getMediosDePago(String canalDeVenta){
        Map<String, String> parameters = new Map<String, String>();
        parameters.put('Codigo', canalDeVenta);
        return (Map<String, Object>)checkMatrix('MediosDePago', parameters);
    }
    
    public static Map<String, Object> getStockMovementOperation(String operationType , String instance, String deliveryMethod, String originStock){
        Map<String, String> parameters = new Map<String, String>();
        parameters.put('OperationType', operationType.replace(' ', ''));
        parameters.put('Instance', instance.replace(' ', ''));
        parameters.put('DeliveryMode', deliveryMethod.replace(' ', ''));
        parameters.put('OriginStock', originStock.replace(' ', ''));
        return (Map<String, Object>)checkMatrix('StockMovementOperation', parameters);
    }

    public static Map<String, Object> getStockAvailableCode(String channel, String deliveryMethod){
        Map<String, String> parameters = new Map<String, String>();
        parameters.put('Channel', channel.replace(' ', ''));
        parameters.put('DeliveryMode', deliveryMethod.replace(' ', ''));
        return (Map<String, Object>)checkMatrix('StockAvailableCode', parameters);
    }

    public static Map<String, Object> GetManageableIdentityValidationMatrix(String paymentMethod, String operation){
        Map<String, String> parameters = new Map<String, String>();
        parameters.put('PaymentMethod', paymentMethod.replace(' ', ''));
        parameters.put('Operation', operation.replace(' ', ''));
        return (Map<String, Object>)checkMatrix('ManageableIdentityValidation', parameters);
    }

    public static Map<String, Object> GetStockBillable(String stock){
        Map<String, String> parameters = new Map<String, String>();
        parameters.put('Stock', stock.replace(' ', ''));
        system.debug('parameters: '+parameters);
        return (Map<String, Object>)checkMatrix('StockBillable', parameters);
    }

    public static Map<String, Object> GetPromocionesFinancierasVigentes(String paymentMethod, String bankEntity, String cardName, String installment){
        Map<String, String> parameters = new Map<String, String>();
        parameters.put('TipoDePago', paymentMethod.replace(' ', ''));
        parameters.put('Banco', bankEntity.replace(' ', ''));
        parameters.put('Tarjeta', cardName.replace(' ', ''));
        parameters.put('Cuotas', installment.replace(' ', ''));
        system.debug('parameters: '+parameters);
        return (Map<String, Object>)checkMatrix('GetPromocionesFinancierasVigentes', parameters);
    }
}