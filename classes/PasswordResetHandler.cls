global with sharing class PasswordResetHandler implements vlocity_cmt.VlocityOpenInterface
{
    global PasswordResetHandler() {}
    global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
        System.debug('holaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa como estas');
        Boolean result = true;
        try
        {
            if (methodName.equals('PasswordReset'))
            {      
           
              PasswordReset(input, outMap, options);
            }
            
            result = false; 
          
        } 
        catch(Exception e)
        {
        
            System.debug('PasswordReset:invokeMethod -> exception: '+e);
            result = false;
        }
        return result; 
    }


          
           
   public void PasswordReset (Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        
       System.debug('reseteo de pass');        
       String accountId = (String) inputMap.get('ContextId');  
       System.debug(accountId);            
       Account accountObject = [SELECT id, vlocity_cmt__PrimaryContactId__c FROM Account WHERE Id = :accountId];     
       Contact contactObject = [SELECT id FROM Contact WHERE Id = :accountObject.vlocity_cmt__PrimaryContactId__c LIMIT 1];         
       User userObject = [SELECT id,username,email FROM User WHERE Contact.Id  = :contactObject.id LIMIT 1]; 
       System.debug('accountId: ' + accountId);
       System.debug('contactId: ' + ContactObject.Id);
       System.debug('userId: ' + userObject.Id);
       System.debug('userName: ' + userObject.username);
       System.debug('email: ' + userObject.email);    
       
       System.resetPassword(userObject.Id, true); 
       
      //community User Dr Who   
      // System.resetPassword('0056C000000tUCcQAM', true);     
      // Site.forgotPassword('thedoctor@tardis.dev');
      
       System.debug('listo');
 
       // outMap.put('userId', userObject.Id); 
        }
  }