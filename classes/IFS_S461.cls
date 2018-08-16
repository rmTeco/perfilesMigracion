@RestResource(urlMapping='/v1/integrationprocedure/getLoyaltyPoints/*')
global with sharing class IFS_S461 {
    
    @HttpPost
    global static Response getLoyaltyPoints(Request getLoyaltyPoints) {
        
        List<GP_Lista_de_Asset__c> listaDeAssets = new List<GP_Lista_de_Asset__c>();
        if(!String.isBlank(getLoyaltyPoints.choiceId.subscriberId)){
             
             listaDeAssets = [select id, Socio__r.cuenta__c, Socio__r.Socio_padre__c, Socio__r.Socio_padre__r.cuenta__c,
                              Socio__r.Socio_padre__r.Saldo_total__c, socio__r.Saldo_total__c 
                              from GP_Lista_de_Asset__c 
                              where suscriber_id__c =: getLoyaltyPoints.choiceId.subscriberId limit 1];
        }else{
            if(!String.isBlank(getLoyaltyPoints.choiceId.numeroLinea)){
                
                 listaDeAssets = [select id, Socio__r.cuenta__c, Socio__r.Socio_padre__c, Socio__r.Socio_padre__r.cuenta__c,
                                  Socio__r.Socio_padre__r.Saldo_total__c, socio__r.Saldo_total__c 
                                  from GP_Lista_de_Asset__c 
                                  where MSISDN__c =: getLoyaltyPoints.choiceId.numeroLinea limit 1];
            }
        }
        
         Response respuesta = new Response();
         if(listaDeAssets.size()>0){
             if(listaDeAssets[0].socio__r.socio_padre__c == null){
                 respuesta.pointsBalance = String.valueOf(listaDeAssets[0].socio__r.Saldo_total__c);
             }else{
                respuesta.pointsBalance = String.valueOf((Double) gp_api.consultarPuntos(listaDeAssets[0].Socio__r.Socio_padre__r.cuenta__c,listaDeAssets[0].socio__r.cuenta__c).get('totalPuntosDisponibles'));
             }
         }
         
         return respuesta; 
    }

    global class Request {
        global choice choiceId {get;set;}

    }
    
    global class choice {
        global String subscriberId {get;set;}
        global String numeroLinea {get;set;}
    }
    
    global class Response {
        global String pointsBalance { get; set; }
        
    }
    
}