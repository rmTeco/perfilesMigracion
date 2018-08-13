public class IFS_S277_activateChangeInternetService {

    public static Map<String,Object> activateChangeInternetService(String tx, String codAc, String codSer, String tipoServ, String prod, String codUs, String codAccUs, String usDomain, String numLin,String iServProv, String descArServ, String arCode, String accessTyp, String accessPro, String net, String internetProtocol, String dynd, String tcp, String turb, String content){
        
        activateChangeInternetServiceJSON jsonParse = new activateChangeInternetServiceJSON();
        jsonParse.txId = tx;
        jsonParse.codAccionGenerica = codAc;
        jsonParse.codServicio = codSer;
        jsonParse.tipoServicioInternet = tipoServ;
        if(prod!=null){
        	jsonParse.product = prod;}
        if(codUs!=null){
        	jsonParse.codUsuario = codUs;}
        if(codAccUs!=null){
        	jsonParse.codAccesoUsuario = codAccUs;}
        if(usDomain!=null){
        	jsonParse.userDomain = usDomain;}
        if(numLin!=null){
        	jsonParse.nroLinea = numLin;}
        if(iServProv!=null){
        	jsonParse.isp = iServProv;}
        if(descArServ!=null){
        	jsonParse.descripcionAreaDeServicio = descArServ;}
        if(arCode!=null){
        	jsonParse.ar = arCode;}
        if(accessTyp!=null){
        	jsonParse.AccessType = accessTyp;}
        if(accessPro!=null){
        	jsonParse.AccessProfile = accessPro;}
        if(net!=null){
        	jsonParse.network = net;}
        if(internetProtocol!=null){
        	jsonParse.IP = internetProtocol;}
        if(dynd!=null){
        	jsonParse.dyndns = dynd;}
        if(tcp!=null){
        	jsonParse.tcp25 = tcp;}
        if(turb!=null){
        	jsonParse.turbo = turb;}
        if(content!=null){
        	jsonParse.contentFilter = content;}
        
        String body = JSON.serialize(jsonParse);
        HttpResponse response = makePostCallout(body);
        system.debug(response.getBody());
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        responseNode.put('httpStatusCode',(String.valueOf(response.getStatusCode())));
        return responseNode;
    }
    
    public static HttpResponse makePostCallout(String body) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        List<EndPointService__c> endPoints = [select Name, EndPoint__c from EndPointService__c where Name = 'IFS_s277' limit 1];
        EndPointService__c endpoint;
        if(endPoints.size()>0){
            endpoint = endPoints[0];
        }
        
        if(endpoint != null){
            request.setEndpoint(endpoint.EndPoint__c);
        }
        ///Falta setear el endpoint de esta clase.
        ///https://prodgonogo.personal.com.ar/movil/numerosDisponibles
        //request.setEndpoint('https://prodgonogo.personal.com.ar/movil/numerosDisponibles');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        String authorizationHeader = IFS_AuthorizationHeader.giveHeader();
        request.setHeader('Authorization', authorizationHeader);
        request.setBody(body);
        HttpResponse response = http.send(request);
        system.debug('POST response: '+response);

        return response;
        
    }     
    
    public class activateChangeInternetServiceJSON{
        
        public String txId {get;set;}
        public String codAccionGenerica {get;set;}
        public String codServicio {get;set;}
        public String tipoServicioInternet {get;set;}
        public String product {get;set;}
        public String codUsuario {get;set;}
        public String codAccesoUsuario {get;set;}
        public String userDomain {get;set;}
        public String nroLinea {get;set;}
        public String isp {get;set;}
        public String descripcionAreaDeServicio {get;set;}
        public String ar {get;set;}
        public String AccessType {get;set;}
        public String AccessProfile {get;set;}
        public String network {get;set;}
        public String IP {get;set;}
        public String dyndns {get;set;}
        public String tcp25 {get;set;}
        public String turbo {get;set;}
        public String contentFilter {get;set;}
    }
    
}