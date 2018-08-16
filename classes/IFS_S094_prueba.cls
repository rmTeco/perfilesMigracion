public class IFS_S094_prueba {

        public static String getSerializedByWarehouse(String codDeposito, String codPuntoDeVenta, String codNMU, String stockProducto){
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
 //       Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
//        responseNode.put('httpStatusCode',(String.valueOf(response.getStatusCode())));
//        system.debug(responseNode);
//        return responseNode;
        return response.getBody();
    }
    
    public static HttpResponse makePostCallout(String id, String message) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        List<EndPointService__c> endPoints = [select Name, EndPoint__c from EndPointService__c where Name = 'IFS_s094_PRU' limit 1];
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
        
        return response;
        
    }     

    
}