public class IFS_S314_addSuscriptions {

    private static String guId = null;
    
    public static Map<String,Object> addSuscriptions(String nroLinea, String codSuscripcion, String codInteraccionNegocio, String codInterfazComunicacion, String codCanal, String palabraClaveSVA,  Map<String,Object> FiltrosExtra){
        
        addSuscriptionsJson jsonParse = new addSuscriptionsJson();
        List<FiltrosExtra> filtrosExtraList = new list<FiltrosExtra>();
        
        for(String cons : FiltrosExtra.keySet()){
            FiltrosExtra filtro = new FiltrosExtra();
            filtro.nombreParametro=cons;
            filtro.valorParametro=(String)FiltrosExtra.get(cons);
            filtrosExtraList.add(filtro);
        }
        
        jsonParse.FiltrosExtra = filtrosExtraList;
        jsonParse.codSuscripcion = codSuscripcion;
        jsonParse.codInteraccionNegocio = codInteraccionNegocio;
        jsonParse.codInterfazComunicacion = codInterfazComunicacion;
        jsonParse.codCanal = codCanal;
        jsonParse.palabraClaveSVA = palabraClaveSVA;
        
        String body = JSON.serialize(jsonParse);
        HttpResponse response = makePostCallout(body,nroLinea);
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        responseNode.put('httpStatusCode',(String.valueOf(response.getStatusCode())));
        return responseNode;
    }
    
    /**
     * Wrapper del IFS_LogRecord.record
     */
    private static void writeLog (String pTipo, String pReq, String pRes, Integer pResStatus) {
        System.debug('Entre en writeLog - pTipo --> ' + pTipo + ' - pReq --> ' + pReq + ' - pRes --> ' + pRes + ' - pResStatus --> ' + pResStatus);
        String dts = DateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'', 'America/Argentina/Buenos_Aires');

        if (pTipo == 'REQ') {
            guId = String.isBlank(guId) ? GuidUtil.NewGuid() : guId;  
            IFS_LogRecord.record(dts, 'SERVICIO', 'S314', pTipo, guId, pReq, '');  
        }
        else {
            String datos = 'status code = ' + pResStatus + ' ; status = ; ';
            if (pResStatus < 300) {
                datos += 'request to DPW OK';
            }
            else {
                datos += 'request to DPW FAIL ; request body = ' + (String.isBlank(pReq)?'':pReq) + ' ; Response = ' + pRes;
            } 
            IFS_LogRecord.record(dts, 'SERVICIO', 'S314', pTipo, guId, '', datos);  
        }
    }
    
    public static HttpResponse makePostCallout(String body,String numeroLinea) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        List<EndPointService__c> endPoints = [select Name, EndPoint__c from EndPointService__c where Name = 'IFS_s314' limit 1];
        EndPointService__c endpoint;
        if(endPoints.size()>0){
            endpoint = endPoints[0];
        }
        String campo='nroLinea';
        IFS_EndpointFixer fixer = new IFS_EndpointFixer();
        
        if(endpoint != null){
               endpoint.EndPoint__c=fixer.FixEndpoint(campo, numeroLinea, endpoint);
               request.setEndpoint(endpoint.EndPoint__c);
        }

        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        String authorizationHeader = IFS_AuthorizationHeader.giveHeader();
        request.setHeader('Authorization', authorizationHeader);
        request.setBody(body);
        system.debug(request.getBody());
        HttpResponse response = http.send(request);
        system.debug(response);
        
        writeLog ('REQ', '{"'+campo+'":"'+numeroLinea+'"}', null, 0);
        writeLog ('RES', request.getBody(), response.getBody(), response.getStatusCode());
        
        return response;
    }    
    
    public class addSuscriptionsJson{       
        public List<FiltrosExtra> FiltrosExtra {get;set;}
        public String codSuscripcion {get;set;}
        public String codInteraccionNegocio {get;set;}
        public String codInterfazComunicacion {get;set;}
        public String codCanal {get;set;}
        public String palabraClaveSVA {get;set;}
        
        public addSuscriptionsJson(){
            FiltrosExtra = new List<FiltrosExtra>();
        }
    }
    
    public class FiltrosExtra{
        public String nombreParametro {get;set;}
        public String valorParametro {get;set;}
    }
    
}