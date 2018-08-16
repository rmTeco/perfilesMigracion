public class QueueableCallout implements Queueable, Database.AllowsCallouts {

    private String url;
    private String metodo;
    private String body;
    public HttpResponse response;

    public QueueableCallout(String pUrl, String pMetodo, String pBody) {
        url = pUrl;
        metodo = pMetodo;
        body = pBody;
    }

    public void execute(QueueableContext context){
        System.debug('------------ Inicio Ejecucion ----------');
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        EndPointService__c endpoint;

        List<EndPointService__c> endPoints = [SELECT Name, EndPoint__c FROM EndPointService__c WHERE Name = 'IFS_S073_getBill' LIMIT 1];
        if (endPoints != null && !endPoints.isEmpty()) {
            endpoint = endPoints[0];
        }
        else {
            if (!String.isBlank(url)) { //-- Si no hay definida un endpoint en la tabla uso lo que viene por parametro.
                endpoint.EndPoint__c = url;
            }
            else {
                throw new CalloutException('Endpoint vacio o nulo');
            }
        }

        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setMethod(metodo);
        request.setEndpoint(endpoint.EndPoint__c);
        request.setBody(body);
        //String authorizationHeader = IFS_AuthorizationHeader.giveHeader();
        //request.setHeader('Authorization', authorizationHeader);
        response = http.send(request);
        System.debug('---- Body --> ' + response.getBody());
    }
}