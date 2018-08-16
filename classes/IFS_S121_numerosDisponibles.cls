public class IFS_S121_numerosDisponibles {

    public static Map<String,Object> numerosDisponibles(Integer cantidad, String estado, String ciudad, String sufijo, String codOfi, String codVend, Integer codCu,String tipoLin, String idUnicoTransaccion){
        
        numerosDisponiblesJSON jsonParse = new numerosDisponiblesJSON();
        jsonParse.codProvincia = estado;
        jsonParse.codLocalidad = ciudad;
        if(tipoLin!=null){
            jsonParse.tipoLinea = tipoLin;
        } else {
            jsonParse.tipoLinea = null;
       }
        jsonParse.codTipoVenta = 'NOR';
        jsonParse.cantLineas = cantidad;
        if(codCu!=null){
            jsonParse.codCuenta = codCu;
        } else {
            jsonParse.codCuenta = null;
        }
        if(codVend!=null){
            jsonParse.codVendedor = codVend;
        } else {
           jsonParse.codVendedor = null;
        }
        if(codOfi!=null){
            jsonParse.codOficinaComercial = codOfi;
        } else {
            jsonParse.codOficinaComercial = null;
       }
        if(sufijo!=null){
            jsonParse.terminacionLinea = sufijo;
        } else {
            jsonParse.terminacionLinea = null;
       }
        String body = JSON.serialize(jsonParse);
        System.debug('IFS_S121_numerosDisponibles:body: ' + body);
        HttpResponse response = makePostCallout(body, idUnicoTransaccion);
        system.debug(response.getBody());
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        responseNode.put('httpStatusCode',(String.valueOf(response.getStatusCode())));
        return responseNode;
    }
    
    /**
     * Wrapper del IFS_LogRecord.record
     */
    @future 
    private static void writeLog (String pTipo, String pReq, String pRes, Integer pResStatus, String pUID) {
        System.debug('Entre en writeLog - pTipo --> ' + pTipo + ' - pReq --> ' + pReq + ' - pRes --> ' + pRes + ' - pResStatus --> ' + pResStatus);
        String dts = DateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'', 'America/Argentina/Buenos_Aires');

        String guId = String.isBlank(pUID) ? GuidUtil.NewGuid() : pUID;  
        if (pTipo == 'REQ') {
            IFS_LogRecord.record(dts, 'SERVICIO', 'S121', pTipo, guId, pReq, '');  
        }
        else {
            String datos = 'status code = ' + pResStatus + ' ; status = ; ';
            if (pResStatus < 300) {
                datos += 'request to DPW OK';
            }
            else {
                datos += 'request to DPW FAIL ; request body = ' + (String.isBlank(pReq)?'':pReq) + ' ; Response = ' + pRes;
            } 
            IFS_LogRecord.record(dts, 'SERVICIO', 'S121', pTipo, guId, '', datos);  
        }
    }

    public static HttpResponse makePostCallout(String body, String idUnicoTransaccion) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        List<EndPointService__c> endPoints = new List <EndPointService__c>(); 
        endPoints = [select Name, EndPoint__c from EndPointService__c where Name = 'IFS_s121' limit 1];
        EndPointService__c endpoint;
        if(endPoints.size()>0){
            endpoint = endPoints[0];
        }
        
        if(endpoint != null){
            request.setEndpoint(endpoint.EndPoint__c);
        }

        System.debug('BODY: ' + body);
        
        idUnicoTransaccion = String.isBlank(idUnicoTransaccion) ? GuidUtil.NewGuid() : idUnicoTransaccion;  

        String authorizationHeader = IFS_AuthorizationHeader.giveHeader();
        request.setHeader('Authorization', authorizationHeader);
        request.setHeader('X-Consumer-Transaction-ID', idUnicoTransaccion);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(body);
        HttpResponse response = http.send(request);
        system.debug('POST response: '+response);
        
        writeLog ('REQ', null, null, 0, idUnicoTransaccion);
        writeLog ('RES', request.getBody(), response.getBody(), response.getStatusCode(), idUnicoTransaccion);

        return response;
    }     
    
    public class numerosDisponiblesJSON{
        public String idReserva {get;set;}
        public String codLocalidad {get;set;}
        public String codProvincia {get;set;}
        public String tipoLinea {get;set;}
        public String codTipoVenta {get;set;}
        public Integer cantLineas {get;set;}
        public Integer codCuenta {get;set;}
        public String codVendedor {get;set;}
        public String codOficinaComercial {get;set;}
        public String terminacionLinea {get;set;}
    }
    
}