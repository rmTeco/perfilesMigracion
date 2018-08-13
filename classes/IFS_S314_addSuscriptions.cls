public class IFS_S314_addSuscriptions {
    
    public static Map<String,Object> addSuscriptions(String nroLinea, String codSuscripcion, String codInteraccionNegocio, String codInterfazComunicacion, String codCanal, String palabraClaveSVA,  Map<String,Object> FiltrosExtra){
        
        addSuscriptionsJson jsonParse = new addSuscriptionsJson();
        List<FiltrosExtra> filtrosExtraList = new list<FiltrosExtra>();
        
        for(String Cons : FiltrosExtra.keySet()){
            FiltrosExtra filtro = new FiltrosExtra();
            filtro.nombreParametro=Cons;
            filtro.valorParametro=(String)FiltrosExtra.get(Cons);
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
        
        /*
        //Manejo de errores.
        Boolean hayError = false;        
        
        if (response.getStatusCode() == 400) {
            hayError=True;
            throw new CallOutException('Bad Request. La solicitud contiene sintaxis errónea y no debería repetirse.');
        }
        /////////////////////////////Errores definidos por IDD: BEGIN//////////////////////////////////////////
        if (response.getStatusCode() == 010) {
            hayError=True;
            throw new CallOutException('Error no definido por Infotaiment.');
        }
        if (response.getStatusCode() == 497) {
            hayError=True;
            throw new CallOutException('Error datos de autenticación.');
        }
        if (response.getStatusCode() == 544) {
            hayError=True;
            throw new CallOutException('Error al validar los datos de entrada.');
        }
        if (response.getStatusCode() == 551) {
            hayError=True;
            throw new CallOutException('Servicio inactivo o inexistente.');
        }
        if (response.getStatusCode() == 595) {
            hayError=True;
            throw new CallOutException('Error genérico en el sistema Infotaiment.');
        }
        if (response.getStatusCode() == 601) {
            hayError=True;
            throw new CallOutException('El servicio no tiene configurado un canal para enviar el optin al usuario.');
        }
        if (response.getStatusCode() == 602) {
            hayError=True;
            throw new CallOutException('Error al enviar pedido de confirmación al usuario');
        }
        if (response.getStatusCode() == 603) {
            hayError=True;
            throw new CallOutException('Esperando confirmación del usuario.');
        }
        if (response.getStatusCode() == 604) {
            hayError=True;
            throw new CallOutException('El usuario ya se encuentra suscripto.');
        }
        if (response.getStatusCode() == 100002) {
            hayError=True;
            throw new CallOutException('Error de Autorización. El usuario no tiene los permisos necesario para ejecutar el servicio.');
        }
        if (response.getStatusCode() == 100003) {
            hayError=True;
            throw new CallOutException('Sesión vencida.');
        }
        /////////////////////////////Errores definidos por IDD: END//////////////////////////////////////////
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