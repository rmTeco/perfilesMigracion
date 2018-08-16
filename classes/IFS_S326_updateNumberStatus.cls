public class IFS_S326_updateNumberStatus {

    private static String guId = null;
    
    public static Map<String,Object> updateNumberStatus(Map<String,Object> listaNumerosMotivos){
        
        NumerosMotivosJson jsonParse = new NumerosMotivosJson();
        List<listaNumerosMotivos> listaNumeros = new list<listaNumerosMotivos>();
        
        for(String Cons : listaNumerosMotivos.keySet()){
            listaNumerosMotivos numero = new listaNumerosMotivos();
            numero.nroLinea=Cons;
            numero.accion=(String)listaNumerosMotivos.get(Cons);
            listaNumeros.add(numero);
        }
        
        jsonParse.ListaNumeros = listaNumeros;
        
        String body = JSON.serialize(jsonParse);
        HttpResponse response = makePostCallout(body);
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        system.debug(response.getBody());
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
            IFS_LogRecord.record(dts, 'SERVICIO', 'S326', pTipo, guId, pReq, '');  
        }
        else {
            String datos = 'status code = ' + pResStatus + ' ; status = ; ';
            if (pResStatus < 300) {
                datos += 'request to DPW OK';
            }
            else {
                datos += 'request to DPW FAIL ; request body = ' + (String.isBlank(pReq)?'':pReq) + ' ; Response = ' + pRes;
            } 
            IFS_LogRecord.record(dts, 'SERVICIO', 'S326', pTipo, guId, '', datos);  
        }
    }

    public static HttpResponse makePostCallout(String body) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String guId = null;
        
        List<EndPointService__c> endPoints = [select Name, EndPoint__c from EndPointService__c where Name = 'IFS_s326' limit 1];
        EndPointService__c endpoint;
        if(endPoints.size()>0){
            endpoint = endPoints[0];
        }
        
        if(endpoint != null){
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
        
        writeLog ('REQ', null, null, 0);
        writeLog ('RES', request.getBody(), response.getBody(), response.getStatusCode());

        return response;
        
    }     
    
    public class NumerosMotivosJson{       
        public List<listaNumerosMotivos> ListaNumeros {get;set;}
        
        public NumerosMotivosJson(){
           ListaNumeros = new List<listaNumerosMotivos>();
        }
    }
    
    public class listaNumerosMotivos{
        public String nroLinea {get;set;}
        public String Accion {get;set;}
    }

}