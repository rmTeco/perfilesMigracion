@RestResource(urlMapping='/v1/integrationprocedure/queryFriendsAndFamily/*')
global with sharing class IFS_S453_queryFriendsAndFamily {

    @HttpPost
    global static void getPost() {
        Http http = new Http();
        Map<String, Object> resultado = null;
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        res.addHeader('Content-Type', 'application/json');
        IFS_S453_queryFriendsAndFamily_cls.ResultObj result = IFS_S453_queryFriendsAndFamily_cls.queryFriendsAndFamily(req.requestBody.toString());
        res.statuscode = result.resultCode;
        res.responseBody = result.resultMessage;
    }
}