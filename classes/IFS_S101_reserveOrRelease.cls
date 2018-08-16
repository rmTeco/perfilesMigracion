public class IFS_S101_reserveOrRelease {
    
    public static Map<String,Object> reserveOrRelease(String operacion, String codAplicacion, String idOperacion, String codPuntoDeVenta, String idUnicoTransaccion, Map<String,Object> ListaNM ){
        List<NMU> NMUs = new List<NMU>();
        for(String NM : ListaNM.keySet()){
            NMU N = new NMU();
            Map<String,Object> aux = new Map<String,Object>();
            aux=(Map<String,Object>)ListaNM.get(NM);
            N.codNMU=(String)aux.get('codNMU');
            N.codDeposito=(String)aux.get('codDeposito');
            N.cantidad=(Integer)aux.get('cantidad');            
            NMUs.add(N);
        }
        
        reserveOrReleaseJSON jsonParse = new reserveOrReleaseJSON();
        jsonParse.listaNMU = NMUs;
        jsonParse.operacion = operacion;
        jsonParse.codAplicacion = codAplicacion;
        jsonParse.idOperacion = idOperacion;
        jsonParse.codPuntoDeVenta = codPuntoDeVenta;
        
        String body = JSON.serialize(jsonParse);
        System.debug('IFS_S101 - request: ' + body);
        HttpResponse response = makePostCallout(body, idUnicoTransaccion);
        system.debug(response.getbody());
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        responseNode.put('httpStatusCode',(String.valueOf(response.getStatusCode())));
        return responseNode;
    }
    
    @future 
    private static void writeLog (String pTipo, String pReq, String pRes, Integer pResStatus, String pUID) {
        System.debug('Entre en writeLog - pTipo --> ' + pTipo + ' - pReq --> ' + pReq + ' - pRes --> ' + pRes + ' - pResStatus --> ' + pResStatus);
        String dts = DateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'', 'America/Argentina/Buenos_Aires');

        String guId = String.isBlank(pUID) ? GuidUtil.NewGuid() : pUID;  
        if (pTipo == 'REQ') {
            IFS_LogRecord.record(dts, 'SERVICIO', 'S101', pTipo, guId, pReq, '');  
        }
        else {
            String datos = 'status code = ' + pResStatus + ' ; status = ; ';
            if (pResStatus < 300) {
                datos += 'request to DPW OK';
            }
            else {
                datos += 'request to DPW FAIL ; request body = ' + (String.isBlank(pReq)?'':pReq) + ' ; Response = ' + pRes;
            } 
            IFS_LogRecord.record(dts, 'SERVICIO', 'S101', pTipo, guId, '', datos);  
        }
    }
    
    public static HttpResponse makePostCallout(String body, String idUnicoTransaccion) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        List<EndPointService__c> endPoints = [select Name, EndPoint__c from EndPointService__c where Name = 'IFS_s101' limit 1];
        EndPointService__c endpoint;
        if(endPoints.size()>0){
            endpoint = endPoints[0];
        }
        
        if(endpoint != null){
            request.setEndpoint(endpoint.EndPoint__c);
        }
        
        request.setMethod('PUT');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        String authorizationHeader = IFS_AuthorizationHeader.giveHeader();
        request.setHeader('Authorization', authorizationHeader);
        request.setHeader('X-Consumer-Transaction-ID',idUnicoTransaccion);
        request.setBody(body);
        HttpResponse response = http.send(request);
        system.debug(response);
        system.debug(response.getBody());

        writeLog ('REQ', null, null, 0, idUnicoTransaccion);
        writeLog ('RES', request.getBody(), response.getBody(), response.getStatusCode(), idUnicoTransaccion);
        
        return response;
    }     
    
    public class NMU {
        String codNMU {get;set;}
        String codDeposito {get;set;}
        Integer cantidad {get;set;}
    }
    
    public class reserveOrReleaseJSON{
        public String operacion {get;set;}
        public String codAplicacion {get;set;}
        public String idOperacion {get;set;}
        public String codPuntoDeVenta {get;set;}
        public List<NMU> listaNMU {get;set;}
    }
}