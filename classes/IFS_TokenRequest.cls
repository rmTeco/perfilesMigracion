global with sharing class IFS_TokenRequest {
    public  List<String> makeTokenRequest() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();        
        request.setEndpoint('https://prodgonogo.personal.com.ar/oauth2/access_token?realm=/TuID');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        String username = 'BISC';
        String password = 'pass12345';
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' + 
            EncodingUtil.base64Encode(headerValue);        
        request.setHeader('Authorization', authorizationHeader);
        request.setBody('grant_type=password&username=u250004&password=Telecom2016');      
        HttpResponse response = http.send(request);
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        String accessToken = (String) responseNode.get('access_token');
        String tokenType = (String) responseNode.get('token_type');
        system.debug('response del server token');
        system.debug(response);
        //        system.debug('///////////////////////////Access Token//////////////////////////////');
        //        system.debug(accessToken);
        //        system.debug('///////////////////////////Token Type//////////////////////////////');
        //        system.debug(tokenType);
        List<String> results = new List<String>();
        results.add(accessToken);
        results.add(tokenType);
        return results;    
    }}