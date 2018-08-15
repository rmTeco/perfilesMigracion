public class IFS_S326_updateNumberStatus {

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
    private static void writeLog (String pTipo, String pDatos, String guId) {
        DateTime dt = DateTime.now();
        String dts = dt.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');

        if (pTipo == 'REQ') {
            guId = GuidUtil.NewGuid(); //-- Calculo el Guid.
            //IFS_LogRecord.record(dts, 'SERVICIO', 'S326', guId, pTipo, pDatos, '');  
        }
        else {
            //IFS_LogRecord.record(dts, 'SERVICIO', 'S326', guId, pTipo, '', pDatos); 
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
        

        //request.setEndpoint('https://prodgonogo.personal.com.ar/lineas/estado');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        String authorizationHeader = IFS_AuthorizationHeader.giveHeader();
        request.setHeader('Authorization', authorizationHeader);
        request.setBody(body);
        system.debug(request.getBody());

        writeLog ('REQ', request.getBody(), guId);

        HttpResponse response = http.send(request);
        system.debug(response);
        
        writeLog ('RES', response.getStatusCode() + ';' + response.getBody(), guId);

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