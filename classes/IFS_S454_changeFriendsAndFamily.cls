@RestResource(urlMapping='/v1/integrationprocedure/changeFriendsAndFamily/*')
global with sharing class IFS_S454_changeFriendsAndFamily {

    @HttpPost
    global static void getPost() {
        Http http = new Http();
        Map<String, Object> resultado = null;
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        res.addHeader('Content-Type', 'application/json');
        IFS_S454_changeFriendsAndFamily_cls ifsS454 = new IFS_S454_changeFriendsAndFamily_cls();
        IFS_S454_changeFriendsAndFamily_cls.ResultObj result = ifsS454.changeFriendsAndFamily(req.requestBody.toString());
        res.statuscode = result.resultCode;
        res.responseBody = Blob.valueOf(result.resultMessage);
    }
}