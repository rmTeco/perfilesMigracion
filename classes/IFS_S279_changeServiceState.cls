public class IFS_S279_changeServiceState {
    
    public static Map<String,Object> changeServiceState(String txId, String codServ, String status){
        
        String message='codServicio='+codServ+'&';
        message+='status='+status;
        if(String.isEmpty(message)){
            message='';
        }
        system.debug(message);
        /*
conseguirDisponibilidadJSON jsonParse = new conseguirDisponibilidadJSON();
jsonParse.idPuntoDeVenta = venta;
jsonParse.codDeposito = codeDep;
jsonParse.codMarca = codeMarc;
jsonParse.codFamiliaProducto = codFamProd;
jsonParse.NMU = NM;
jsonParse.codigoStock = codStock;
*/
        HttpResponse response = makePostCallout(message, txId);
        system.debug(response.getBody());
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        responseNode.put('httpStatusCode',(String.valueOf(response.getStatusCode())));
        return responseNode;
    }
    
    public static HttpResponse makePostCallout(String body, String id) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        List<EndPointService__c> endPoints = [select Name, EndPoint__c from EndPointService__c where Name = 'IFS_s279' limit 1];
        EndPointService__c endpoint;
        String campo = 'txId';
        IFS_EndpointFixer fixer = new IFS_EndpointFixer();
        if(endPoints.size()>0){
            endpoint = endPoints[0];
        }
        if(endpoint != null){
            endpoint.EndPoint__c=fixer.FixEndpointGetService(campo, id, endpoint,body);
            //endpoint.EndPoint__c=fixer.FixEndpoint(campo, id, endpoint);
            request.setEndpoint(endpoint.EndPoint__c);        }

        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        String authorizationHeader = IFS_AuthorizationHeader.giveHeader();
        request.setHeader('Authorization', authorizationHeader);
        HttpResponse response = http.send(request);
        system.debug(response);
        system.debug(response.getBody());        
        
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