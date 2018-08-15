@istest
public class RESTConciliatorResponseTest{

    static testMethod void  updateMethodTest(){
        Case  Testcase=new Case ();
        Testcase.status = 'En proceso de ejecución';
        insert Testcase;
        RESTConciliatorResponse reqst=new RESTConciliatorResponse();
        String JsonMsg=JSON.serialize(reqst);
        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/ConciliatorUpdateCase';  //Request URL
        req.httpMethod = 'Patch';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        String resp = RESTConciliatorResponse.UpdateCase(Testcase.id, 'Ok');
        Test.stopTest();

        //System.assertEquals('Case Updated', resp);
    }

    static testMethod void  updateMethodTestNotOk(){
        Case  Testcase=new Case ();
        Testcase.status = 'En proceso de ejecución';
        insert Testcase;
        RESTConciliatorResponse reqst=new RESTConciliatorResponse();
        String JsonMsg=JSON.serialize(reqst);
        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/ConciliatorUpdateCase';  //Request URL
        req.httpMethod = 'Patch';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        String resp = RESTConciliatorResponse.UpdateCase(Testcase.id, 'failed');
        Test.stopTest();

        //System.assertEquals('Case Updated', resp);
    }

    static testMethod void  updateMethodexception(){
        RESTConciliatorResponse reqst=new RESTConciliatorResponse();
        String JsonMsg=JSON.serialize(reqst);
        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/ConciliatorUpdateCase';  //Request URL
        req.httpMethod = 'Patch';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        String resp = RESTConciliatorResponse.UpdateCase('asd', 'Ok');
        String s = '12345678';
        String s1 = 'prueba de SMS';
        RESTConciliatorResponse.SendSMS(s, s1);
        Test.stopTest();

        System.assertNotEquals('Case Updated', resp);
    }
}