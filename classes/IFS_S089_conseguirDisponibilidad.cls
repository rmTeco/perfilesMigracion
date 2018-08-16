public class IFS_S089_conseguirDisponibilidad {
    
    private static String guId = null;
    
    public static Map<String,Object> conseguirDisponibilidad(String venta, String codeDep, String codeMarc, String codFamProd, String NM, String codStock){
        
        String message='codDeposito='+codeDep+'&';
        if(codeMarc!=null){
            message+='codMarca='+codeMarc+'&';
        }
        if(codFamProd!=null){
            message+='codFamiliaProducto='+codFamProd+'&';
        }
        if(NM!=null){
            message+='NMU='+NM+'&';
        }
        if(codStock!=null){
            message+='codigoStock='+codStock+'&';
        }
        if(String.isEmpty(message)){
            message='';
        }
        message = message.removeEnd('&');
        system.debug('IFS_S089 - request : ' + message);
        HttpResponse response = makePostCallout(message, venta);
        system.debug(response.getBody());
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        responseNode.put('httpStatusCode',(String.valueOf(response.getStatusCode())));
        return responseNode;
    }
    
    public static HttpResponse makePostCallout(String body, String id) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        List<EndPointService__c> endPoints = [select Name, EndPoint__c from EndPointService__c where Name = 'IFS_s089' limit 1];
        EndPointService__c endpoint;
        String campo = 'codPuntoVenta';
        IFS_EndpointFixer fixer = new IFS_EndpointFixer();
        if(endPoints.size()>0){
            endpoint = endPoints[0];
        }
        if(endpoint != null){
            endpoint.EndPoint__c=fixer.FixEndpointGetService(campo, id, endpoint,body);
            //endpoint.EndPoint__c=fixer.FixEndpoint(campo, id, endpoint);
            request.setEndpoint(endpoint.EndPoint__c);        }
        //request.setEndpoint('https://prodgonogo.personal.com.ar/inventario/disponibilidad/puntoVenta/{codPuntoVenta}');
        //request.setEndpoint('https://demo9538567.mockable.io/getQuestions');

        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        String authorizationHeader = IFS_AuthorizationHeader.giveHeader();
        request.setHeader('Authorization', authorizationHeader);
        HttpResponse response = http.send(request);
        system.debug(response);
        system.debug(response.getBody());        
    
        writeLog ('REQ', '{"'+campo+'":"'+id+'"} - ' + body, null, 0);
        writeLog ('RES', request.getBody(), response.getBody(), response.getStatusCode());
            
        return response;
    }     

    /**
     * Wrapper del IFS_LogRecord.record
     */
    private static void writeLog (String pTipo, String pReq, String pRes, Integer pResStatus) {
        System.debug('Entre en writeLog - pTipo --> ' + pTipo + ' - pReq --> ' + pReq + ' - pRes --> ' + pRes + ' - pResStatus --> ' + pResStatus);
        String dts = DateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'', 'America/Argentina/Buenos_Aires');

        if (pTipo == 'REQ') {
            guId = String.isBlank(guId) ? GuidUtil.NewGuid() : guId;  
            IFS_LogRecord.record(dts, 'SERVICIO', 'S089', pTipo, guId, pReq, '');  
        }
        else {
            String datos = 'status code = ' + pResStatus + ' ; status = ; ';
            if (pResStatus < 300) {
                datos += 'request to DPW OK';
            }
            else {
                datos += 'request to DPW FAIL ; request body = ' + (String.isBlank(pReq)?'':pReq) + ' ; Response = ' + pRes;
            } 
            IFS_LogRecord.record(dts, 'SERVICIO', 'S089', pTipo, guId, '', datos);  
        }
    }

    
}