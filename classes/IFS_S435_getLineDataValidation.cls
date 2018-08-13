@RestResource(urlMapping='/v1/integrationprocedure/CustomerCare_Portability_getLineDataValidation/*')
global with sharing class IFS_S435_getLineDataValidation {

    @HttpPost
    global static void getPost() {
        Http http = new Http();
        Map<String, Object> resultado = null;
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        res.addHeader('Content-Type', 'application/json');
        IFS_S435_getLineDataValidation_cls.ResultObj result = IFS_S435_getLineDataValidation_cls.getLineDataValidation(req.requestBody.toString());
        res.statuscode = result.resultCode;
        res.responseBody = result.resultMessage;
    }
}