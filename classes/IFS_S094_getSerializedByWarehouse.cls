public class IFS_S094_getSerializedByWarehouse {
    
    public static Map<String,Object> getSerializedByWarehouse(String codDeposito, String codPuntoDeVenta, String codNMU, String stockProducto){
        String message = '';
        if(codPuntoDeVenta!=null){
            message+='codPuntoDeVenta='+codPuntoDeVenta+'&';
        }
        if(codNMU!=null){
            message+='codNMU='+codNMU+'&';
        }
        if(stockProducto!=null){
            message+='stockProducto='+stockProducto+'&';
        }
        if(String.isEmpty(message)){
            message='';
        }
        message = message.removeEnd('&');

        HttpResponse response = makePostCallout(codDeposito, message);
        system.debug(response.getBody());
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        responseNode.put('httpStatusCode',(String.valueOf(response.getStatusCode())));
        system.debug(responseNode);
        return responseNode;
    }
    
    public static HttpResponse makePostCallout(String id, String message) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        List<EndPointService__c> endPoints = [select Name, EndPoint__c from EndPointService__c where Name = 'IFS_s094' limit 1];
        String campo='codDeposito';
        IFS_EndpointFixer fixer = new IFS_EndpointFixer();
        EndPointService__c endpoint;
        if(endPoints.size()>0){
            endpoint = endPoints[0];
        }
        if(endpoint != null){
              endpoint.EndPoint__c=fixer.FixEndpointGetService(campo, id, endpoint, message);
              request.setEndpoint(endpoint.EndPoint__c);
        }
        //request.setEndpoint('http://52.67.109.234:8080/inventario/puntoVenta/1/getSerializedByWarehouse?idPuntoVenta=1&codDeposito=DFMULT001');
        //request.setEndpoint('http://52.67.109.234:8080/inventario/deposito/CS0134001?idPuntoVenta=1');
        //request.setEndpoint('https://prodgonogo.personal.com.ar/inventario/deposito/DFMULT001');
        //system.debug('///////////////////endpoint');

        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        String authorizationHeader = IFS_AuthorizationHeader.giveHeader();
        request.setHeader('Authorization', authorizationHeader);
        HttpResponse response = http.send(request);
        system.debug(response);
        //system.debug(response.getBody());   
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
public class tempJSON{

public String codDeposito {get;set;}
public String codPuntoDeVenta {get;set;}
public String codNMU {get;set;}
public String stockProducto {get;set;}


}*/
    

}