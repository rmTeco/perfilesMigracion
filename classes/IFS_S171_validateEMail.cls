public class IFS_S171_validateEMail {
    
    public static Map<String,Object> validateEMail(String mail){
        
        HttpResponse response = makePostCallout(mail);
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        responseNode.put('httpStatusCode',(String.valueOf(response.getStatusCode())));
        return responseNode;
    }
    
    public static HttpResponse makePostCallout(String id) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        List<EndPointService__c> endPoints = [select Name, EndPoint__c from EndPointService__c where Name = 'IFS_s171' limit 1];
        String campo='email';
        IFS_EndpointFixer fixer = new IFS_EndpointFixer();
        EndPointService__c endpoint;
        if(endPoints.size()>0){
            endpoint = endPoints[0];
        }
        //String endpointTEMP='http://exeo.mockable.io/email/'+id+'/envio';
        //endpointTEMP='http://exeo.mockable.io/arnet/email/{email}/validar';
        if(endpoint != null){
              endpoint.EndPoint__c=fixer.FixEndpoint(campo, id, endpoint);
              request.setEndpoint(endpoint.EndPoint__c);
        }
        
        //request.setEndpoint(endpointTEMP);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        String authorizationHeader = IFS_AuthorizationHeader.giveHeader();
        request.setHeader('Authorization', authorizationHeader);
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
    /*
public class conseguirDisponibilidadJSON{

public String idPuntoDeVenta {get;set;}
public String codDeposito {get;set;}
public String codMarca {get;set;}
public String codFamiliaProducto {get;set;}
public String NMU {get;set;}
public String codigoStock {get;set;}


}*/
    
}