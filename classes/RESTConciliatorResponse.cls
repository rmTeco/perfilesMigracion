/**
 * Created by joaquininurrategui on 10/23/17.
 */
@RestResource(urlMapping='/ConciliatorUpdateCase')
global with sharing class RESTConciliatorResponse {

  @HttpPatch
  global static String UpdateCase(String CaseId, String IntResponse){
    try {
      Case CasetoUpdate = [SELECT Id, Status FROM Case WHERE ID = :CaseId and Status = 'Resuelta Exitosa'];
      If(intResponse == 'Ok'){
        // TODO - SEND NOTIFICATION TU CUSTOMER WITH CONCILIATION REPSPONSE OK
        CasetoUpdate.Status = 'Realizada exitosa';
        
        SendSMS('12345679','mensaje');
        
      }else{
        // TODO - SEND NOTIFICATION TU CUSTOMER WITH CONCILIATION REPSPONSE NOT OK
        CasetoUpdate.Status = 'Cerrado';
      }
      update CasetoUpdate;


      return 'Case Updated';
    }catch (exception e){
      return e.getMessage();
    }
  }
  
      public static void SendSMS(String phone, String msj){
      	
    	Map<String, Object> output = new Map<String, Object>();
    	Map<String, Object> input = new Map<String, Object>();
    	Map<String, Object> options = new Map<String, Object>();

    	Map<String, String> parms = new Map<String, String>();
    	parms.put('nroLinea', phone);
    	input.put('params', parms);

    	Map<String, Object> body = new Map<String, Object>();
    	body.put('communicationText', msj);
    	body.put('communicationDate', DateTime.now());
    	body.put('channelName', 'SMS');
		  body.put('campaignName', SMSSender__c.getInstance('S-Confirmacion-SMS'));

    	input.put('body', body);

    	vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
        
        integProcServ.invokeMethod('IFS_S159', input, output, options);

        Map<String, Object> response = (Map<String, Object>) output.get('IPResult');

        String execCode = (String) response.get('executionCode');

        if(execCode != 'OK')
        	if(!Test.isRunningTest())
          {
            throw new FuncException('Error inesperado al enviar el SMS: ' + output);
          }        	
    }

}