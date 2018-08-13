public class IFS_S150_obtenerPreguntasIdentidad  {    
    public static Map<String, Object>  obtenerPreguntasIdentidad(String tipoDocumento, String numeroDocumento, String genero, String fechaNacimiento, String codCuestionario, String token ){
        
        ObtenerPreguntasIdentidadJSON jsonParse = new ObtenerPreguntasIdentidadJSON();
        jsonParse.tipoDocumento = tipoDocumento;
        jsonParse.numeroDocumento = numeroDocumento;
        jsonParse.genero = genero;
        jsonParse.fechaNacimiento = fechaNacimiento;
        jsonParse.codCuestionario = codCuestionario;
        jsonParse.token = token;


        String body = JSON.serialize(jsonParse);
        
        system.debug(body);
        HttpResponse respuesta = makePostCallout(body);
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(respuesta.getBody());
        responseNode.put('httpStatusCode',(String.valueOf(respuesta.getStatusCode())));
        return responseNode; 

        
    } 
    
    
    
    public static HttpResponse makePostCallout(String body) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        List<EndPointService__c> endPoints = [select Name, EndPoint__c from EndPointService__c where Name = 'IFS_s150' limit 1];
        EndPointService__c endpoint;
        if(endPoints.size()>0){
            endpoint = endPoints[0];
        }
        
        if(endpoint != null){
            request.setEndpoint(endpoint.EndPoint__c);
        }
        //request.setEndpoint('https://prodgonogo.personal.com.ar/cliente/preguntas/obtener');
        //request.setEndpoint('http://52.67.109.234:8080/IFS_S150_getQuestions_ReportesOnline/cliente/preguntas/obtener');
        
        //request.setEndpoint(endpoint.EndPoint__c);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        String authorizationHeader = IFS_AuthorizationHeader.giveHeader();
        request.setHeader('Authorization', authorizationHeader);
        request.setBody(body);
        HttpResponse response = http.send(request);
        system.debug(response);
        system.debug(response.getBody());

        /*
        //Manejo de errores.
        Boolean hayError = false;
        if (response.getStatusCode() == 227) {
            hayError = true;
            throw new CallOutException('Error no definido por ADS');
        }
        if (response.getStatusCode() == 323) {
            hayError = true;
            throw new CallOutException('Tipo de documento No Homologado');
        }
        if (response.getStatusCode() == 608) {
            hayError = true;
            throw new CallOutException('Documento Invalido');
        }
        if (response.getStatusCode() == 450) {
            hayError = true;
            throw new CallOutException('El genero ingresado no es correcto');
        }
        if (response.getStatusCode() == 381) {
            hayError = true;
            throw new CallOutException('No se encontraron datos para mostrar');
        }
        if (response.getStatusCode() == 190) {
            hayError = true;
            throw new CallOutException('Error del proveedor del Servicio');
        }
        if (response.getStatusCode() == 30) {
            hayError = true;
            throw new CallOutException('El documento ingresado corresponde a un menor de edad');
        }
        if (response.getStatusCode() == 451) {
            hayError = true;
            throw new CallOutException('El documento se encuentra bloqueado');
        }        
        if (response.getStatusCode() == 452) {
            hayError = true;
            throw new CallOutException('Validacion rechazada para el documento ingresado');
        }
        if (response.getStatusCode() == 453) {
            hayError = true;
            throw new CallOutException('Fecha de nacimiento incorrecta');
            
        }
        if (response.getStatusCode() == 454) {
            hayError = true;
            throw new CallOutException('El documento ingresado corresponde a un fallecido');
        }
        if (response.getStatusCode() == 474) {
            hayError = true;
            throw new CallOutException('El documento ingresado corresponde a un habeas data');
        }
        
        //else
        if(response.getStatusCode() != 200 && !hayError){
            throw new CallOutException('Error no definido por ADS');
        }
        */
        return response;
        
    }        
    
    public class ObtenerPreguntasIdentidadJSON{
        public String token {get;set;}
        public String tipoDocumento {get;set;}
        public String numeroDocumento {get;set;}
        public String genero {get;set;}
        public String fechaNacimiento {get;set;}
        public String codCuestionario {get;set;}
        
    }
}