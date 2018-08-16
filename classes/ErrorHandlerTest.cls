/**
* @author Gustavo Mota 25/04/2018
* Provides logic support to TEST of Error Handler
*/
@isTest
private class ErrorHandlerTest{

  static String serviceTestName = 'TEST-SERVICE';

  @testSetup static void setup() {

    upsert new ErrorHandlerItem__c(
        Name = 'TEST-OK-Communication',
        ResultType__c = 'COM'
    );

    upsert new ErrorHandlerItem__c(
        Name = 'TEST-OK-Dat',
        ResultType__c = 'DAT'
    );
    
    upsert new ErrorHandlerItem__c(
        Name = 'TEST-OK-Sec',
        ResultType__c = 'SEG'
    );  

    upsert new ErrorHandlerItem__c(
        Name = 'TEST-OK-Val',
        ResultType__c = 'VAL'
    );  

    upsert new ErrorHandlerItem__c(
        Name = 'TEST-OK-Tec',
        ResultType__c = 'TEC'
    );  

    upsert new ErrorHandlerItem__c(
        Name = 'TEST-OK-Neg',
        ResultType__c = 'NEG'
    );  

    upsert new ErrorHandlerItem__c(
        Name = 'TEST-OK-Unk',
        ResultType__c = 'UNK'
    );      
      
  }

  @isTest static void runPositiveCommunicationTestCases() {
    try{
        Map<String, Object> requestTest = new Map<String, Object>();
        String myJson = '{"IPResult" : {"mensaje":"Error de datos - OCS","codigo":"TEST-OK-Communication","detalle":[{"mensaje":"Error de datos - OCS","campo":"DAT0000140"},{"mensaje":"The subscriber does not exist.","campo":"102050156"}]}}';  
        Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(myJson);    
        ErrorHandler.process(serviceTestName, requestTest, response);
    }catch(Exception ex){   
        System.assertEquals(true, ex instanceof CommunicationException);    
    }
  }

  @isTest static void runPositiveDataErrorTestCases() {
    try{
        Map<String, Object> requestTest = new Map<String, Object>();
        String myJson = '{"IPResult" : {"mensaje":"Error de datos - OCS","codigo":"TEST-OK-Dat","detalle":[{"mensaje":"Error de datos - OCS","campo":"DAT0000140"},{"mensaje":"The subscriber does not exist.","campo":"102050156"}]}}';  
        Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(myJson);    
        ErrorHandler.process(serviceTestName, requestTest, response);
    }catch(Exception ex){   
        System.assertEquals(true, ex instanceof DataErrorException);    
    }
  }

  @isTest static void runPositiveSecurityTestCases() {
    try{
        Map<String, Object> requestTest = new Map<String, Object>();
        String myJson = '{"IPResult" : {"mensaje":"Error de datos - OCS","codigo":"TEST-OK-Sec","detalle":[{"mensaje":"Error de datos - OCS","campo":"DAT0000140"},{"mensaje":"The subscriber does not exist.","campo":"102050156"}]}}';  
        Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(myJson);    
        ErrorHandler.process(serviceTestName, requestTest, response);
    }catch(Exception ex){   
        System.assertEquals(true, ex instanceof SecurityException);    
    }
  }

  @isTest static void runPositiveValidationTestCases() {
    try{
        Map<String, Object> requestTest = new Map<String, Object>();
        String myJson = '{"IPResult" : {"mensaje":"Error de datos - OCS","codigo":"TEST-OK-Val","detalle":[{"mensaje":"Error de datos - OCS","campo":"DAT0000140"},{"mensaje":"The subscriber does not exist.","campo":"102050156"}]}}';  
        Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(myJson);    
        ErrorHandler.process(serviceTestName, requestTest, response);
    }catch(Exception ex){   
        System.assertEquals(true, ex instanceof DataValidationException);    
    }
  }

  @isTest static void runPositiveTechnicalTestCases() {
    try{
        Map<String, Object> requestTest = new Map<String, Object>();
        String myJson = '{"IPResult" : {"mensaje":"Error de datos - OCS","codigo":"TEST-OK-Tec","detalle":[{"mensaje":"Error de datos - OCS","campo":"DAT0000140"},{"mensaje":"The subscriber does not exist.","campo":"102050156"}]}}';  
        Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(myJson);    
        ErrorHandler.process(serviceTestName, requestTest, response);
    }catch(Exception ex){   
        System.assertEquals(true, ex instanceof TechnicalException);    
    }
  }

  @isTest static void runPositiveBussinessTestCases() {
    try{
        Map<String, Object> requestTest = new Map<String, Object>();
        String myJson = '{"IPResult" : {"mensaje":"Error de datos - OCS","codigo":"TEST-OK-Neg","detalle":[{"mensaje":"Error de datos - OCS","campo":"DAT0000140"},{"mensaje":"The subscriber does not exist.","campo":"102050156"}]}}';  
        Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(myJson);    
        ErrorHandler.process(serviceTestName, requestTest, response);
    }catch(Exception ex){   
        System.assertEquals(true, ex instanceof BussinessValidationException);    
    }
  }

  @isTest static void runPositiveUndefinedTestCases() {
    try{
        Map<String, Object> requestTest = new Map<String, Object>();
        String myJson = '{"IPResult" : {"mensaje":"Error de datos - OCS","codigo":"TEST-OK-Unk","detalle":[{"mensaje":"Error de datos - OCS","campo":"DAT0000140"},{"mensaje":"The subscriber does not exist.","campo":"102050156"}]}}';  
        Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(myJson);    
        ErrorHandler.process(serviceTestName, requestTest, response);
    }catch(Exception ex){   
        System.assertEquals(true, ex instanceof UndefinedException);    
    }
  }
  
  @isTest static void runNoDataFoundTestCases() {
    try{       
        Map<String, Object> requestTest = new Map<String, Object>();        
        String myJson = '{"IPResult" : {"mensaje":"Error de datos - OCS","codigo":"XXXXXX","detalle":[{"mensaje":"Error de datos - OCS","campo":"DAT0000140"},{"mensaje":"The subscriber does not exist.","campo":"102050156"}]}}';  
        Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(myJson);    
        ErrorHandler.process(serviceTestName, requestTest, response);
    }catch(Exception ex){
        System.assertEquals(true, ex instanceof NoDataFoundException);    
    }
  }
  
  @isTest static void runJSONTestCases() {
    try{   
        Map<String, Object> requestTest = new Map<String, Object>();                   
        String myJson = '{"nothing": null}';  
        Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(myJson);
        ErrorHandler.process(serviceTestName, requestTest, response);
    }catch(Exception ex){
        System.assertEquals(true, ex instanceof JSONException);    
    }
  }

}