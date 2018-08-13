public class IFS_S075_sendEmail {

public static Map<String, Object> sendEmail(Map<String,Object> mapa){
    String mail;
    requestJSON jsonParse = new requestJSON();
    for(String clave: mapa.keySet()){
        Map<String,Object> mapaAux = new Map<String,Object>();
        mapaAux = (Map<String,Object>)mapa.get(clave);
        
        jsonParse.CampaignName = (String) mapaAux.get('CampaignName');
        jsonParse.communicationDate = (String) mapaAux.get('CommunicationDate');
        jsonParse.communicationText = (String) mapaAux.get('CommunicationText');
        jsonParse.messageReference = (String) mapaAux.get('MessageReference');
        jsonParse.BodyFullCodeName = (String) mapaAux.get('BodyFullCodeName');
        
        Map<String,Object> mapaTarget = new Map<String,Object>();
        mapaTarget = (Map<String,Object>)mapaAux.get('Target');
        Map<String,Object> mapaUsuario = new Map<String,Object>();
        mapaUsuario = (Map<String,Object>)mapaTarget.get('User');
        Map<String,Object> mapaRawData = new Map<String,Object>();
        mapaRawData = (Map<String,Object>)mapaTarget.get('RawData');
        
        UserJson unUsuario = new UserJson();
        unUsuario.LastName = (String) mapaUsuario.get('LastName');
        unUsuario.CustomerNumber = (String) mapaUsuario.get('CustomerNumber');
        unUsuario.Name = (String) mapaUsuario.get('Name'); 
        unUsuario.Mail = (String) mapaUsuario.get('Mail'); 
        unUsuario.Celnumber = (String) mapaUsuario.get('Celnumber');
        mail=unUsuario.Mail;
        TargetJSON unTarget = new TargetJSON();
        for(String raw : mapaRawData.keySet()){
            Map<String,Object> mapaAuxRaw = new Map<String,Object>();
            mapaAuxRaw = (Map<String,Object>) mapaRawData.get(raw);
            RawDataJson unRawData = new RawDataJson();
            unRawData.Key = (String) mapaAuxRaw.get('Key');
            unRawData.Value = (String) mapaAuxRaw.get('Value');
            unTarget.RawData.add(unRawData);                
        }

        
        unTarget.user = unUsuario;        
        jsonParse.Target = unTarget;
    }
    
    String body = JSON.serialize(jsonParse);
    
    system.debug(body);
    
    HttpResponse respuesta = makePostCallout(body, mail);
    Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(respuesta.getBody());
    responseNode.put('httpStatusCode',(String.valueOf(respuesta.getStatusCode())));        
    return responseNode; 
    
}

public static HttpResponse makePostCallout(String body, String id) {
    Http http = new Http();
    String campo='email';
    IFS_EndpointFixer fixer = new IFS_EndpointFixer();
    HttpRequest request = new HttpRequest();
    
    List<EndPointService__c> endPoints = [select Name, EndPoint__c from EndPointService__c where Name = 'IFS_s075' limit 1];
    EndPointService__c endpoint;
    if(endPoints.size()>0){
        endpoint = endPoints[0];
    }
    
    if(endpoint != null){
        endpoint.EndPoint__c=fixer.FixEndpoint(campo, id, endpoint);
        request.setEndpoint(endpoint.EndPoint__c);
    }
    //request.setEndpoint('https://prodgonogo.personal.com.ar/email/{email}/envio');
    request.setMethod('POST');
    request.setHeader('Content-Type', 'application/json;charset=UTF-8');
    String authorizationHeader = IFS_AuthorizationHeader.giveHeader();
    request.setHeader('Authorization', authorizationHeader);
    request.setBody(body);
    system.debug(request.getBody());
    HttpResponse response = http.send(request);
    system.debug(response);
    
    
    
    return response;
    
}

public class requestJSON{
    
    public String CampaignName {get;set;}
    public TargetJSON Target {get;set;}
    public String CommunicationDate {get;set;}
    public String CommunicationText {get;set;}
    public String MessageReference {get;set;}
    public String BodyFullCodeName {get;set;}
}

public class TargetJSON{
    
    public UserJson User {get;set;}
    public List<RawDataJson> RawData {get;set;}
    public TargetJSON (){
        RawData = new List<RawDataJson>();
    }
}

public class UserJson{
    
    public String LastName {get;set;}
    public String Name {get;set;}
    public String Mail {get;set;}
    public String Celnumber {get;set;}
    public String CustomerNumber {get;set;}
}

public class RawDataJson{
    
    public String Key {get;set;}
    public String Value {get;set;}
}
}