public class IFS_S121_numerosDisponibles {
    
    public static Map<String,Object> numerosDisponibles(Integer cantidad, String estado, String ciudad, String sufijo, String codOfi, String codVend, Integer codCu,String tipoLin, String idUnicoTransaccion){
        
        numerosDisponiblesJSON jsonParse = new numerosDisponiblesJSON();
        jsonParse.codProvincia = estado;
        //jsonParse.idReserva = idRes;
        jsonParse.codLocalidad = ciudad;
        if(tipoLin!=null){
            jsonParse.tipoLinea = tipoLin;
        } else {
            jsonParse.tipoLinea = null;
       }
        jsonParse.codTipoVenta = 'NOR';
        /*if(codTVen!=null){
            jsonParse.codTipoVenta = codTVen;
        } else {
            jsonParse.codTipoVenta = null;
        }*/
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

        //System.debug('ENDPOINT: ' + endpoint.EndPoint__c);

        System.debug('BODY: ' + body);
        
        //EndPointService__c endpoint = [select Name, EndPoint__c from EndPointService__c where Name = 'IFS_s121'];
        ///https://prodgonogo.personal.com.ar/movil/numerosDisponibles
        //request.setEndpoint('https://apit.telecom.com.ar/movil/numerosDisponibles');
        String authorizationHeader = IFS_AuthorizationHeader.giveHeader();
        request.setHeader('Authorization', authorizationHeader);
        //request.setHeader('x-global-transaction-id','1234678');
        request.setHeader('X-Consumer-Transaction-ID', idUnicoTransaccion);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        //request.setHeader('Authorization', tokenType+' '+accessToken);
        request.setBody(body);
        HttpResponse response = http.send(request);
        system.debug('POST response: '+response);
        
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