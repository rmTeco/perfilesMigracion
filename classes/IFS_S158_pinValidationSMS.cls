@RestResource(urlMapping='/v1/integrationprocedure/CustomerCare_CustomerValidation_pinValidationSMS/*')
global with sharing class IFS_S158_pinValidationSMS {

    @HttpPost
    global static void getData() {
        FromJSON jsonBody;
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        Map<String, String> msgSMS = new Map<String, String>();
        res.addHeader('Content-Type', 'application/json');
        try {
            jsonBody = (FromJSON)JSON.deserialize(req.requestBody.toString(),FromJSON.class);
            res.statuscode = 200;
          if (string.isBlank(jsonBody.pinValidationSMS.mensaje)) {
                CalloutException e = new CalloutException();
                e.setMessage('Mensaje vacio');
                throw e;
            }
            else {
                msgSMS.put('MSISDN',jsonBody.pinValidationSMS.nroLinea);
                msgSMS.put('BodySMS',jsonBody.pinValidationSMS.mensaje);
                taSalesSMSInteraction.ReceiveMessage(null,null, msgSMS);
            }
        }
        catch(Exception e){
            res.statuscode = 417;
            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaNoOk('417',e.getMessage())));
        }
    }

    private static List<Map<String, String>> getRespuestaNoOk(String pCodigo, String pDescripcion) {
        System.debug('Entre a getRespuestaNoOk()');
        Map<String, String> mapa = new Map<String, String>();
        List<Map<String, String>> lstErrors = new List<Map<String, String>>();
        mapa.put('errorCode', pcodigo);
        mapa.put('message', pDescripcion);
        lstErrors.add(mapa);
        return lstErrors;   
    }

     public class FromJSON {
        public FromJSON_1 pinValidationSMS; 
    }
     public class FromJSON_1 {
        public String nroLinea; 
        public String mensaje; 
    }
}