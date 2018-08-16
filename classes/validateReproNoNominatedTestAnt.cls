@isTest(seeAllData = false)
global class validateReproNoNominatedTestAnt {
    static testMethod void validateReproNoNominatedTestAnt() {

    }  

    public static HttpResponse makePostCallout() {
        ToJson tojson = new ToJson();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://ta-dev--Desa01.cs63.my.salesforce.com/services/apexrest/v1/integrationprocedure/validateReproNoNominated');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        String authorizationHeader = IFS_AuthorizationHeader.giveHeader();
        request.setHeader('Authorization', authorizationHeader);
        request.setBodyAsBlob(Blob.valueOf(JSON.serialize(tojson)));
        HttpResponse response = http.send(request);
        system.debug(response);
        system.debug(response.getBody());
        
        return response;
        
    }     

    private Class ToJson {
        public TagNroClass validateReproNoNominated;
    }  
    
    private Class TagNroClass {
        public String nroLinea = '549111567501234';
    }
}