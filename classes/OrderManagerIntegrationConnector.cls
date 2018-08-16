public class OrderManagerIntegrationConnector {
    
    private static OrderManagerIntegrationConnector instance = null;
    public string thorSession {get; set;}

    
    public OrderManagerIntegrationConnector(){

        Map<String, String> params = new Map<String, String>();
        OrderManagerIntegrationProperties__c conProp = OrderManagerIntegrationProperties__c.getValues('Milestones');
        params.put('name', conProp.User__c);
        params.put('password', conProp.Password__c);

        String jsonParams = JSON.serialize(params);
        HttpRequest req = new HttpRequest(); 
        req.setEndpoint(conProp.EndpointLoginUrl__c); 
        req.setHeader('Content-Type','application/json'); 
        req.setBody(jsonParams);
        req.setMethod('POST'); 
        Http http = new Http(); 
        HTTPResponse res = http.send(req);
       // System.debug('httpresponse:' + res);
        thorSession = res.getHeader('Set-Cookie'); 
       // System.debug('thorSession:' + thorSession);
    }
    
    public OrderManagerIntegrationConnector getInstance(){
       // if(instance == null) 
            instance = new OrderManagerIntegrationConnector();

        return instance;
    }

    public string getMilestones(String orderId){
        
        OrderManagerIntegrationConnector omicInstance = getInstance();
        OrderManagerIntegrationProperties__c conProp = OrderManagerIntegrationProperties__c.getValues('Milestones');
        String urlSendOrderID =conProp.EndpointGet__c + orderId;
 
        HttpRequest request = new HttpRequest();
        request.setEndpoint(urlSendOrderID);
        request.setMethod('GET');
        request.setHeader('Cookie', omicInstance.thorSession);
        Http http1 = new Http();
        HTTPResponse response = http1.send(request);
        String jsonResult;
        /*if(!Test.isRunningTest()){
        jsonResult = response.getBody();
        system.debug('JSON: '+jsonResult);
        } else {*/
       // jsonResult = '{"created":"2018-05-14T15:26:15.023674Z","lastTaskMovement":"2018-05-14T15:26:35.350620Z","state":"IN_PROGRESS","milestones":[{"name":"Dispatch confirmation order","updated":"2018-05-14T15:26:34.475432Z","state":"SKIPPED"},{"name":"En progreso | Assets Instanciados","updated":"2018-05-14T15:26:15.023674Z","state":"PENDING"},{"name":"En progreso | Comptel - Envio de Activación de Servicios","updated":"2018-05-14T15:26:15.023674Z","state":"PENDING"},{"name":"En progreso | Comptel - Servicios Activados","updated":"2018-05-14T15:26:15.023674Z","state":"PENDING"},{"name":"En progreso | Huawei - Envío Creación del Suscriptor","updated":"2018-05-14T15:26:34.828930Z","state":"COMPLETED"},{"name":"En progreso | Huawei - Suscriptor Creado","updated":"2018-05-14T15:26:15.023674Z","state":"PENDING"},{"name":"En progreso | Inicio de la Orden","updated":"2018-05-14T15:26:32.703314Z","state":"COMPLETED"},{"name":"En progreso | Numeración Móvil - Iniciando Actualizacion de Inventario","updated":"2018-05-14T15:26:15.023674Z","state":"PENDING"},{"name":"En progreso | Numeración Móvil - Inventario Actualizado","updated":"2018-05-14T15:26:15.023674Z","state":"PENDING"},{"name":"Fin de la orden","updated":"2018-05-14T15:26:15.023674Z","state":"PENDING"},{"name":"Fin provisión","updated":"2018-05-14T15:26:15.023674Z","state":"PENDING"},{"name":"Inicio provisión","updated":"2018-05-14T15:26:34.618998Z","state":"SKIPPED"},{"name":"New mobile line orchestration started","updated":"2018-05-14T15:26:33.596575Z","state":"SKIPPED"},{"name":"NMU Validation","updated":"2018-05-14T15:26:34.196550Z","state":"SKIPPED"}],"nonMilestones":[{"name":"CreateSubscriber - S203","updated":"2018-05-14T15:26:15.023674Z","state":"FATALLY_FAILED","falloutDetails":"2018-05-14 15:29:57.721008+00 fatally failed: non-successful HTTP response code: 400","manualQueueName":"Inbox Tecnico"},{"name":"CRM Order Item Line Courier Id Track Id Updated","updated":"2018-05-14T15:26:34.691351Z","state":"SKIPPED","falloutDetails":null,"manualQueueName":null},{"name":"CRM Request News from Delivery","updated":"2018-05-14T15:26:34.637236Z","state":"SKIPPED","falloutDetails":null,"manualQueueName":null},{"name":"CRM Sales invoice request","updated":"2018-05-14T15:26:34.377175Z","state":"SKIPPED","falloutDetails":null,"manualQueueName":null},{"name":"Envío de Activación de Servicios a la Red","updated":"2018-05-14T15:26:15.023674Z","state":"PENDING","falloutDetails":null,"manualQueueName":null},{"name":"Generate Huawei Id","updated":"2018-05-14T15:26:35.350620Z","state":"COMPLETED","falloutDetails":null,"manualQueueName":null},{"name":"PreActivate mobile services request","updated":"2018-05-14T15:26:15.023674Z","state":"PENDING","falloutDetails":null,"manualQueueName":null},{"name":"Update assets","updated":"2018-05-14T15:26:15.023674Z","state":"PENDING","falloutDetails":null,"manualQueueName":null},{"name":"Update mobile billing information","updated":"2018-05-14T15:26:15.023674Z","state":"PENDING","falloutDetails":null,"manualQueueName":null},{"name":"Update mobile rating step 2","updated":"2018-05-14T15:26:15.023674Z","state":"PENDING","falloutDetails":null,"manualQueueName":null},{"name":"updateNumberStatus - S326","updated":"2018-05-14T15:26:15.023674Z","state":"PENDING","falloutDetails":null,"manualQueueName":null},{"name":"Waiting for Updates","updated":"2018-05-14T15:26:15.023674Z","state":"PENDING","falloutDetails":null,"manualQueueName":null}]}';
        jsonResult = response.getBody();
        //}
        /*
        Map<String, Object> mapObjectOrderOM = (Map<String, Object>)JSON.deserializeUntyped(jsonResult);
        string test = (String)mapObjectOrderOM.get('state');
        system.debug('test: '+test);
        */
        
/*
        Map<String, Object> mapObjectOrderOM = (Map<String, Object>)JSON.deserializeUntyped(jsonResult);
        string test = (String)mapObjectOrderOM.get('state');
        system.debug('test: '+test);
*/
        return jsonResult;
    }

}