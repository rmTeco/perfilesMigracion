public with sharing class taMatrixForSupport {
    
    public static Map<String, Object> checkMatrix(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        String endpoint = 'https://'+URL.getSalesforceBaseUrl().getHost().replace('visual.force','my.salesforce').remove('--c')+ '/services/apexrest/vlocity_cmt/v1/calculate/StockMovementOperation?OperationType=VTAN&Instance=ANULARESERVA&DeliveryMode=Presencial&OriginStock=MTPL';
        
        System.debug('URL Host: ' +URL.getSalesforceBaseUrl().getHost());
        System.debug('URL Base: ' +URL.getSalesforceBaseUrl().toExternalForm());
        System.debug('User Type: ' +userinfo.getUserType());
        String ntwrkId = Network.getNetworkId();
        
        System.debug('endpoint: ' + endpoint);
        
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        //request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
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
        return null;
        
    }

    public Static void checkIPSMatrix() {
        
        
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        String reqBody = '{"params":{"OperationType":"VTAN","Instance":"ANULARESERVA","DeliveryMode":"Presencial","OriginStock":"MTPL"}}';
        input = (Map<String, Object>) JSON.deserializeUntyped(reqBody);
        
        System.debug('IPS_getStockMovementOperations - request : ' + JSON.serialize(input));
        vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
        integProcServ.invokeMethod('Sales_getStockMovementOperations', input, output, options);
        System.debug('IPS_getStockMovementOperations - response : ' + JSON.serialize(output));
    }
    

}