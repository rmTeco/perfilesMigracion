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
    
    public static HttpResponse makePostCallout(String body, String idUnicoTransaccion) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        //////////////////////FALTA ASIGNAR EL ENDPOINT CORRECTO, NO HAY MOCK O PATH/////////////////////
        List<EndPointService__c> endPoints = [select Name, EndPoint__c from EndPointService__c where Name = 'IFS_s101' limit 1];
        EndPointService__c endpoint;
        if(endPoints.size()>0){
            endpoint = endPoints[0];
        }
        
        if(endpoint != null){
            request.setEndpoint(endpoint.EndPoint__c);
        }
        request.setMethod('PUT');
        //request.setMethod('POST');//Jorge, cambiar antes de migrar
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        String authorizationHeader = IFS_AuthorizationHeader.giveHeader();
        request.setHeader('Authorization', authorizationHeader);
        request.setHeader('X-Consumer-Transaction-ID',idUnicoTransaccion);
        request.setBody(body);
        HttpResponse response = http.send(request);
        system.debug(response);
        system.debug(response.getBody());
        
        /* 
        //Manejo de errores.
        Boolean hayError = false;
        
        if (response.getStatusCode() == 400) {
            hayError=True;
            throw new CallOutException('Bad Request. La solicitud contiene sintaxis errónea y no debería repetirse.');
        }
        if (response.getStatusCode() == 401) {
            hayError=True;
            throw new CallOutException('Unauthorized. Usuario no autorizado. Falló la autenticación.');
            
        }
        if (response.getStatusCode() == 403) {
            hayError=True;
            throw new CallOutException('Forbidden. No tiene los privilegios para hacer la solicitud que desea.');
            
        }
        if (response.getStatusCode() == 404) {
            hayError=True;
            throw new CallOutException('Recurso no encontrado. El servicio no encuentra el recurso solicitado.');
            
        }
        if (response.getStatusCode() == 405) {
            hayError=True;
            throw new CallOutException('Method not allowed. El método solicitado no es soportado por el servicio.');
            
        }
        if (response.getStatusCode() == 408) {
            hayError=True;
            throw new CallOutException('Request Timeout. No se obtuvo respuesta de la plataforma servidora.');
            
        }
        if (response.getStatusCode() == 418) {
            hayError=True;
            throw new CallOutException('Error controlado. Error funcional o de plataforma que se encuentra especificado.');
            
        }
        
        if (response.getStatusCode() == 500) {
            hayError=True;
            throw new CallOutException('Error no controlado.');
            
        }*/
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