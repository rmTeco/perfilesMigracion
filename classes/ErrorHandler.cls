/**
* @author Gustavo Mota 24/04/2018
* Provides logic support to Error Handler
*
*/
public class ErrorHandler{

    /**
     * Process the remote service response
     * @param serviceName Legacy Service
     * @param request Request Payload
     * @param response Response Payload     
     * @return body response Map
     */
    public static Map<String, Object> process(String serviceName, Map<String, Object> request, Map<String, Object> response){

       Map<String, Object> bodyResponse = (Map<String, Object>) response.get('IPResult');
       
      // System.debug('Error >>> service: ' + serviceName + ' - request: ' + request + ' - response: ' + response);

       if(bodyResponse == null)throw new JSONException();
                       
       return throwOrVerification(bodyResponse);
       
    }
    
   /**
    * Custom Exception related to configuration error code
    * @param bodyResponse Response Payload     
    * @return body response Map
    **/
    private static Map<String, Object> throwOrVerification(Map<String, Object> bodyResponse){

      String errorCode = (String)bodyResponse.get('codigo');

      if(errorCode == null)throw new NoDataFoundException();
    
      ErrorHandlerItem__c errorItem = ErrorHandlerItem__c.getValues(errorCode);

      if(errorItem == null)throw new NoDataFoundException();

      /*
       * Exception mapping :
       *    COM / COM0000138 > Communication error > CommunicationException
       *    DAT / DAT0000726 > Data error > DataErrorException
       *    SEG / SEG0000727 > Security error > SecurityException
       *    VAL   Validation  error > DataValidationException
       *    TEC / TEC0000149 / TEC0000190 >  Generic Error / System Technician Error > TechnicalException
       *    NEG / NEG0000219 > Business validation error > BussinessValidationException
       *    UNK   > Undefined error > UndefinedException
       */

      if(errorItem.ResultType__c.Contains('COM'))throw new CommunicationException(errorItem.ErrorMessage__c);
      if(errorItem.ResultType__c.Contains('DAT'))throw new DataErrorException(errorItem.ErrorMessage__c);
      if(errorItem.ResultType__c.Contains('SEG'))throw new SecurityException(errorItem.ErrorMessage__c);
      if(errorItem.ResultType__c.Contains('VAL'))throw new DataValidationException(errorItem.ErrorMessage__c);
      if(errorItem.ResultType__c.Contains('TEC'))throw new TechnicalException(errorItem.ErrorMessage__c);
      if(errorItem.ResultType__c.Contains('NEG'))throw new BussinessValidationException(errorItem.ErrorMessage__c);
      if(errorItem.ResultType__c.Contains('UNK') 
         || errorItem.ResultType__c.Contains('S/D') 
         || errorItem.ResultType__c.Contains(''))throw new UndefinedException(errorItem.ErrorMessage__c);
       
      return bodyResponse;
    }
    
}