public class IFS_S105_stockMovement {

    public static Map<String,Object> stockMovement(Map<String,Object> operationList, String idUnicoTransaccion){
        
        operacionesJson jsonParse = new operacionesJson();
        List<Operacion> listaOperacion = new list<Operacion>();
        
        for(String Cons : operationList.keySet()){
            Map<String,Object> aux = new Map<String,Object>();
            aux=(Map<String,Object>)operationList.get(cons);
            Operacion op = new Operacion();
            op.codOperacion=(String)aux.get('codOperacion');
            op.numeroSerie=(String)aux.get('numeroSerie');
            //op.cantidad=(Integer)aux.get('cantidad');
            op.codDeposito=(String)aux.get('codDeposito');
            listaOperacion.add(op);
        }
        
        jsonParse.listaOperacion = listaOperacion;        
        String body = JSON.serialize(jsonParse);
        HttpResponse response = makePostCallout(body, idUnicoTransaccion);
        system.debug(response.getBody());
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        responseNode.put('httpStatusCode',(String.valueOf(response.getStatusCode())));
        return responseNode;
    }
    
    public static HttpResponse makePostCallout(String body, String idUnicoTransaccion) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        List<EndPointService__c> endPoints = [select Name, EndPoint__c from EndPointService__c where Name = 'IFS_s105' limit 1];
        EndPointService__c endpoint;
        if(endPoints.size()>0){
            endpoint = endPoints[0];
        }
        
        if(endpoint != null){
            request.setEndpoint(endpoint.EndPoint__c);
        }
        
        //request.setEndpoint('https://prodgonogo.personal.com.ar/stock/movimiento');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        //request.setHeader('x-global-transaction-id','1234678');
        String authorizationHeader = IFS_AuthorizationHeader.giveHeader();
        request.setHeader('Authorization', authorizationHeader);
        request.setHeader('X-Consumer-Transaction-ID', idUnicoTransaccion);
        request.setBody(body);
        system.debug(request.getBody());
        HttpResponse response = http.send(request);
        system.debug(response);
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
    
    public class operacionesJson{       
        public List<Operacion> listaOperacion {get;set;}
        
        public operacionesJson(){
           listaOperacion = new List<Operacion>();
        }
    }
    
    public class Operacion{
        public String codOperacion {get;set;}
        public String numeroSerie {get;set;}
        //public Integer cantidad {get;set;}
        public String codDeposito {get;set;}

    }

}